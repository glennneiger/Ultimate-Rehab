var InfoAboutUs = {};

InfoAboutUs.oninit = function() {}

InfoAboutUs.view = function() {
    const xs_page =
        m("div", {class: "container welcome-white-container, visible-xs-* hidden-sm hidden-md hidden-lg"}, [
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("h1", {class: "info-title"}, "About Us"),
                ]),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("p", {class: "info"}, m.trust(
                        "Serenity Software, Inc. was founded by a Real Estate Entrepreneur, licensed contractor, registered home builder, " +
                        "and Project Management Professional (PMP, expired). With 15 years in the construction and remodeling industry, " +
                        "combined with his 25 year Information Technology career, he created Ultimate Rehab Estimator, the premier tool for " +
                        "real estate entrepreneurs."
                    )),
                    m("p", {class: "info"}, m.trust(
                        "This SaaS (Software as a Service) application was designed for all real estate investors, from the newbie to the " +
                        "very experienced. It works on all platforms - Android Phones, IPhones, tablets, laptops, and desktop systems.  No " +
                        "proprietary software is required."
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Ultimate Rehab Estimator uses what we all live by&mdash;measurements, to do its job. Measure the length and width of the " +
                        "house, and/or its rooms, and the app does the rest. It calculates the square footage, then does all of the math to " +
                        "calculate the cost of labor and materials for you."
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Use Ultimate Rehab Estimator for every real estate investment opportunity!"
                    )),
                ]),
            ])
           ]);

    const sm_page =
        m("div", {class: "container welcome-white-container hidden-xs visible-sm-*"}, [
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("h1", {class: "info-title"}, "About Us"),
                ]),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-4 house-on-money"}),
                m("div", {class: "col-xs-8"}, [
                    m("p", {class: "info"}, m.trust(
                        "Serenity Software, Inc. was founded by a Real Estate Entrepreneur, licensed contractor, registered home builder, " +
                        "and Project Management Professional (PMP, expired). With 15 years in the construction and remodeling industry, " +
                        "combined with his 25 year Information Technology career, he created Ultimate Rehab Estimator, the premier tool for " +
                        "real estate entrepreneurs."
                    )),
                    m("p", {class: "info"}, m.trust(
                        "This SaaS (Software as a Service) application was designed for all real estate investors, from the newbie to the " +
                        "very experienced. It works on all platforms - Android Phones, IPhones, tablets, laptops, and desktop systems.  No " +
                        "proprietary software is required."
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Ultimate Rehab Estimator uses what we all live by&mdash;measurements, to do its job. Measure the length and width of the " +
                        "house, and/or its rooms, and the app does the rest. It calculates the square footage, then does all of the math to " +
                        "calculate the cost of labor and materials for you."
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Use Ultimate Rehab Estimator for every real estate investment opportunity!"
                    )),
                ]),
            ])
           ]);

    return [xs_page, sm_page];
}

var InfoWholesalers = {};

InfoWholesalers.oninit = function() {}

InfoWholesalers.view = function() {
    const xs_page =
        m("div", {class: "container welcome-white-container visible-xs-* hidden-md hidden-lg"}, [
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("h1", {class: "info-title"}, "Wholesalers"),
                ]),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("p", {class: "info"}, m.trust(
                        "As a Wholesaler, have you ever walked into a wreck of a house and said to yourself \"I have no idea what it will cost " +
                        "to repair this mess!\" And, worse, have you ever presented a deal to a buyer, and had him/her tell you something like " +
                        "\"there's no way it will only cost that!\"?"
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Whether you are brand new to real estate investment, a part-time wholesaler, or even if this is all that you do, the " +
                        "fact is unless you are a licensed contractor, you don't know what the repairs might actually cost. And, all good " +
                        "contractors are busy, and they know they are not going to get the contract to renovate a property from you&mdash;that " +
                        "comes from the owner.  So, they can't do estimates for you (at least for free)&mdash;they just do not have the time. You " +
                        "are on your own."
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Well, you were on your own! With Ultimate Rehab Estimator, you now have the tool you need to quickly calculate the " +
                        "repair costs. Your Buyer's List includes Rehabbers, and Buy-and-Hold investors who want to know, up front, whether " +
                        "your wholesale deal is something they should consider. While you will not know what \"sizzle features\" they might add, " +
                        "you can now walk through a property, and instantly know what it will cost to repair that termite damage, eliminate that " +
                        "mold, fix that hole in the wall, modernize the kitchen and/or bathrooms, replace the roof, upgrade the HVAC system and " +
                        "much more!"
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Ultimate Rehab Estimator gives you instant credibility! Your Rehabber and Buy-and-Hold clients will know that you know " +
                        "your stuff! They will see your email and reply&mdash;yes, I want to see this one! They will return your calls&mdash;let's " +
                        "schedule an appointment! With Ultimate Rehab Estimator, your business can grow&mdash;and then you are taking the next step&mdash;" +
                        "to rehab for yourself."
                    )),
                ]),
            ])
           ]);

    const md_page =
        m("div", {class: "container welcome-white-container hidden-xs hidden-sm visible-md-*"}, [
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("h1", {class: "info-title"}, "Wholesalers"),
                ]),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-8"}, [
                    m("p", {class: "info"}, m.trust(
                        "As a Wholesaler, have you ever walked into a wreck of a house and said to yourself \"I have no idea what it will cost " +
                        "to repair this mess!\" And, worse, have you ever presented a deal to a buyer, and had him/her tell you something like " +
                        "\"there's no way it will only cost that!\"?"
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Whether you are brand new to real estate investment, a part-time wholesaler, or even if this is all that you do, the " +
                        "fact is unless you are a licensed contractor, you don't know what the repairs might actually cost. And, all good " +
                        "contractors are busy, and they know they are not going to get the contract to renovate a property from you&mdash;that " +
                        "comes from the owner.  So, they can't do estimates for you (at least for free)&mdash;they just do not have the time. You " +
                        "are on your own."
                    )),
                ]),
                m("div", {class: "col-xs-4 house-on-calculator"}),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("p", {class: "info"}, m.trust(
                        "Well, you were on your own! With Ultimate Rehab Estimator, you now have the tool you need to quickly calculate the " +
                        "repair costs. Your Buyer's List includes Rehabbers, and Buy-and-Hold investors who want to know, up front, whether " +
                        "your wholesale deal is something they should consider. While you will not know what \"sizzle features\" they might add, " +
                        "you can now walk through a property, and instantly know what it will cost to repair that termite damage, eliminate that " +
                        "mold, fix that hole in the wall, modernize the kitchen and/or bathrooms, replace the roof, upgrade the HVAC system and " +
                        "much more!"
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Ultimate Rehab Estimator gives you instant credibility! Your Rehabber and Buy-and-Hold clients will know that you know " +
                        "your stuff! They will see your email and reply&mdash;yes, I want to see this one! They will return your calls&mdash;let's " +
                        "schedule an appointment! With Ultimate Rehab Estimator, your business can grow&mdash;and then you are taking the next step&mdash;" +
                        "to rehab for yourself."
                    )),
                ]),
            ]),
           ]);

    return [xs_page, md_page];
}

