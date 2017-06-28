var RememberToSave = {};

RememberToSave.oninit = function(vnode) {
    if (getCookieValue('remember_to_save') === 'ok') {
        vnode.state.display = 'none';
    } else {
        vnode.state.display = 'block';
    }
}

RememberToSave.view = function(vnode) {
    return m("div", {class: "row"}, [
            m("div", {class: "alert alert-warning",
                      style: { display: vnode.state.display },
                      id: "create-account-alert-success"}, [
                m("a", {href: "#",
                        class: "close",
                        "data-dismiss": "alert",
                        "aria-label": "close",
                        onclick: function(event) {
                            document.cookie = 'remember_to_save=ok';
                        }},
                    m.trust("&times;")),
                "Remember to save your changes before leaving the page!"
            ]),
           ]);
}
