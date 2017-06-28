var Welcome = {};

Welcome.oninit = function(vnode) { }

Welcome.view = function(vnode) {
    const xs_page =
        m("div", {class: "container welcome-white-container visible-xs-* hidden-md hidden-lg"}, [
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("h1", {class: "blue-house-title text-center"}, "Ultimate Rehab Estimator"),
                    m("h2", {class: "blue-house-subtitle text-center"}, "Wholesalers, Rehabbers and Contractors"),
                ]),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-6"}, [
                    m("button", {type: "button",
                                 class: "blue-house-button",
                                 href: "/createAccount",
                                 oncreate: m.route.link}, [
                        "Create Account"
                    ]),
                ]),
                m("div", {class: "col-xs-6"}, [
                    m("button", {type: "button",
                                 class: "blue-house-button",
                                 href: "#",
                                 onclick: function(event) {
                                     event.preventDefault();
                                     LoginDialog.show();
                                 }}, [
                        "Login"
                    ]),
                ]),
            ]),
            m("hr", {class: "tiny-red-bar"}),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("h1", {class: "info-title-small text-center"}, "By Investors, For Investors"),
                    m("p", {class: "info text-justify"},
                        "Designed BY REAL estate investors for real estate investors, Ultimate Rehab Estimator allows Wholesalers, " +
                        "Rehabbers, Contractors, and even the Do-It-Yourselfer to quickly calculate the costs of upgrading an investment " +
                        "property just by measuring the house (exterior), or the rooms (interior). Simply measure, tell the app what you " +
                        "want to do (refinish, repair, or replace any part of any house), and it produces a Statement of Work, and a Bill " +
                        "of Materials. Ultimate Rehab Estimator also includes a Deal Analyzer, which, combined with your data, helps every " +
                        "investor determine if the deal is real. And, the app adjusts for the varying costs of labor by state, and for " +
                        "sales tax, which also varies by state, by the zip code of the property."),
                    m("p", {class: "info text-justify"}, "Use Ultimate Rehab Estimator for every real estate investment opportunity!"),
                ]),
            ]),
        ]);

    const md_page =
        m("div", {class: "container welcome-white-container hidden-xs hidden-sm visible-md-*"}, [
            m("div", {class: "col-xs-12"}, [
                m("div", {class: "row"}, [
                    m("div", {class: "col-xs-6"}, [
                        m("div", {class: "row"}, [
                            m("h1", {class: "blue-house-title"}, "Ultimate Rehab Estimator"),
                            m("h2", {class: "blue-house-subtitle"}, "Wholesalers, Rehabbers and Contractors"),
                        ]),
                        m("div", {class: "row"}, [
                            m("div", {class: "col-xs-5"}, [
                                m("button", {type: "button",
                                             class: "blue-house-button",
                                             href: "/createAccount",
                                             oncreate: m.route.link}, [
                                    "Create Account"
                                ]),
                            ]),
                            m("div", {class: "col-xs-5"}, [
                                m("button", {type: "button",
                                             class: "blue-house-button",
                                             href: "#",
                                             onclick: function(event) {
                                                 event.preventDefault();
                                                 LoginDialog.show();
                                             }}, [
                                    "Login"
                                ]),
                            ]),
                        ]),
                    ]),
                    m("div", {class: "col-xs-6 blueprint-house"}, [ ]),
                ]),
                m("hr", {class: "tiny-red-bar"}),
                m("div", {class: "row"}, [
                    m("div", {class: "col-xs-12"}, [
                        m("h1", {class: "info-title text-center"}, "By Investors, For Investors"),
                        m("p", {class: "info text-justify"},
                            "Designed by real estate investors for real estate investors, Ultimate Rehab Estimator allows Wholesalers, " +
                            "Rehabbers, Contractors, and even the Do-It-Yourselfer to quickly calculate the costs of upgrading an investment " +
                            "property just by measuring the house (exterior), or the rooms (interior). Simply measure, tell the app what you " +
                            "want to do (refinish, repair, or replace any part of any house), and it produces a Statement of Work, and a Bill " +
                            "of Materials. Ultimate Rehab Estimator also includes a Deal Analyzer, which, combined with your data, helps every " +
                            "investor determine if the deal is real. And, the app adjusts for the varying costs of labor by state, and for " +
                            "sales tax, which also varies by state, by the zip code of the property."),
                        m("p", {class: "info text-justify"}, "Use Ultimate Rehab Estimator for every real estate investment opportunity!"),
                    ]),
                ]),
            ])
        ]);

    return [xs_page, md_page];
}
