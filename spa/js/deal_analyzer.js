// TODO
// + All of the delayed conversion with Number() could be removed if we stored
//   the representation and value for each number.

var DealAnalyzer = {};

DealAnalyzer.page_type = "SUMMARY_PAGE";

DealAnalyzer.oninit = function(vnode) {
    const property_id = m.route.param("propertyID");
    vnode.state.vm_property = { financing: {} };
    vnode.state.vm_rooms = {};
    Data.fetchAllRoomTemplates(function() {
        Data.fetchAllProductTemplates(function() {
            Data.fetchProperties(function() {
                Data.fetchProperty(property_id, function() {
                    vnode.state.vm_property = new VMProperty(Data.properties[property_id]);
                    Object.getOwnPropertyNames(vnode.state.vm_property.rooms).map(function(rid, _) {
                        const room = Data.rooms[rid];
                        vnode.state.vm_rooms[rid] = new VMRoom(room, vnode.state.vm_property);
                    });
                });
            });
        });
    });
}

function allProductsCost(vm_rooms) {
    var x = 0;
    Object.getOwnPropertyNames(vm_rooms).forEach(function(room_id) {
        const vm_room = vm_rooms[room_id];
        Object.getOwnPropertyNames(vm_room.sections).forEach(function(section_name) {
            const vm_section = vm_room.sections[section_name];
            Object.getOwnPropertyNames(vm_section.products).forEach(function(product_template_id) {
                const vm_product = vm_section.products[product_template_id];
                const measurement_values = VMMeasurementValues(vm_room).values;
                const costs = VMProductCosts(vm_product, measurement_values);
                x += costs.materials_cost_total + costs.labor_cost_total;
            });
        });
    });

    return x;
}

