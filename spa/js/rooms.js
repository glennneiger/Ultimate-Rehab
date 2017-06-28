var Rooms = {};

Rooms.page_type = 'PROPERTIES_PAGE';

function VMRoom(room, property) {
    const that = this;

    if (!room.id || !room.template_id || !room.property_id) {
        throw "Malformed room!";
    }
    if (!property) {
        throw 'VMRoom: Malformed property';
    }

    this.dirty = false;
    this.id = room.id;
    this.template_id = room.template_id;
    this.property_id = room.property_id;
    this.notes = getTrimmedString(property.notes);

    // Combine Room Template w/ Room
    const room_template = Data.room_templates[room.template_id];
    this.name = room.name;
    this.template_name = room_template.name;
    this.measurements = {};
    room_template.measurements.forEach(function(measurement_name) {
        const room_measure = room.measurements[measurement_name];
        that.measurements[measurement_name] = {
            name: measurement_name,
            value: (room_measure && room_measure.value) || null,
            units: (room_measure && room_measure.units) || null,
        };
    });
    this.calculated_measurements = {};
    Object.getOwnPropertyNames(room_template.calculated_measurements).forEach(function(measurement_name) {
        const x = room_template.calculated_measurements[measurement_name];
        that.calculated_measurements[measurement_name] = {
            name: measurement_name,
            show_user: !!x.show_user,
        };
        that.calculated_measurements[measurement_name].value_fn = function(ms) {
            try {
                eval('this.abc = ' + x.value_fn);
                return this.abc(ms);
            } catch (err) {
                console.log("error: exception while building 'calculated measurements' ", err);
                return 0;
            }
        }
    });

    // Combine Product Template w/ Product.
    this.sections = {};
    Object.getOwnPropertyNames(room_template.sections).forEach(function(section_name) {
        const room_template_section = room_template.sections[section_name];
        const room_section = room.sections[section_name];
        that.sections[section_name] = {
            name: section_name,
            products: {},
        }

        room_template_section.products.forEach(function(product_template_id) {
            const product_template = Data.product_templates[product_template_id];
            if (!product_template) {
                return;
            }

            var show = false, detail_value = null;
            const product = ((room_section || {})['products'] || {})[product_template.template_id];
            if (product && product.detail) {
                if (product_template.detail.name === SELECTED_DETAIL) {
                    show = product.detail.value;
                } else {
                    show = Number(product.detail.value) > 0;
                }
                detail_value = product.detail.value;
            } else {
                show = false;
                detail_value = null;
            }

            that.sections[section_name].products[product_template.template_id] = {
                template_id: product_template.template_id,
                name: product_template.name,
                shortname: product_template.shortname,
                misc: product_template.misc,
                taxable: product_template.taxable,
                materials_cost: Number(product_template.materials_cost) || 0,
                materials_cost_total_fn: product_template.materials_cost_total_fn,
                labor_cost: Number(product_template.labor_cost) || 0,
                labor_cost_total_fn: product_template.labor_cost_total_fn,
                quantity_fn: product_template.quantity_fn,
                show: show,
                dirty: false,
                detail: {
                    name: product_template.detail.name,
                    value: detail_value,
                    units: product_template.detail.units,
                },
                property_zip_code: property.zip_code,
            };
        });
    });
}

function runProductFn(fn, detail_value, measurements, quantity) {
    if (typeof fn !== 'string') {
        return 0;
    }
    try {
        eval("this.xyz = " + fn);
        return this.xyz(detail_value, measurements, quantity);
    } catch (err) {
        console.log("error: exception while computing product function ", err);
        return 0;
    }
}

