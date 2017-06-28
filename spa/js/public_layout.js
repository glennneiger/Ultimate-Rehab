// Factory: PublicLayout component
var PublicLayout = {};
PublicLayout.layout = function(body, white_text) {
    return {
        oninit: function(vnode) {
            Data.fetchProperties();
            vnode.tag.onbeforeupdate.apply(this,arguments)
        },
        onbeforeupdate: function(vnode, _) {
        },
        view: function(vnode) {
            return [
                    m("nav", {class: "navbar navbar-default top-public-navbar-default"}, [
                        m("div", {class: "container"}, [
                            m("div", {class: "navbar-header"}, [
                                m("button", {class: "navbar-toggle collapsed",
                                             type: "button",
                                             "data-toggle": "collapse",
                                             "data-target": "#public-navbar",
                                             "aria-expanded": "false",
                                             "aria-controls": "navbar"}, [
                                    m("span", {class: "sr-only"}, "Toggle Navigation"),
                                    m("span", {class: "icon-bar"}),
                                    m("span", {class: "icon-bar"}),
                                    m("span", {class: "icon-bar"}),
                                ]),
                                m("a", {class: "navbar-brand",
                                        href: "/welcome",
                                        oncreate: m.route.link}, [
                                    m("img", {src: "/static/images/white_text_logo.png",
                                              title: "Ultimate Rehab",
                                              style: {"max-height": "30px"}})
                                ]),
                            ]),
                            m("div", {id: "public-navbar", class: "navbar-collapse collapse"}, [
                                m("ul", {class: "nav navbar-nav navbar-right"}, [
                                    m("li", {class: "top-public-navbar-li"}, [
                                        m("a", {href: "/welcome", oncreate: m.route.link}, "WELCOME")
                                    ]),
                                    m("li", {class: "top-public-navbar-li"}, [
                                        m("a", {href: aboutUsHref(), oncreate: m.route.link}, "ABOUT US")
                                    ]),
                                    m("li", {class: "top-public-navbar-li"}, [
                                        m("a", {href: wholesalersHref(), oncreate: m.route.link}, "WHOLESALERS")
                                    ]),
                                    m("li", {class: "top-public-navbar-li"}, [
                                        m("a", {href: rehabbersHref(), oncreate: m.route.link}, "REHABBERS")
                                    ]),
                                    m("li", {class: "top-public-navbar-li"}, [
                                        m("a", {href: "#",
                                                onclick: function(event) {
                                                    event.preventDefault();
                                                    LoginDialog.show();
                                               }},
                                            "LOGIN"),
                                    ]),
                                ]),
                            ]),
                        ]),
                    ]),
                    m(body),
                    (white_text === true ? m(BottomNavbarWhiteText) : m(BottomNavbarBlueText)),
                    m(LoginDialog),
                    m(ForgotPasswordDialog),
                ];
        },
    };
};
