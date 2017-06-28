var Properties = {};
Properties.page_type = 'PROPERTIES_PAGE';

function VMProperty(property) {
    this.id = property.id;
    this.dirty = false;
    this.address = getTrimmedString(property.address);
    this.city = getTrimmedString(property.city);
    this.state = getTrimmedString(property.state);
    this.zip_code = getTrimmedString(property.zip_code);
    this.sq_feet_above = Number(property.sq_feet_above) || 0;
    this.sq_feet_below = Number(property.sq_feet_below) || 0;
    this.floors = Number(property.floors) || 0;
    this.vacant = !!property.vacant;
    this.year_built = Number(property.year_built) || 0;
    this.notes = getTrimmedString(property.notes);
    this.rooms = property.rooms;
    this.financing = {
        after_repair_value: Number(property.financing.after_repair_value) || 0,
        actual_offer: Number(property.financing.actual_offer) || 0,
        expected_hold_time: Number(property.financing.expected_hold_time) || 0,
        contractor_profit_and_overhead: Number(property.financing.contractor_profit_and_overhead) || 0,
        misc_contingency: Number(property.financing.misc_contingency) || 0,
        staging: Number(property.financing.staging) || 0,
        state_county_city_property_tax: Number(property.state_county_city_property_tax) || 0,
        hoa_condo_fees: Number(property.hoa_condo_fees) || 0,
        insurance: Number(property.insurance) || 0,
        gas_utility: Number(property.gas_utility) || 0,
        electricity_utility: Number(property.electricity_utility) || 0,
        water_utility: Number(property.water_utility) || 0,
        first_mortgage_hard_money: Number(property.first_mortgage_hard_money) || 0,
        first_mortgage_hard_money_points: Number(property.first_mortgage_hard_money_points) || 0,
        first_mortgage_hard_money_interest: Number(property.first_mortgage_hard_interest) || 0,
        self_pay_interest: Number(property.self_pay_interest) || 0,
        buy_escrow_attorney_fees: Number(property.buy_escrow_attorney_fees) || 0,
        buy_title_insurance_search_fees: Number(property.buy_title_insurance_search_fees) || 0,
        buy_other_purchase_fees: Number(property.buy_other_purchase_fees) || 0,
        sell_escrow_attorney_fees: Number(property.sell_escrow_attorney_fees) || 0,
        sell_recordation_fees: Number(property.sell_recordation_fees) || 0,
        sell_transfer_taxes: Number(property.sell_transfer_taxes) || 0,
        sell_home_warranty: Number(property.sell_home_warranty) || 0,
        sell_staging: Number(property.sell_staging) || 0,
        sell_marketing_costs: Number(property.sell_marketing_costs) || 0,
    };
}

Properties.oninit = function(vnode) {
    // There are some bad cases where our callback could override changes made
    // by the user to the forms if the request takes a long time.
    vnode.state.vm_properties = {};
    Data.fetchAllRoomTemplates(function() {
        Data.fetchProperties(function() {
            Object.getOwnPropertyNames(Data.properties).forEach(function(pid) {
                const p = Data.properties[pid];
                vnode.state.vm_properties[pid] = new VMProperty(p);
            });
        });
    });

    vnode.state.vm_new_property = {
        rooms: {},
        dirty: false,
    };

    vnode.state.autosave_handle = setInterval(function() {
        saveAllProperties(vnode.state.vm_properties, vnode.state.vm_new_property);
    }, 1000*60*2);
}

Properties.onremove = function(vnode) {
    clearInterval(vnode.state.autosave_handle);
}