function VMMeasurementValues(vm_room) {
    var show_user_measurements = {}, measurement_values = {};
    Object.getOwnPropertyNames(vm_room.measurements).forEach(function(measurement_name) {
        const x = vm_room.measurements[measurement_name];
        show_user_measurements[measurement_name] = {
            name: measurement_name,
            show_user: true,
            readonly: false,
            value: x.value,
            oninput: m.withAttr("value", function(y) {
                        x.value = removeNonNumeric(y);
                        vm_room.dirty = true;
                     }),
        }
        measurement_values[measurement_name] = Number(x.value) || 0;
    });

    Object.getOwnPropertyNames(vm_room.calculated_measurements).forEach(function(measurement_name) {
        const x = vm_room.calculated_measurements[measurement_name];
        const value = x.value_fn(measurement_values);
        if (!!x.show_user) {
            show_user_measurements[measurement_name] = {
                name: measurement_name,
                show_user: x.show_user,
                readonly: true,
                value: value,
            };
        }
        measurement_values[measurement_name] = Number(value) || 0;
    });

    return {values: measurement_values, show: show_user_measurements};
}

function VMProductCosts(vm_product, measurement_values) {
    var materials_cost_total = 0, labor_cost_total = 0, quantity = 0;
    if (vm_product.detail.name === SELECTED_DETAIL && vm_product.detail.value !== true) {
        materials_cost_total = 0;
        labor_cost_total = 0;
        quantity = 0;
    } else {
        var detail_value = Number(vm_product.detail.value);
        var sales_tax = 0, labor_factor = 1;
        var zip = vm_product.property_zip_code;
        if (typeof zip === 'string') {
            zip = zip.slice(0, 3);
            const x = STATE_PRICING[zip];
            if (vm_product.taxable === false) {
                sales_tax = 0;
            } else if (x && (typeof x.sales_tax) === 'number') {
                sales_tax = x.sales_tax;
            }
            if (x && (typeof x.labor_factor) === 'number') {
                labor_factor = x.labor_factor;
            }
        }

        quantity = Math.ceil(Number(runProductFn(vm_product.quantity_fn, detail_value, measurement_values)) || 0);
        materials_cost_total = (1 + sales_tax) * runProductFn(vm_product.materials_cost_total_fn, detail_value, measurement_values, quantity);
        labor_cost_total = labor_factor * runProductFn(vm_product.labor_cost_total_fn, detail_value, measurement_values, quantity);
    }

    return {
        materials_cost_total: materials_cost_total,
        labor_cost_total: labor_cost_total,
        quantity: quantity
    };
}

// FIXME: It really sucks that we have to use the oninit/onbeforeupdate
// trick here to get the navbar to work.
Rooms.oninit = function(vnode) {
    vnode.state.property_id = m.route.param("propertyID");

    vnode.state.room_templates = {};
    vnode.state.vm_rooms = {};
    Data.fetchAllRoomTemplates(function() {
        // Copying the data so we don't break references
        Object.getOwnPropertyNames(Data.room_templates).forEach(function(x) {
            vnode.state.room_templates[x] = Data.room_templates[x];
        });
        Data.fetchAllProductTemplates(function() {
            Data.fetchProperties(function() {
                Data.fetchProperty(vnode.state.property_id, function() {
                    const property = Data.properties[vnode.state.property_id];
                    Object.getOwnPropertyNames(Data.properties[vnode.state.property_id].rooms).map(function(rid, _) {
                        const room = Data.rooms[rid];
                        vnode.state.vm_rooms[rid] = new VMRoom(room, property);
                    });
                });
            });
        });
    });

    vnode.state.autosave_handle = setInterval(function() {
        saveAllRooms(vnode.state.property_id, vnode.state.vm_rooms);
    }, 1000*60*2);
}

Rooms.onbeforeupdate = function(vnode, _) {
    const new_property_id = m.route.param("propertyID");
    if (new_property_id != vnode.state.property_id) {
        vnode.state.property_id = new_property_id;
        Data.fetchProperties(function() {
            Data.fetchProperty(vnode.state.property_id, function() {
                vnode.state.vm_rooms = {};
                const property = Data.properties[vnode.state.property_id];
                Object.getOwnPropertyNames(Data.properties[vnode.state.property_id].rooms).map(function(rid, _) {
                    const room = Data.rooms[rid];
                    vnode.state.vm_rooms[rid] = new VMRoom(room, property);
                });
            });
        });
    }
}

