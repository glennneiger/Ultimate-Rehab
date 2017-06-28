BottomNavbarBlueText = {};
BottomNavbarBlueText.view = function(vnode) {
    return m("footer", {class: "footer-blue-text"}, [
            m("nav", {class: "navbar navbar-default bottom-navbar-blue-text"}, [
                m("div", {class: "container"}, [
                    m("ul", {class: "nav navbar-nav bottom-navbar-blue-text-ul",
                             style: {width: "100%"},}, [
                        m("li", {class: "bottom-navbar-blue-text-li"}, [
                            m("a", {href: "/welcome", oncreate: m.route.link}, "WELCOME")
                        ]),
                        m("li", {class: "bottom-navbar-blue-text-li"}, [
                            m("a", {href: aboutUsHref(), oncreate: m.route.link}, "ABOUT US")
                        ]),
                        m("li", {class: "bottom-navbar-blue-text-li"}, [
                            m("a", {href: wholesalersHref(), oncreate: m.route.link}, "WHOLESALERS")
                        ]),
                        m("li", {class: "bottom-navbar-blue-text-li"}, [
                            m("a", {href: rehabbersHref(), oncreate: m.route.link}, "REHABBERS")
                        ]),
                        m("li", {class: "bottom-navbar-blue-text-li"}, [
                            m("a", {href: "#",
                                    onclick: function(event) {
                                        LoginDialog.show();
                                   }},
                                "LOGIN"),
                        ]),
                    ]),
                ]),
            ])
           ]);
};

BottomNavbarWhiteText = {};
BottomNavbarWhiteText.view = function(vnode) {
    return m("footer", {class: "footer-white-text"}, [
            m("nav", {class: "navbar navbar-default bottom-navbar-white-text"}, [
                m("div", {class: "container"}, [
                    m("ul", {class: "nav navbar-nav bottom-navbar-white-text-ul",
                             style: {width: "100%"},}, [
                        m("li", {class: "bottom-navbar-white-text-li"}, [
                            m("a", {href: "/welcome", oncreate: m.route.link}, "WELCOME")
                        ]),
                        m("li", {class: "bottom-navbar-white-text-li"}, [
                            m("a", {href: aboutUsHref(), oncreate: m.route.link}, "ABOUT US")
                        ]),
                        m("li", {class: "bottom-navbar-white-text-li"}, [
                            m("a", {href: wholesalersHref(), oncreate: m.route.link}, "WHOLESALERS")
                        ]),
                        m("li", {class: "bottom-navbar-white-text-li"}, [
                            m("a", {href: rehabbersHref(), oncreate: m.route.link}, "REHABBERS")
                        ]),
                        m("li", {class: "bottom-navbar-white-text-li"}, [
                            m("a", {href: "#",
                                    onclick: function(event) {
                                        LoginDialog.show();
                                   }},
                                "LOGIN"),
                        ]),
                    ]),
                    m("ul", {class: "nav navbar-nav bottom-navbar-white-text-ul",
                             style: {width: "100%"},}, [
                        m("li", {class: "bottom-navbar-white-text-li"}, [
                            "(410) 489-4944"
                        ]),
                        m("li", {class: "bottom-navbar-white-text-li"}, [
                            m("a", {href: "mailto:sales@ultimaterehabestimator.com"}, "sales@ultimaterehabestimator.com")
                        ]),
                    ]),
                ]),
            ])
        ]);
};