Properties.view = function(vnode) {
    const properties_markup = Object.getOwnPropertyNames(vnode.state.vm_properties).map(function(pid, _) {
        const vm_property = vnode.state.vm_properties[pid];
        if (!vm_property || !vm_property.id) {
            // XXX?
            return m("div");
        }

        return m("div", {class: "col-xs-12 property arial-font",
                         style: {"margin-bottom": "3px"}}, [
                existingPropertyHeaderMarkup(vnode.state.vm_properties, vm_property),
                existingPropertyDataMarkup(vm_property),
               ]);
    });

    return [
        m("div", {class: "col-xs-12"}, [
            m(RememberToSave),
            m("div", {class: "row"},
                m("h1", {class: "text-center property-page-header"}, "PROPERTIES")
            ),
            m("div", {class: "row"},
                m("hr", {class: "large-red-bar"})
            ),
            m("div", {class: "row arial-font", style: {"padding-bottom": "5px"}},
                m("button", {type: "button",
                             class: "btn btn-warning pull-right",
                             onclick: function(event) {
                                event.target.blur();
                                saveAllProperties(vnode.state.vm_properties, vnode.state.vm_new_property);
                             },}, [
                    m("span", {class: "glyphicon glyphicon-floppy-disk"}),
                    " Save All Changes",
                ])
            ),
        ])
    ].concat(properties_markup).concat([
        m("div", {class: "col-xs-12 property arial-font"}, [
            newPropertyHeaderMarkup(vnode),
            newPropertyDataMarkup(vnode.state.vm_new_property),
        ])
    ]);
}

// #################################
//        Existing Property
// #################################
function propertyDataDivID(vm_property) {
    return "property-" + vm_property.id + "-section-contents";
}

function existingPropertyHeaderMarkup(vm_properties, vm_property) {
    if (!vm_property.id) {
        throw "Missing property ID";
    }

    return propertyHeaderMarkup(prettyPropertyName(vm_property.id),
        function(event) {
            // Remove focus so the button doesn't remain colored differently.
            event.target.blur();
            collapseProperty(propertyDataDivID(vm_property));
        },
        function(event) {
            event.target.blur();
            Data.deleteProperty(vm_property.id, function() {
                delete vm_properties[vm_property.id];
            });
        },
        function(event) {
            event.target.blur();
            Data.updateProperties([normalizeVMProperty(vm_property)]);
        });
}

function existingPropertyDataMarkup(vm_property) {
    if (!vm_property.id) {
        throw "Missing property ID";
    }

    return propertyDataMarkup(vm_property, propertyDataDivID(vm_property), true);
}

// #################################
//            New Property
// #################################
const NEW_PROPERTY_DIV_ID = "property-new-section-contents";

function newPropertyHeaderMarkup(vnode) {
    return propertyHeaderMarkup("New",
        function(event) {
            event.target.blur();
            collapseProperty(NEW_PROPERTY_DIV_ID);
        },
        null,
        function(event) {
            event.target.blur();
            createNewProperty(vnode.state.vm_properties, vnode.state.vm_new_property);
        });
}

function newPropertyDataMarkup(vm_new_property) {
    return propertyDataMarkup(vm_new_property, NEW_PROPERTY_DIV_ID, false);
}