Rooms.oncreate = function(vnode) {
    const show_room_id = m.route.param("roomID");
    if (show_room_id) {
        Data.fetchProperties(function() {
            Data.fetchProperty(vnode.state.property_id, function() {
                const vm_room = new VMRoom(Data.rooms[show_room_id],
                    Data.properties[vnode.state.property_id]);
                // HACK.
                setTimeout(function(){$("#" + roomDataDivID(vm_room)).collapse('show');}, 500);
            });
        });
    }
}

Rooms.onremove = function(vnode) {
    clearInterval(vnode.state.autosave_handle);
}

Rooms.view = function(vnode) {
    const rooms_markup = Object.getOwnPropertyNames(vnode.state.vm_rooms).map(function(rid, _) {
        const vm_room = vnode.state.vm_rooms[rid];
        return m("div", {class: "col-xs-12 room arial-font",
                         style: {"margin-bottom": "3px"}}, [
                existingRoomHeaderMarkup(vnode.state.vm_rooms, vm_room),
                existingRoomDataMarkup(vm_room),
               ]);
    });
    const property = Data.properties[vnode.state.property_id];

    return [
        m("div", {class: "col-xs-12"}, [
            m(RememberToSave),
            m("div", {class: "row"},
                m("h1", {class: "text-center room-page-header"}, prettyPropertyName(vnode.state.property_id, 'ROOMS'))
            ),
            m("div", {class: "row"},
                m("hr", {class: "large-red-bar"})
            ),
            m("div", {class: "row arial-font", style: {"padding-bottom": "5px"}},
                m("button", {type: "button",
                             class: "btn btn-warning pull-right",
                             onclick: function(event) {
                                event.target.blur();
                                saveAllRooms(vnode.state.property_id, vnode.state.vm_rooms);
                             },}, [
                    m("span", {class: "glyphicon glyphicon-floppy-disk"}),
                    " Save All Changes",
                ])
            ),
        ])
    ].concat(rooms_markup).concat([
        m("div", {class: "col-xs-12 room arial-font"}, [
            newRoomHeaderMarkup(vnode),
        ]),
        // HACK: Otherwise the "New Room" header picks up attributes from
        // the modal div. This is because of mithril's virtual dom diff algo.
        m("div", m("div", [
            m(NewRoomModal, {room_templates: vnode.state.room_templates,
                             property_id: vnode.state.property_id,
                             vm_rooms: vnode.state.vm_rooms}),
        ])),
    ]);
}

var NewRoomModal = {};
NewRoomModal.oninit = function(vnode) {
    vnode.state.room_templates = vnode.attrs.room_templates;
    vnode.state.vm_rooms = vnode.attrs.vm_rooms;
    vnode.state.property = {};
    vnode.state.room_name_input_div_display = 'none';

    Data.fetchProperties(function() {
        Data.fetchProperty(vnode.attrs.property_id, function() {
            vnode.state.property = Data.properties[vnode.attrs.property_id];
        });
    });
}