var InfoRehabbers = {};

InfoRehabbers.oninit = function() {}

InfoRehabbers.view = function() {
    const xs_page =
        m("div", {class: "container welcome-white-container visible-xs-* hidden-sm hidden-md hidden-lg"}, [
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("h1", {class: "info-title"}, "Rehabbers"),
                ]),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("p", {class: "info"}, m.trust(
                        "Your marketing efforts have produced results&mdash;you have properties to evaluate! But, your contractor knows you are " +
                        "not going to buy every one of them, and simply can't do an estimate for houses you are not going to close on."
                    )),
                    m("p", {class: "info"}, m.trust(
                        "You need to be able to determine if a deal is really a deal. That's where Ultimate Rehab Estimator is your best " +
                        "friend. By knowing what the repairs will cost, you can make a fair offer. And, you know if you are likely to make " +
                        "a profit. And, that is one of the reasons you got into this business, right?"
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Take your laser measuring device, or tape measure, and your phone, tablet, or laptop to the property. The seller " +
                        "sees how professional you are, and that you have the tool you need to make them an offer on the spot. You know how " +
                        "competitive this industry is&mdash;you might have recently lost a deal because you couldn't produce an offer fast " +
                        "enough&mdash;but you are at the top of your game with Ultimate Rehab Estimator. Take the measurements, tell the app what " +
                        "you want to do to the house, and it does the math for you. You can make a fair offer before you leave! Take a portable " +
                        "printer with you, and you can do it in writing!"
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Whether it is repairing a property whose maintenance has been \"deferred\", adding an addition or \"sizzle features\" " +
                        "Ultimate Rehab Estimator is the must-have app of the real estate investment world. Used by the designer (a licensed " +
                        "contractor in the State of Maryland) for his own rehabs, the app will be indispensable as you evaluate multiple properties " +
                        "a day, a week, or per month."
                    )),
                ]),
            ])
           ]);

    const sm_page =
        m("div", {class: "container welcome-white-container hidden-xs visible-sm-*"}, [
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("h1", {class: "info-title"}, "Rehabbers"),
                ]),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-4 house-on-laptop"}),
                m("div", {class: "col-xs-8"}, [
                    m("p", {class: "info"}, m.trust(
                        "Your marketing efforts have produced results&mdash;you have properties to evaluate! But, your contractor knows you are " +
                        "not going to buy every one of them, and simply can't do an estimate for houses you are not going to close on."
                    )),
                    m("p", {class: "info"}, m.trust(
                        "You need to be able to determine if a deal is really a deal. That's where Ultimate Rehab Estimator is your best " +
                        "friend. By knowing what the repairs will cost, you can make a fair offer. And, you know if you are likely to make " +
                        "a profit. And, that is one of the reasons you got into this business, right?"
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Take your laser measuring device, or tape measure, and your phone, tablet, or laptop to the property. The seller " +
                        "sees how professional you are, and that you have the tool you need to make them an offer on the spot. You know how " +
                        "competitive this industry is&mdash;you might have recently lost a deal because you couldn't produce an offer fast " +
                        "enough&mdash;but you are at the top of your game with Ultimate Rehab Estimator. Take the measurements, tell the app what " +
                        "you want to do to the house, and it does the math for you. You can make a fair offer before you leave! Take a portable " +
                        "printer with you, and you can do it in writing!"
                    )),
                    m("p", {class: "info"}, m.trust(
                        "Whether it is repairing a property whose maintenance has been \"deferred\", adding an addition or \"sizzle features\" " +
                        "Ultimate Rehab Estimator is the must-have app of the real estate investment world. Used by the designer (a licensed " +
                        "contractor in the State of Maryland) for his own rehabs, the app will be indispensable as you evaluate multiple properties " +
                        "a day, a week, or per month."
                    )),
                ]),
            ])
           ]);

    return [xs_page, sm_page];
}