// #################################
//          Generic Property
// #################################
function propertyHeaderMarkup(property_name, collapse_cb, delete_cb, save_cb) {
    const md_header =
        m("div", {class: "row property-header-row visible-md-* hidden-xs hidden-sm"}, [
            m("h1", {class: "text-center"}, [
                property_name,
                m("button", {title: "Expand/Shrink",
                             type: "button",
                             class: "btn btn-primary-outline pull-right",
                             onclick: collapse_cb},
                    m("span", {class: "property-glyphicon glyphicon glyphicon-menu-hamburger glyphicon-big"})
                ),
                m("button", {title: "Delete",
                             type: "button",
                             class: "btn btn-primary-outline pull-right",
                             style: {display: !!delete_cb ? "block" : "none"},
                             onclick: delete_cb},
                    m("span", {class: "property-glyphicon glyphicon glyphicon-trash glyphicon-big"})
                ),
                m("button", {title: "Save",
                             type: "button",
                             class: "btn btn-primary-outline pull-right",
                             onclick: save_cb},
                    m("span", {class: "property-glyphicon glyphicon glyphicon-floppy-disk glyphicon-big"})
                ),
                // HACK: Put the text into the "true center"
                m("button", {type: "button",
                             style: {"pointer-events": "none"},
                             class: "btn btn-primary-outline pull-left",
                             href: "#"},
                    m("span", {style: {color: "transparent"},
                               class: "property-glyphicon glyphicon glyphicon-menu-hamburger glyphicon-big"})
                ),
                m("button", {type: "button",
                             style: {"pointer-events": "none"},
                             class: "btn btn-primary-outline pull-left",
                             style: {display: !!delete_cb ? "block" : "none"},
                             href: "#"},
                    m("span", {style: {color: "transparent"},
                               class: "property-glyphicon glyphicon glyphicon-trash glyphicon-big"})
                ),
                m("button", {type: "button",
                             style: {"pointer-events": "none"},
                             class: "btn btn-primary-outline pull-left",
                             href: "#"},
                    m("span", {style: {color: "transparent"},
                               class: "property-glyphicon glyphicon glyphicon-floppy-disk glyphicon-big"})
                ),
            ])
           ]);

    const xs_header =
        m("div", {class: "row property-header-row visible-xs-* hidden-md hidden-lg"}, [
            m("h1", {class: "text-center"}, property_name),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12 text-center"}, [
                    m("button", {title: "Save",
                                 type: "button",
                                 class: "btn btn-primary-outline",
                                 onclick: save_cb},
                        m("span", {class: "property-glyphicon glyphicon glyphicon-floppy-disk glyphicon-big"})
                    ),
                    m("button", {title: "Delete",
                                 type: "button",
                                 class: "btn btn-primary-outline",
                                 style: {display: !!delete_cb ? "inline-block" : "none"},
                                 onclick: delete_cb},
                        m("span", {class: "property-glyphicon glyphicon glyphicon-trash glyphicon-big"})
                    ),
                    m("button", {title: "Expand/Shrink",
                                 type: "button",
                                 class: "btn btn-primary-outline",
                                 onclick: collapse_cb},
                        m("span", {class: "property-glyphicon glyphicon glyphicon-menu-hamburger glyphicon-big"})
                    ),
                ]),
            ])
           ]);

    return [xs_header, md_header];
}