NewRoomModal.view = function(vnode) {
    return m("div", {id: "new-room-modal", class: "arial-font modal fade", role: "dialog"}, [
            m("div", {class: "modal-dialog"}, [
                m("div", {class: "modal-content"}, [
                    m("div", {class: "modal-header"}, [
                        m("h4", {class: "modal-title"}, "New Room"),
                    ]),
                    m("div", {class: "modal-body"}, [
                        m("form", [
                            m("div", {class: "form-group"}, [
                                m("label", {class: "room-type"}, "Interior/Exterior"),
                                m("select", {id: "modal-room-type",
                                             class: "form-control",
                                             onchange: function(event) {
                                                document.getElementById("modal-room-name").value = '';
                                                const x = document.getElementById("modal-room-type");
                                                if (-1 !== ["Bedroom", "Bathroom"].indexOf(x.value)) {
                                                    vnode.state.room_name_input_div_display = 'block';
                                                } else {
                                                    vnode.state.room_name_input_div_display = 'none';
                                                }
                                             }},
                                    Object.getOwnPropertyNames(vnode.state.room_templates).map(function(id) {
                                        const template = vnode.state.room_templates[id];
                                        return m("option", {value: template.template_id}, template.name);
                                    })
                                ),
                            ]),
                            m("div", {class: "form-group",
                                      id: "room-name-input-div",
                                      style: {display: vnode.state.room_name_input_div_display},}, [
                                m("label", {for: "room-name"}, "Room Name"),
                                m("input", {id: "modal-room-name",
                                            type: "text",
                                            class: "form-control"}),
                            ]),
                            m("button", {type: "button",
                                         class: "blue-button",
                                         onclick: function(event) {
                                             modalCreateRoom(vnode.state.vm_rooms, vnode.state.property)
                                         }},
                                "Submit"),
                        ]),
                    ]),
                ]),
            ]),
        ]);
}

function normalizeVMRoom(vm_room) {
    // Don't send superfluous product data
    var sections = {};
    Object.getOwnPropertyNames(vm_room.sections).forEach(function(section_name) {
        sections[section_name] = { products: {} };
        Object.getOwnPropertyNames(vm_room.sections[section_name].products).forEach(function(template_id) {
            const p = vm_room.sections[section_name].products[template_id];
            if (!p || p.dirty === false || !p.detail || !p.detail.name) {
                return;
            }

            sections[section_name].products[template_id] = {
                template_id: template_id,
                detail: {
                    name: p.detail.name,
                    value: p.detail.value,
                }
            }
        });
    });

    return {
        id: vm_room.id,
        sections: sections,
        measurements: vm_room.measurements,
    };
}

// Only save rooms that have been explicitly updated in the current tab. This
// allows concurrent sessions to safely modified disjoint room sets.
function saveAllRooms(property_id, vm_rooms) {
    if (!vm_rooms) {
        return;
    }

    var normalized = [];
    Object.getOwnPropertyNames(vm_rooms).forEach(function(rid) {
        const r = vm_rooms[rid];
        if (r && r.dirty == true) {
            normalized.push(normalizeVMRoom(r));
            r.dirty = false;
        }
    });
    if (normalized.length > 0) {
        Data.updateRooms(property_id, normalized);
    }
}

var modal_create_room_submitted = false;
function modalCreateRoom(vm_rooms, property) {
    if (modal_create_room_submitted === true) {
        return;
    }
    modal_create_room_submitted = true;

    const room_template_id = document.getElementById("modal-room-type").value;
    const room_name = document.getElementById("modal-room-name").value;

    return Data.createRoom(property.id, room_template_id, room_name, function(new_room) {
        vm_rooms[new_room.id] = new VMRoom(new_room, property);
        $('#new-room-modal').modal('hide');
        modal_create_room_submitted = false;
        // HACK.
        setTimeout(function(){$("#" + roomDataDivID(vm_rooms[new_room.id])).collapse('show');}, 150);
    }, function() {
        $('#new-room-modal').modal('hide');
        modal_create_room_submitted = false;
    });
}

// #################################
//          Existing Room
// #################################
function roomDataDivID(vm_room) {
    return "room-" + vm_room.id + "-section-contents";
}

function existingRoomHeaderMarkup(vm_rooms, vm_room) {
    return roomHeaderMarkup(prettyRoomName(vm_room.name, vm_room.template_id),
        function(event) {
            event.target.blur();
            const div_id = roomDataDivID(vm_room);
            if (document.getElementById(div_id).getAttribute('aria-expanded') === 'true') {
                $("#" + div_id).collapse('hide');
            } else {
                $("#" + div_id).collapse('show');
            }
        },
        function(event) {
            event.target.blur();
            Data.deleteRoom(vm_room.id, function() {
                delete vm_rooms[vm_room.id];
            });
        },
        function(event) {
            event.target.blur();
            Data.updateRooms(vm_room.property_id, [normalizeVMRoom(vm_room)]);
        }
    );
}

