var BillOfMaterials = {};

BillOfMaterials.page_type = "SUMMARY_PAGE";

BillOfMaterials.oninit = function(vnode) {
    vnode.state.property_id = m.route.param("propertyID");
    vnode.state.vm_property = {};
    vnode.state.products = [];
    Data.fetchAllRoomTemplates(function() {
        vnode.state.room_templates = Data.room_templates;
        Data.fetchAllProductTemplates(function() {
            Data.fetchProperties(function() {
                vnode.state.vm_property = Data.properties[vnode.state.property_id];
                Data.fetchProperty(vnode.state.property_id, function() {
                    Object.getOwnPropertyNames(Data.properties[vnode.state.property_id].rooms).map(function(rid, _) {
                        const vm_room = new VMRoom(Data.rooms[rid], vnode.state.vm_property);
                        const products = BillOfMaterials.getProductsFromRoom(vm_room)
                        vnode.state.products = vnode.state.products.concat(products);
                    });
                });
            });
        });
    });
}

BillOfMaterials.getProductsFromRoom = function(vm_room) {
    var xs = [];
    Object.getOwnPropertyNames(vm_room.sections).forEach(function(section_name) {
        Object.getOwnPropertyNames(vm_room.sections[section_name].products).forEach(function(product_template_id) {
            const vm_product = vm_room.sections[section_name].products[product_template_id];
            const measurement_values = VMMeasurementValues(vm_room).values;
            const costs = VMProductCosts(vm_product, measurement_values);
            if (costs.quantity > 0 && costs.materials_cost_total > 0) {
                xs.push({
                    name: vm_product.name,
                    room_name: prettyRoomName(vm_room.name, vm_room.template_id),
                    quantity: costs.quantity,
                    materials_cost_total: costs.materials_cost_total,
                });
            }
        });
    });

    return xs;
}

BillOfMaterials.view = function(vnode) {
    return [
        m("div", {class: "row"}, [
            m("h1", {class: "text-center room-page-header"}, "Bill of Materials"),
        ]),
        addressTag(vnode.state.vm_property),
        m("div", {class: "row"},
            m("hr", {class: "large-red-bar"})
        ),
        m("div", {class: "row arial-font", style: {"padding-bottom": "5px"}}, [
            m("div", {class: "col-xs-12"}, [
                m("button", {type: "button",
                             class: "btn btn-success pull-right",
                             onclick: function(event) { window.print(); },}, [
                    m("span", {class: "glyphicon glyphicon-print"}),
                    " Print",
                ])
            ]),
        ]),
        m("table", {class: "lite-table-table"}, [
            m("tr", {class: "lite-table-tr-heading"}, [
                m("th", {class: "lite-table-th"}, "Materials"),
                m("th", {class: "lite-table-th hidden-xs-* visible-sm visible-md visible-lg"}, "Room"),
                m("th", {class: "lite-table-th"}, "Quantity"),
                m("th", {class: "lite-table-th"}, "Materials Cost"),
            ]),
            vnode.state.products.map(function(product) {
              return m("tr", {class: "lite-table-tr"}, [
                        m("td", {class: "lite-table-td-left"}, product.name),
                        m("td", {class: "lite-table-td-left hidden-xs-* visible-sm visible-md visible-lg"}, product.room_name),
                        // FIXME: Show units
                        m("td", {class: "lite-table-td-left"}, product.quantity),
                        m("td", {class: "lite-table-td-left"}, "$" + product.materials_cost_total.toFixed(2)),
              ]);
            })
        ])
    ];
}