function propertyDataMarkup(vm_property, div_id, new_room_link) {
    const sm_data =
        m("div", {class: "col-xs-12 property-contents visible-sm-* hidden-xs"}, [
            m("div", {class: "form"}, [
                m("div", {class: "col-xs-4"}, [
                    m("div", {class: "form-group"}, [
                        m("label", {for: "address"}, "Address"),
                        m("input", {type: "text",
                                    class: "form-control",
                                    oninput: m.withAttr("value", function(x) {
                                        vm_property.dirty = true;
                                        vm_property.address = x;
                                    }),
                                    value: vm_property.address}),
                    ]),
                    m("div", {class: "form-group"}, [
                        m("label", {for: "city"}, "City"),
                        m("input", {type: "text",
                                    class: "form-control",
                                    oninput: m.withAttr("value", function(x) {
                                        vm_property.dirty = true;
                                        vm_property.city = x;
                                    }),
                                    value: vm_property.city}),
                    ]),
                    m("div", {class: "form-group"}, [
                        m("label", {for: "state"}, "State"),
                        m("input", {type: "text",
                                    class: "form-control",
                                    oninput: m.withAttr("value", function(x) {
                                        vm_property.dirty = true;
                                        vm_property.state = x;
                                    }),
                                    value: vm_property.state}),
                    ]),
                    m("div", {class: "form-group"}, [
                        m("label", {for: "zip"}, "Zip"),
                        m("input", {type: "text",
                                    class: "form-control",
                                    oninput: m.withAttr("value", function(x) {
                                        vm_property.dirty = true;
                                        vm_property.zip_code = x;
                                    }),
                                    value: vm_property.zip_code}),
                    ]),
                ]),
                m("div", {class: "col-xs-4"}, [
                    m("div", {class: "form-group"}, [
                        m("label", {for: "sq_feet_above"}, "SQ Feet Above"),
                        m("input", {type: "text",
                                    class: "form-control",
                                    oninput: m.withAttr("value", function(x) {
                                        vm_property.dirty = true;
                                        vm_property.sq_feet_above = x;
                                    }),
                                    value: vm_property.sq_feet_above}),
                    ]),
                    m("div", {class: "form-group"}, [
                        m("label", {for: "sq_feet_below"}, "SQ Feet Below"),
                        m("input", {type: "text",
                                    class: "form-control",
                                    oninput: m.withAttr("value", function(x) {
                                        vm_property.dirty = true;
                                        vm_property.sq_feet_below = x;
                                    }),
                                    value: vm_property.sq_feet_below}),
                    ]),
                    m("div", {class: "form-group"}, [
                        m("label", {for: "floors"}, "Floors"),
                        m("input", {type: "text",
                                    class: "form-control",
                                    oninput: m.withAttr("value", function(x) {
                                        vm_property.dirty = true;
                                        vm_property.floors = x;
                                    }),
                                    value: vm_property.floors}),
                    ]),
                ]),
                m("div", {class: "col-xs-4"}, [
                    m("div", {class: "form-group"}, [
                        m("div", {class: "radio"}, [
                            m("label", {for: "vacant"}, [
                                m("input", {type: "radio",
                                            oninput: m.withAttr("checked", function(x) {
                                                vm_property.dirty = true;
                                                vm_property.vacant = true;
                                            }),
                                            checked: vm_property.vacant === true}),
                                "Vacant"
                            ]),
                        ]),
                        m("div", {class: "radio"}, [
                            m("label", {for: "occupied"}, [
                                m("input", {type: "radio",
                                            oninput: m.withAttr("checked", function(x) {
                                                vm_property.dirty = true;
                                                vm_property.vacant = false;
                                            }),
                                            checked: vm_property.vacant !== true}),
                                "Occupied"
                            ]),
                        ])
                    ]),
                    m("div", {class: "form-group"}, [
                        m("label", {for: "year_built"}, "Year Built"),
                        m("input", {type: "text",
                                    class: "form-control",
                                    oninput: m.withAttr("value", function(x) {
                                        vm_property.dirty = true;
                                        vm_property.year_built = x;
                                    }),
                                    value: vm_property.year_built}),
                    ]),
                ]),
            ]),
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
        m("div", {class: "col-xs-12 property-contents visible-xs-* hidden-sm hidden-md hidden-lg"}, [
            m("form", [
                m("div", {class: "form-group"}, [
                    m("label", {for: "address"}, "Address"),
                    m("input", {type: "text",
                                class: "form-control",
                                oninput: m.withAttr("value", function(x) {
                                    vm_property.dirty = true;
                                    vm_property.address = x;
                                }),
                                value: vm_property.address}),
                ]),
                m("div", {class: "form-group"}, [
                    m("label", {for: "city"}, "City"),
                    m("input", {type: "text",
                                class: "form-control",
                                oninput: m.withAttr("value", function(x) {
                                    vm_property.dirty = true;
                                    vm_property.city = x;
                                }),
                                value: vm_property.city}),
                ]),
                m("div", {class: "form-group"}, [
                    m("label", {for: "state"}, "State"),
                    m("input", {type: "text",
                                class: "form-control",
                                oninput: m.withAttr("value", function(x) {
                                    vm_property.dirty = true;
                                    vm_property.state = x;
                                }),
                                value: vm_property.state}),
                ]),
                m("div", {class: "form-group"}, [
                    m("label", {for: "zip"}, "Zip"),
                    m("input", {type: "text",
                                class: "form-control",
                                oninput: m.withAttr("value", function(x) {
                                    vm_property.dirty = true;
                                    vm_property.zip_code = x;
                                }),
                                value: vm_property.zip_code}),
                ]),
                m("div", {class: "form-group"}, [
                    m("label", {for: "sq_feet_above"}, "SQ Feet Above"),
                    m("input", {type: "text",
                                class: "form-control",
                                oninput: m.withAttr("value", function(x) {
                                    vm_property.dirty = true;
                                    vm_property.sq_feet_above = x;
                                }),
                                value: vm_property.sq_feet_above}),
                ]),
                m("div", {class: "form-group"}, [
                    m("label", {for: "sq_feet_below"}, "SQ Feet Below"),
                    m("input", {type: "text",
                                class: "form-control",
                                oninput: m.withAttr("value", function(x) {
                                    vm_property.dirty = true;
                                    vm_property.sq_feet_below = x;
                                }),
                                value: vm_property.sq_feet_below}),
                ]),
                m("div", {class: "form-group"}, [
                    m("label", {for: "floors"}, "Floors"),
                    m("input", {type: "text",
                                class: "form-control",
                                oninput: m.withAttr("value", function(x) {
                                    vm_property.dirty = true;
                                    vm_property.floors = x;
                                }),
                                value: vm_property.floors}),
                ]),
                m("div", {class: "form-group"}, [
                    m("div", {class: "radio"}, [
                        m("label", {for: "vacant"}, [
                            m("input", {type: "radio",
                                        oninput: m.withAttr("checked", function(x) {
                                            vm_property.dirty = true;
                                            vm_property.vacant = true;
                                        }),
                                        checked: vm_property.vacant === true}),
                            "Vacant"
                        ]),
                    ]),
                    m("div", {class: "radio"}, [
                        m("label", {for: "occupied"}, [
                            m("input", {type: "radio",
                                        oninput: m.withAttr("checked", function(x) {
                                            vm_property.dirty = true;
                                            vm_property.vacant = false;
                                        }),
                                        checked: vm_property.vacant !== true}),
                            "Occupied"
                        ]),
                    ])
                ]),
                m("div", {class: "form-group"}, [
                    m("label", {for: "year_built"}, "Year Built"),
                    m("input", {type: "text",
                                class: "form-control",
                                oninput: m.withAttr("value", function(x) {
                                    vm_property.dirty = true;
                                    vm_property.year_built = x;
                                }),
                                value: vm_property.year_built}),
                ]),
            ]),
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

    // One link per line
    for (var idx = 0; idx < normalized_rooms.length; idx += 1) {
        var room = normalized_rooms[idx];
        links.push(
            m("div", {class: "visible-xs-* hidden-sm hidden-md hidden-lg row row-eq-height",
                      style: {"margin-bottom": "10px"}}, [
                m("div", {class: "col-xs-12 property-room-link"}, [
                    m("a", {href: room.link, oncreate: m.route.link},
                        m("h1", {class: "text-center property-room-link-header"}, [
                            prettyRoomName(room.name, room.template_id),
                        ])
                    ),
                ])
            ])
        );
    }

    // Two links per line
    for (var idx = 0; idx < normalized_rooms.length; idx += 2) {
        var room_a = normalized_rooms[idx];
        var room_b = normalized_rooms[idx+1];
        if (!room_b) {
            links.push(
                m("div", {class: "visible-sm-* hidden-xs row row-eq-height",
                          style: {"margin-bottom": "10px"}}, [
                    m("div", {class: "col-sm-6"}, [
                        m("div", {class: "property-room-link"}, [
                            m("a", {href: room_a.link, oncreate: m.route.link},
                                m("h1", {class: "text-center property-room-link-header"}, [
                                    prettyRoomName(room_a.name, room_a.template_id),
                                ])
                            ),
                        ]),
                       ]),
                    m("div", {class: "col-sm-2"}),
                    m("div", {class: "col-sm-6"}, [
                       m("div", {class: "property-room-link",
                                 style: {background: "#fff"},}),
                    ]),
                ])
            );
        } else {
            links.push(
                m("div", {class: "visible-sm-* hidden-xs row row-eq-height",
                          style: {"margin-bottom": "10px"}}, [
                    m("div", {class: "col-sm-6"}, [
                       m("div", {class: "property-room-link"}, [
                            m("a", {href: room_a.link, oncreate: m.route.link},
                                m("h1", {class: "text-center property-room-link-header"}, [
                                    prettyRoomName(room_a.name, room_a.template_id),
                                ])
                            ),
                       ]),
                    ]),
                    m("div", {class: "col-sm-2"}),
                    m("div", {class: "col-sm-6"}, [
                        m("div", {class: "property-room-link"}, [
                            m("a", {href: room_b.link, oncreate: m.route.link},
                                m("h1", {class: "text-center property-room-link-header"}, [
                                    prettyRoomName(room_b.name, room_b.template_id),
                                ])
                            ),
                       ])
                    ]),
                ])
            );
        }
    }

    return links;
}

function collapseProperty(div_id) {
    if (document.getElementById(div_id).getAttribute('aria-expanded') === 'true') {
        $("#" + div_id).collapse('hide');
    } else {
        $("#" + div_id).collapse('show');
    }
}

// FIXME: Not super happy with the 'missing' handling
function normalizeVMProperty(vm_property) {
    const x = {};

    x.id = vm_property.id;

    if ('address' in vm_property) {
        x.address = getTrimmedString(vm_property.address);
    } else {
        x.address = '';
    }

    if ('city' in vm_property) {
        x.city = getTrimmedString(vm_property.city);
    } else {
        x.city = '';
    }

    if ('state' in vm_property) {
        x.state = getTrimmedString(vm_property.state);
    } else {
        x.state = '';
    }

    if ('zip_code' in vm_property) {
        x.zip_code = getTrimmedString(vm_property.zip_code);
    } else {
        x.zip_code = '';
    }

    if ('sq_feet_above' in vm_property) {
        x.sq_feet_above = Number(vm_property.sq_feet_above) || 0;
    } else {
        x.sq_feet_above = 0;
    }

    if ('sq_feet_below' in vm_property) {
        x.sq_feet_below = Number(vm_property.sq_feet_below) || 0;
    } else {
        x.sq_feet_below = 0;
    }

    if ('floors' in vm_property) {
        x.floors = Number(vm_property.floors) || 0;
    } else {
        x.floors = 0;
    }

    if ('vacant' in vm_property) {
        x.vacant = !!vm_property.vacant;
    } else {
        x.vacant = true;
    }

    if ('year_built' in vm_property) {
        x.year_built = Number(vm_property.year_built) || 0;
    } else {
        x.year_built = 1900;
    }

    if ('notes' in vm_property) {
        x.notes = getTrimmedString(vm_property.notes);
    } else {
        x.notes = '';
    }

    return x;
}

// Only save properties that have been explicitly updated in the current tab.
// This allows concurrent sessions to safely modified disjoint room sets.
function saveAllProperties(vm_properties, vm_new_property) {
    // Save the existing properties
    if (vm_properties) {
        var normalized = [];
        Object.getOwnPropertyNames(vm_properties).forEach(function(pid) {
            const p = vm_properties[pid];
            if (p && p.dirty) {
                normalized.push(normalizeVMProperty(p));
                p.dirty = false;
            }
        });
        if (normalized.length > 0) {
            Data.updateProperties(normalized);
        }
    }

    createNewProperty(vm_properties, vm_new_property);
}

function createNewProperty(vm_properties, vm_new_property) {
    // Conditionally save the new property
    if (vm_new_property.dirty === true) {
        normalized = normalizeVMProperty(vm_new_property);
        // HACK
        normalized.financing = {};
        return Data.createProperty(normalized, function(new_property) {
            new_property.rooms = {};
            vm_properties[new_property.id] = new VMProperty(new_property);
            Object.getOwnPropertyNames(vm_new_property).forEach(function(x) {
                delete vm_new_property[x];
            });
            // Reset the new property object
            vm_new_property.rooms = {};
            vm_new_property.dirty = false;
        });
    }
}