function cleanupMeasurementName(x) {
    if (x === 'house_height') {
        return ['HOUSE HEIGHT', m('br'), '(foundation to eave)'];
    } else if (x === 'addition_height') {
        return ['ADDITION HEIGHT', m('br'), '(foundation to eave)'];
    } else {
        return x.replace(/_/g, ' ').toUpperCase();
    }
}

// FIXME: Somewhere we must show the room type.

/////Added by Pravin

/* function propertyDataMarkup(vm_property, div_id, new_room_link) {
    const sm_data =
 m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("hr", {class: "small-red-bar"})
                ]),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"},
                    m("label", {for: "notes"}, "Notes"),
                    m("textarea", {rows: "3",
                                   class: "form-control",
                                   oninput: m.withAttr("value", function(x) {
                                       vm_property.dirty = true;
                                       vm_property.notes = x;
                                   }),
                                   value: vm_property.notes})
                ),
            ]),
            m("div", {class: "row"}, [
                m("hr", {class: "small-red-bar"})
            ]),
            roomLinksMarkup(vm_property, new_room_link),
        ]);
 const xs_data =
m("div", {class: "row"}, [
                m("hr", {class: "small-red-bar"})
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"},
                    m("label", {for: "notes"}, "Notes"),
                    m("textarea", {rows: "3",
                                   class: "form-control",
                                   oninput: m.withAttr("value", function(x) {
                                       vm_property.dirty = true;
                                       vm_property.notes = x;
                                   }),
                                   value: vm_property.notes})
                ),
            ]),
            m("div", {class: "row"}, [
                m("hr", {class: "small-red-bar"})
            ]),
            roomLinksMarkup(vm_property, new_room_link),
        ]);

    return m("div", {class: "row collapse", "aria-expanded": false, id: div_id}, [
            sm_data,
            xs_data
           ]);
}

function roomLinksMarkup(vm_property, new_room_link) {
    var links = [];

    var normalized_rooms = [];
    Object.getOwnPropertyNames(vm_property.rooms).forEach(function(room_id) {
        const r = vm_property.rooms[room_id];
        normalized_rooms.push({
            link: getRoomsHref(vm_property.id, r.id),
            name: r.name,
            template_id: r.template_id,
        });
    });
    if (new_room_link === true) {
        normalized_rooms.push({
            link: getRoomsHref(vm_property.id),
            name: 'New Room',
            template_id: null,
        });
    }

*///////


