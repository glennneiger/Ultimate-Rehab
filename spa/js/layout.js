// Factory: Layout component
var Layout = {};
Layout.layout = function(body) {
    return {
        oninit: function(vnode) {
            vnode.state.properties = {};
            Data.fetchProperties(function() {
                vnode.state.properties = Data.properties;
            });
            vnode.tag.onbeforeupdate.apply(this,arguments)
        },
        onbeforeupdate: function(vnode, _) {
            vnode.state.property_id = m.route.param("propertyID");
        },
        view: function(vnode) {
            return [
                    m("nav", {class: "navbar navbar-default top-navbar-default"}, [
                        m("div", {class: "container"}, [
                            m("div", {class: "navbar-header"}, [
                                m("button", {class: "navbar-toggle collapsed",
                                             type: "button",
                                             "data-toggle": "collapse",
                                             "data-target": "#navbar",
                                             "aria-expanded": "false",
                                             "aria-controls": "navbar"}, [
                                    m("span", {class: "sr-only"}, "Toggle Navigation"),
                                    m("span", {class: "icon-bar"}),
                                    m("span", {class: "icon-bar"}),
                                    m("span", {class: "icon-bar"}),
                                ]),
                                m("a", {class: "navbar-brand",
                                        href: "/home",
                                        oncreate: m.route.link}, [
                                    m("img", {src: "/static/images/blue_text_logo.png",
                                              title: "Ultimate Rehab",
                                              style: {"max-height": "30px"}})
                                ]),
                            ]),
                            m("div", {id: "navbar", class: "navbar-collapse collapse"}, [
                                m("ul", {class: "nav navbar-nav"}, [
                                    m("li", {class: "dropdown"}, [
                                        m("a", {class: "dropdown-toggle " + (body.page_type === Properties.page_type ? 'top-navbar-heading-active' : 'top-navbar-heading-inactive'),
                                                "data-toggle": "dropdown",
                                                href: "#",
                                                role: "button",
                                                "aria-haspopup": true,
                                                "aria-expanded": false}, [
                                            "PROPERTIES",
                                            m("span", {class: "caret"}),
                                        ]),
                                        m("ul", {class: "dropdown-menu top-dropdown-menu"},
                                            Object.getOwnPropertyNames(vnode.state.properties).map(function(pid, _) {
                                                return m("li", {class: "top-dropdown-menu-li"},
                                                    m("a", {href: getRoomsHref(pid),
                                                            oncreate: m.route.link},
                                                        prettyPropertyName(pid)));
                                            }).concat([
                                                m("li", {class: "divider", role: "seperator"}),
                                                m("li", m("a", {href: "/home", oncreate: m.route.link}, "View All Properties")),
                                            ])
                                        ),
                                    ]),
                                    m("li", {style: {display: !!vnode.state.property_id ? "block" : "none"}, }, [
                                        m("a", {class: "dropdown-toggle " + (body.page_type === DealAnalyzer.page_type ? 'top-navbar-heading-active' : 'top-navbar-heading-inactive'),
                                                "data-toggle": "dropdown",
                                                href: "#",
                                                role: "button",
                                                "aria-haspopup": true,
                                                "aria-expanded": false}, [
                                            "SUMMARY",
                                            m("span", {class: "caret"}),
                                        ]),
                                        m("ul", {class: "dropdown-menu top-dropdown-menu"}, [
                                            m("li", m("a", {href: dealAnalyzerHref(vnode.state.property_id),
                                                            oncreate: m.route.link},
                                                "Deal Analyzer")),
                                            m("li", m("a", {href: statementOfWorkHref(vnode.state.property_id),
                                                            oncreate: m.route.link},
                                                "Statement of Work")),
                                            m("li", m("a", {href: billOfMaterialsHref(vnode.state.property_id),
                                                            oncreate: m.route.link},
                                                "Bill of Materials")),
                                        ]),
                                    ]),
                                ]),
                                m("ul", {class: "nav navbar-nav navbar-right"}, [
                                    m("li", [
                                        m("a", {class: (body.page_type === Settings.page_type ? 'top-navbar-heading-active' : 'top-navbar-heading-inactive'),
                                                href: "/settings",
                                                oncreate: m.route.link},
                                            "SETTINGS"),
                                    ]),
                                    m("li", [
                                        m("a", {class: "top-navbar-heading-inactive",
                                                onclick: logoutCurrentUser,
                                                href: "javascript:void(0);"},
                                            "LOGOUT"),
                                    ]),
                                ]),
                            ]),
                        ]),
                        m("hr", {class: "large-blue-bar"}),
                    ]),
                    m("div", {class: "container"}, [
                        m(body),
                        m("div", {class: "row"}, [
                            m("div", {class: "col-xs-12", style: {height: "50px"}}),
                        ]),
                    ]),
                    m(BottomNavbarWhiteText),
                   ];
        },
    };
};