DealAnalyzer.view = function(vnode) {
    // Don't show anything if we haven't fetched the property data yet.
    if (!vnode.state.vm_property.id) {
        return [
            m("div", {class: "row"},
                m("h1", {class: "text-center room-page-header"}, "DEAL ANALYZER")
            ),
            m("div", {class: "row"},
                m("hr", {class: "large-red-bar"})
            ),
        ];
    }

    const financing = vnode.state.vm_property.financing;
    const all_products_cost = allProductsCost(vnode.state.vm_rooms);
    const estimated_repair_costs = all_products_cost * (1 + (Number(financing.contractor_profit_and_overhead) + Number(financing.misc_contingency))/100);
    const maximum_allowable_offer = (Number(financing.after_repair_value) * 0.70) -Number(estimated_repair_costs);

    const total_state_county_city_property_tax = Number(financing.state_county_city_property_tax) * Number(financing.expected_hold_time);
    const total_hoa_condo_fees = Number(financing.hoa_condo_fees) * Number(financing.expected_hold_time);
    const total_insurance = Number(financing.insurance) * Number(financing.expected_hold_time);
    const total_gas_utility = Number(financing.gas_utility) * Number(financing.expected_hold_time);
    const total_electricity_utility = Number(financing.electricity_utility) * Number(financing.expected_hold_time);
    const total_water_utility = Number(financing.water_utility) * Number(financing.expected_hold_time);

    const hard_money_total = (Number(financing.first_mortgage_hard_money)/100) * Number(financing.actual_offer) +
        estimated_repair_costs;
    const hard_money_points_total = Number(financing.first_mortgage_hard_money_points)/100 * hard_money_total;
    const hard_money_interest_total = hard_money_total * (Number(financing.first_mortgage_hard_money_interest)/100) * Number(financing.expected_hold_time)/12;
    const skin_in_the_game = Math.max(Math.min(100 - Number(financing.first_mortgage_hard_money), 100), 0);
    const skin_in_the_game_total = Number(financing.actual_offer) * skin_in_the_game/100;
    const self_pay_interest_total = skin_in_the_game_total * (Number(financing.self_pay_interest)/100) * Number(financing.expected_hold_time)/12;

    const sell_realtor_fees = Number(financing.after_repair_value) * 0.06;
    // FIXME: Why do we add the `self-pay` interest?
    const total_costs = hard_money_total + hard_money_points_total + hard_money_interest_total + skin_in_the_game_total + self_pay_interest_total +
        total_state_county_city_property_tax + total_hoa_condo_fees + total_insurance + total_gas_utility + total_electricity_utility + total_water_utility +
        Number(financing.buy_escrow_attorney_fees) + Number(financing.buy_title_insurance_search_fees) +
        Number(financing.buy_other_purchase_fees) + Number(financing.sell_escrow_attorney_fees) +
        Number(financing.sell_recordation_fees) + Number(financing.sell_transfer_taxes) +
        Number(financing.sell_home_warranty) + Number(financing.sell_staging) +
        Number(financing.sell_marketing_costs) + sell_realtor_fees;

    const total_profit = Number(financing.after_repair_value) - total_costs;
    const total_roi = (total_profit/total_costs) * 100;

    return [
        m("div", {class: "row"},
            m("h1", {class: "text-center room-page-header"}, "DEAL ANALYZER")
        ),
        m("div", {class: "row"},
            m("hr", {class: "large-red-bar"})
        ),
        m("div", {class: "row", style: {"padding-bottom": "5px"}},
            m("button", {type: "button",
                         class: "btn btn-warning pull-right",
                         onclick: function(event) {
                            saveDealAnalyzer(event, vnode.state.vm_property);
                         }}, [
                m("span", {class: "glyphicon glyphicon-floppy-disk"}),
                " Save All Changes",
            ])
        ),

        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", {class: "financing-header"}, "Summary"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "After Repair Value [ARV] ($)"),
            ]),
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.after_repair_value,
                    oninput: m.withAttr("value", function(x) {
                        financing.after_repair_value = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "70% ARV ($)"),
            ]),
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: (Number(financing.after_repair_value) * 0.70).toFixed(2),
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Expected Hold Time (months)"),
            ]),
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.expected_hold_time,
                    oninput: m.withAttr("value", function(x) {
                        financing.expected_hold_time = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Contractor Profit and Overhead (%)"),
            ]),
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.contractor_profit_and_overhead,
                    oninput: m.withAttr("value", function(x) {
                        financing.contractor_profit_and_overhead = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Misc Contingency (%)"),
            ]),
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.misc_contingency,
                    oninput: m.withAttr("value", function(x) {
                        financing.misc_contingency = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Estimated Repair Costs ($)"),
            ]),
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: Number(estimated_repair_costs).toFixed(2),
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Maximum Allowable Offer ($)"),
            ]),
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: Number(maximum_allowable_offer).toFixed(2),
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Actual Offer ($)"),
            ]),
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.actual_offer,
                    oninput: m.withAttr("value", function(x) {
                        financing.actual_offer = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),

        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", {class: "financing-header"}, "Holding Costs"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Monthly State/County/City Property Tax ($)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Total ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.state_county_city_property_tax,
                    oninput: m.withAttr("value", function(x) {
                        financing.state_county_city_property_tax = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: total_state_county_city_property_tax.toFixed(2),
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Monthly HOA/Condo Fees ($)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Total ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.hoa_condo_fees,
                    oninput: m.withAttr("value", function(x) {
                        financing.hoa_condo_fees = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: total_hoa_condo_fees.toFixed(2),
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Monthly Insurance ($)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Total ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.insurance,
                    oninput: m.withAttr("value", function(x) {
                        financing.insurance = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: total_insurance.toFixed(2),
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Monthly Gas Utility ($)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Total ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.gas_utility,
                    oninput: m.withAttr("value", function(x) {
                        financing.gas_utility = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: total_gas_utility.toFixed(2),
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Monthly Electricity Utility ($)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Total ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.electricity_utility,
                    oninput: m.withAttr("value", function(x) {
                        financing.electricity_utility = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: total_electricity_utility.toFixed(2),
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Monthly Water Utility ($)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Total ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.water_utility,
                    oninput: m.withAttr("value", function(x) {
                        financing.water_utility = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: total_water_utility.toFixed(2),
                }),
            ]),
        ]),

        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", {class: "financing-header"}, "Financing Costs"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "1st Mortgage, Hard Money (%)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Cash ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.first_mortgage_hard_money,
                    oninput: m.withAttr("value", function(x) {
                        financing.first_mortgage_hard_money = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {type: "text",
                            class: "form-control",
                            readonly: true,
                            value: hard_money_total.toFixed(2)}),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "1st Mortgage, Hard Money Points"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Cash ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.first_mortgage_hard_money_points,
                    oninput: m.withAttr("value", function(x) {
                        financing.first_mortgage_hard_money_points = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {type: "text",
                            class: "form-control",
                            readonly: true,
                            value: hard_money_points_total.toFixed(2)}),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "1st Mortgage, Hard Money Interest (%)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Cash ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.first_mortgage_hard_money_interest,
                    oninput: m.withAttr("value", function(x) {
                        financing.first_mortgage_hard_money_interest = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {type: "text",
                            class: "form-control",
                            readonly: true,
                            value: hard_money_interest_total.toFixed(2)}),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Skin in the Game (%)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Cash ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: skin_in_the_game.toFixed(2),
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {type: "text",
                            class: "form-control",
                            readonly: true,
                            value: skin_in_the_game_total.toFixed(2)}),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Self-Pay Interest (%)"),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("h4", {class: "simulate-label"}, "Cash ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-6"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.self_pay_interest,
                    oninput: m.withAttr("value", function(x) {
                        financing.self_pay_interest = removeNonNumeric(x);
                    })
                }),
            ]),
            m("div", {class: "col-xs-6"}, [
                m("input", {type: "text",
                            class: "form-control",
                            readonly: true,
                            value: self_pay_interest_total.toFixed(2)}),
            ]),
        ]),

        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", {class: "financing-header"}, "Buying Costs"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Escrow/Attorney Fees ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.buy_escrow_attorney_fees,
                    oninput: m.withAttr("value", function(x) {
                        financing.buy_escrow_attorney_fees = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Title Insurance/Search Fees ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.buy_title_insurance_search_fees,
                    oninput: m.withAttr("value", function(x) {
                        financing.buy_title_insurance_search_fees = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Other Purchase Fees ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.buy_other_purchase_fees,
                    oninput: m.withAttr("value", function(x) {
                        financing.buy_other_purchase_fees = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),

        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", {class: "financing-header"}, "Selling Costs"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Escrow/Attorney Fees ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.sell_escrow_attorney_fees,
                    oninput: m.withAttr("value", function(x) {
                        financing.sell_escrow_attorney_fees = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Recordation Fees ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.sell_recordation_fees,
                    oninput: m.withAttr("value", function(x) {
                        financing.sell_recordation_fees = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Transfer Taxes ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.sell_transfer_taxes,
                    oninput: m.withAttr("value", function(x) {
                        financing.sell_transfer_taxes = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Home Warranty ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.sell_home_warranty,
                    oninput: m.withAttr("value", function(x) {
                        financing.sell_home_warranty = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Staging ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.sell_staging,
                    oninput: m.withAttr("value", function(x) {
                        financing.sell_staging = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Marketing Costs ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: financing.sell_marketing_costs,
                    oninput: m.withAttr("value", function(x) {
                        financing.sell_marketing_costs = removeNonNumeric(x);
                    })
                }),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h4", {class: "simulate-label"}, "Realtor Fees ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    value: sell_realtor_fees,
                    readonly: true,
                }),
            ]),
        ]),

        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", {class: "total-costs-header"}, "Total Costs ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-offset-3 col-xs-6 col-sm-offset-4 col-sm-4 text-center"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: total_costs.toFixed(2),
                }),
            ]),
        ]),

        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", {class: "profit-header"}, "Profit ($)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-offset-3 col-xs-6 col-sm-offset-4 col-sm-4 text-center"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: total_profit.toFixed(2),
                }),
            ]),
        ]),

        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", {class: "profit-header"}, "ROI (%)"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-offset-3 col-xs-6 col-sm-offset-4 col-sm-4 text-center"}, [
                m("input", {
                    type: "text",
                    class: "form-control",
                    readonly: true,
                    value: total_roi.toFixed(2),
                }),
            ]),
        ]),
    ];
}

function saveDealAnalyzer(event, vm_property) {
    event.target.blur();
    // Only update the `financing` field.
    const p = {
        id: vm_property.id,
        financing: vm_property.financing,
    };
    Data.updateProperties([p]);
}