function existingRoomDataMarkup(vm_room) {
    if (!vm_room.id) {
        throw "Missing room id";
    }

    const measurement_values = VMMeasurementValues(vm_room);
    const show_user_measurement_count = Object.getOwnPropertyNames(measurement_values.show).length;

    var table_rows = [], measurements_per_line = 1;
    for (var idx = 0; idx < show_user_measurement_count; idx += measurements_per_line) {
        var cells = [];

        var name = Object.getOwnPropertyNames(measurement_values.show)[idx];
        var z = measurement_values.show[name];
        cells.push(m("td", {class: "measurements-td"}, [
                    m("h4", {class: "text-right simulate-label"}, cleanupMeasurementName(name))
                   ]));
        cells.push(m("td", {class: "measurements-td"}, [
                    m("input", {
                        type: "text",
                        size: 6,
                        class: "form-control",
                        readonly: z.readonly,
                        value: z.value,
                        oninput: z.oninput,
                    })
                   ]));

        var r = m("tr", {class: "visible-xs-* hidden-sm hidden-md hidden-lg measurements-tr"}, cells);
        table_rows.push(r);
    }

    measurements_per_line = 2;
    for (var idx = 0; idx < show_user_measurement_count; idx += measurements_per_line) {
        var cells = [];
        var name_a = Object.getOwnPropertyNames(measurement_values.show)[idx];
        var name_b = Object.getOwnPropertyNames(measurement_values.show)[idx+1];

        if (!name_b) {
            var m_a = measurement_values.show[name_a];

            cells.push(m("td", ''));
            cells.push(m("td", ''));
            cells.push(m("td", {class: "measurements-td"}, [
                        m("h4", {class: "text-right simulate-label"}, cleanupMeasurementName(name_a))
                       ]));
            cells.push(m("td", {class: "measurements-td"}, [
                        m("input", {
                            type: "text",
                            size: 6,
                            class: "form-control",
                            readonly: m_a.readonly,
                            value: m_a.value,
                            oninput: m_a.oninput,
                        })
                       ]));

        } else {
            var m_a2 = measurement_values.show[name_a];
            var m_b2 = measurement_values.show[name_b];
            cells.push(m("td", {class: "measurements-td"}, [
                        m("h4", {class: "text-right simulate-label"}, cleanupMeasurementName(name_a))
                       ]));
            cells.push(m("td", {class: "measurements-td"}, [
                        m("input", {
                            type: "text",
                            size: 6,
                            class: "form-control",
                            readonly: m_a2.readonly,
                            value: m_a2.value,
                            oninput: m_a2.oninput,
                        })
                       ]));

            cells.push(m("td", {class: "measurements-td"}, [
                        m("h4", {class: "text-right simulate-label"}, cleanupMeasurementName(name_b))
                       ]));
            cells.push(m("td", {class: "measurements-td"}, [
                        m("input", {
                            type: "text",
                            size: 6,
                            class: "form-control",
                            readonly: m_b2.readonly,
                            value: m_b2.value,
                            oninput: m_b2.oninput,
                        })
                       ]));
        }
        var r = m("tr", {class: "visible-sm-* hidden-xs measurements-tr"}, cells);
        table_rows.push(r);
    }

    return m("div", {class: "col-xs-12 collapse",
                      id: roomDataDivID(vm_room),
                      "aria-expanded": false}, [
                m("div", {class: "row"}, [
                    m("div", {class: "measurements-border pull-right"}, [
                        m("h4", {class: "text-right room-measurements-hd"}, "RoomMeasurements (Feet)"),
                        m("table", {class: "pull-right"}, table_rows),
                    ]),
                ])
            ].concat(Object.getOwnPropertyNames(vm_room.sections).map(function(section_name, _) {
                return existingSectionDataMarkup(vm_room, section_name, vm_room.sections[section_name],
                    measurement_values.values);
            })));
}

