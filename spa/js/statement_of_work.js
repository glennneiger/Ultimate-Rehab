var StatementOfWork = {};

StatementOfWork.page_type = "SUMMARY_PAGE";

StatementOfWork.oninit = function(vnode) {
    vnode.state.property_id = m.route.param("propertyID");
    vnode.state.vm_property = { financing: {} };
    vnode.state.vm_rooms = {};
    vnode.state.products = [];
    Data.fetchAllRoomTemplates(function() {
        vnode.state.room_templates = Data.room_templates;
        Data.fetchAllProductTemplates(function() {
            Data.fetchProperties(function() {
                Data.fetchProperty(vnode.state.property_id, function() {
                    vnode.state.vm_property = Data.properties[vnode.state.property_id];
                    Object.getOwnPropertyNames(Data.properties[vnode.state.property_id].rooms).map(function(rid, _) {
                        const vm_room = new VMRoom(Data.rooms[rid], vnode.state.vm_property);
                        vnode.state.vm_rooms[rid] = vm_room;
                        const products = StatementOfWork.getProductsFromRoom(vm_room)
                        vnode.state.products = vnode.state.products.concat(products);
                    });
                });
            });
        });
    });
}

StatementOfWork.getProductsFromRoom = function(vm_room) {
    var xs = [];
    Object.getOwnPropertyNames(vm_room.sections).forEach(function(section_name) {
        Object.getOwnPropertyNames(vm_room.sections[section_name].products).forEach(function(product_template_id) {
            const vm_product = vm_room.sections[section_name].products[product_template_id];
            const measurement_values = VMMeasurementValues(vm_room).values;
            const costs = VMProductCosts(vm_product, measurement_values);
            if (costs.quantity > 0) {
                xs.push({
                    name: vm_product.name,
                    task: vm_product.misc || 'Supply/Install',
                    room_name: prettyRoomName(vm_room.name, vm_room.template_id),
                    section_name: section_name,
                    quantity: costs.quantity,
                    labor_cost_total: costs.labor_cost_total,
                });
            }
        });
    });

    return xs;
}

StatementOfWork.view = function(vnode) {
    const financing = vnode.state.vm_property.financing;
    const all_products_cost = allProductsCost(vnode.state.vm_rooms);
    const contractor_overhead = (all_products_cost * Number(financing.contractor_profit_and_overhead)/100) || 0;

    return [
        m("div", {class: "row"},
            m("h1", {class: "text-center room-page-header"}, "Statement of Work")
        ),
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
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12 text-right"}, [
                m("h4", {class: "room-measurements-hd"}, [
                    "Contract Overhead: $" + contractor_overhead.toFixed(2)
                ]),
            ]),
        ]),
        m("table", {class: "lite-table-table table-responsive"}, [
            m("tr", {class: "lite-table-tr-heading"}, [
                m("th", {class: "hidden-xs visible-sm-* lite-table-th"}, "Task"),
                m("th", {class: "lite-table-th"}, "Materials"),
                m("th", {class: "lite-table-th"}, "Room/Section"),
                m("th", {class: "lite-table-th"}, "Labor Cost"),
            ]),
            vnode.state.products.map(function(product) {
              return m("tr", {class: "lite-table-tr"}, [
                        m("td", {class: "hidden-xs visible-sm-* lite-table-td-left"}, product.task),
                        m("td", {class: "lite-table-td-left"}, product.name),
                        m("td", {class: "lite-table-td-left"}, product.room_name + "/" + product.section_name),
                        m("td", {class: "lite-table-td-left"}, "$" + product.labor_cost_total.toFixed(2)),
              ]);
            })
        ])
    ];
}