function existingSectionDataMarkup(vm_room, section_name, section, measurement_values) {
    var unselected_products = [], selected_products = [];

    // Products added to the UX remain there for the duration of the page view
    Object.getOwnPropertyNames(section.products).forEach(function(product_template_id) {
        const p = section.products[product_template_id];
        if (p.show === true) {
            selected_products.push(p);
        } else {
            unselected_products.push(p);
        }
    });

    return [
        m("div", {class: "row"}, m("h2", {class: "room-section-header"}, section.name)),
        m("table", {class: "lite-table-table"}, [
            m("tr", {class: "lite-table-tr-heading"}, [
                m("th", {class: "visible-xs-* lite-table-th"}, ""),
                m("th", {class: "visible-xs-* lite-table-th"}, ""),
                m("th", {class: "visible-sm-* hidden-xs lite-table-th"}, ""),
                m("th", {class: "visible-sm-* hidden-xs lite-table-th"}, "#"),
                m("th", {class: "visible-sm-* hidden-xs lite-table-th"}, "Materials $"),
                m("th", {class: "visible-sm-* hidden-xs lite-table-th"}, "Materials Total $"),
                m("th", {class: "visible-sm-* hidden-xs lite-table-th"}, "Labor $"),
                m("th", {class: "visible-sm-* hidden-xs lite-table-th"}, "Labor Total $"),
                m("th", {class: "visible-xs-* lite-table-th"}, "Total $"),
            ]),
            selected_products.map(function(vm_product) {
                var detail_cell = null;
                if (vm_product.detail.name === SELECTED_DETAIL) {
                    detail_cell =
                        m("td", {class: "visible-xs-* lite-table-td col-xs-2"}, [
                            m("input", {
                                type: "checkbox",
                                class: "form-control",
                                checked: vm_product.detail.value === true,
                                onclick: m.withAttr("checked", function(x) {
                                    vm_room.dirty = true;
                                    vm_product.dirty = true;
                                    vm_product.detail.value = x;
                                }),
                            })
                        ]);
                } else {
                    detail_cell =
                        m("td", {class: "visible-xs-* lite-table-td col-xs-2"}, [
                            vm_product.detail.name,
                            m("input", {
                                type: "text",
                                class: "form-control",
                                size: 6,
                                value: vm_product.detail.value,
                                oninput: m.withAttr("value", function(x) {
                                    vm_room.dirty = true;
                                    vm_product.dirty = true;
                                    vm_product.detail.value = removeNonNumeric(x);
                                }),
                            })
                        ]);
                }
                const costs = VMProductCosts(vm_product, measurement_values);

                return m("tr", {class: "lite-table-tr"}, [
                            detail_cell,
                            m("td", {class: "visible-xs-* lite-table-td-left"}, vm_product.name),
                            m("td", {class: "visible-sm-* hidden-xs lite-table-td"}, vm_product.misc),
                            m("td", {class: "visible-sm-* hidden-xs lite-table-td"}, costs.quantity),
                            m("td", {class: "visible-sm-* hidden-xs lite-table-td"}, vm_product.materials_cost),
                            m("td", {class: "visible-sm-* hidden-xs lite-table-td"}, costs.materials_cost_total.toFixed(2)),
                            m("td", {class: "visible-sm-* hidden-xs lite-table-td"}, vm_product.labor_cost),
                            m("td", {class: "visible-sm-* hidden-xs lite-table-td"}, costs.labor_cost_total.toFixed(2)),
                            m("td", {class: "visible-xs-* lite-table-td"}, (costs.materials_cost_total + costs.labor_cost_total).toFixed(2)),
                       ]);
            }),
            m("tr", {style: {border: "0px",
                             display: unselected_products.length === 0 ? 'none' : 'table-row'}}, [
                m("td", {class: "visible-xs-*",
                         style: {border: "0px", "text-align": "center"}}, [
                    m("div", {class: "dropdown",
                              style: {"margin-top" : "10px"}}, [
                        m("button", {class: "btn btn-default dropdown-toggle",
                                     type: "button",
                                     id: "products-dropdown-menu",
                                     "data-toggle": "dropdown",
                                     "aria-haspopup": true,
                                     "aria-expanded": true,
                                     style: {"background-color": "#8FC7E8",
                                             "color": "#fff",
                                             "border-radius": "10px"},}, [
                            "Products ", m("span", {class: "caret"}),
                        ]),
                        m("ul", {class: "dropdown-menu",
                                 "aria-labelledby": "products-dropdown-menu"}, [
                            unselected_products.map(function(vm_product) {
                                var name = null, title = null;
                                if (screenSize() === 'xs') {
                                    name = vm_product.shortname.slice(0, 25);
                                    if (vm_product.shortname.length > 25) {
                                        name = name.concat("...");
                                    }
                                    title = vm_product.name;
                                } else {
                                    name = vm_product.name.slice(0, 75);
                                    if (vm_product.name.length > 75) {
                                        name = name.concat("...");
                                        title = vm_product.name;
                                    } else {
                                        title = vm_product.misc;
                                    }
                                }

                                const onclick = function(event) {
                                    if (vm_product.detail.name === SELECTED_DETAIL) {
                                        vm_product.detail.value = true;
                                    } else {
                                        vm_product.detail.value = 0;
                                    }
                                    vm_product.show = true;
                                    vm_product.dirty = true;
                                }

                                return m("li",
                                        m("a", {href: "javascript:void(0);",
                                                onclick: onclick,
                                                title: title,}, [
                                            name
                                        ])
                                       );
                            })
                        ]),
                    ]),
                ]),
            ]),
        ]),
    ];
}

// #################################
//            New Room
// #################################
function newRoomHeaderMarkup() {
    return roomHeaderMarkup("New",
        function(event) { $('#new-room-modal').modal('show'); },
        null,
        null
    );
}

// #################################
//           Generic Room
// #################################
function roomHeaderMarkup(room_name, collapse_cb, delete_cb, save_cb) {
    const md_header =
        m("div", {class: "row room-header-row visible-md-* hidden-xs hidden-sm"}, [
            m("h1", {class: "text-center"}, [
                room_name,
                m("button", {title: "Expand/Shrink",
                             type: "button",
                             class: "btn btn-primary-outline pull-right",
                             onclick: collapse_cb},
                    m("span", {class: "room-glyphicon glyphicon glyphicon-menu-hamburger glyphicon-big"})
                ),
                m("button", {title: "Delete",
                             type: "button",
                             class: "btn btn-primary-outline pull-right",
                             style: {display: !!delete_cb ? "block" : "none"},
                             onclick: delete_cb},
                    m("span", {class: "room-glyphicon glyphicon glyphicon-trash glyphicon-big"})
                ),
                m("button", {title: "Save",
                             type: "button",
                             class: "btn btn-primary-outline pull-right",
                             style: {display: !!save_cb ? "block" : "none"},
                             onclick: save_cb},
                    m("span", {class: "room-glyphicon glyphicon glyphicon-floppy-disk glyphicon-big"})
                ),
                m("button", {type: "button",
                             style: {"pointer-events": "none"},
                             class: "btn btn-primary-outline pull-left",
                             href: "#"},
                    m("span", {style: {color: "transparent"},
                               class: "room-glyphicon glyphicon glyphicon-menu-hamburger glyphicon-big"})
                ),
                m("button", {type: "button",
                             style: {"pointer-events": "none"},
                             class: "btn btn-primary-outline pull-left",
                             style: {display: !!delete_cb ? "block" : "none"},
                             href: "#"},
                    m("span", {style: {color: "transparent"},
                               class: "room-glyphicon glyphicon glyphicon-trash glyphicon-big"})
                ),
                m("button", {type: "button",
                             style: {"pointer-events": "none"},
                             class: "btn btn-primary-outline pull-left",
                             style: {display: !!save_cb ? "block" : "none"},
                             href: "#"},
                    m("span", {style: {color: "transparent"},
                               class: "room-glyphicon glyphicon glyphicon-floppy-disk glyphicon-big"})
                ),
            ])
           ]);

    const xs_header =
        m("div", {class: "row room-header-row visible-xs-* hidden-md hidden-lg"}, [
            m("h1", {class: "text-center"}, room_name),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12 text-center"}, [
                    m("button", {title: "Save",
                                 type: "button",
                                 class: "btn btn-primary-outline",
                                 style: {display: !!save_cb ? "inline-block" : "none"},
                                 onclick: save_cb},
                        m("span", {class: "room-glyphicon glyphicon glyphicon-floppy-disk glyphicon-big"})
                    ),
                    m("button", {title: "Delete",
                                 type: "button",
                                 class: "btn btn-primary-outline",
                                 style: {display: !!delete_cb ? "inline-block" : "none"},
                                 onclick: delete_cb},
                        m("span", {class: "room-glyphicon glyphicon glyphicon-trash glyphicon-big"})
                    ),
                    m("button", {title: "Expand/Shrink",
                                 type: "button",
                                 class: "text-center btn btn-primary-outline",
                                 onclick: collapse_cb},
                        m("span", {class: "room-glyphicon glyphicon glyphicon-menu-hamburger glyphicon-big"})
                    ),
                ]),
            ]),
           ]);

    return [xs_header, md_header];
}
