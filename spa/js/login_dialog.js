var LoginDialog = {};
LoginDialog.show = function() {
    $('#login-dialog').modal('show');
}

LoginDialog.hide = function() {
    $('#login-dialog').modal('hide');
}
LoginDialog.oninit = function(vnode) {
    deleteCurrentUser();
    LoginDialog.clearAlerts(vnode);
    vnode.state.submitted = false;
}

LoginDialog.view = function(vnode) {
    return m("div", {id: "login-dialog", class: "modal fade", role: "dialog"}, [
            m("div", {class: "modal-dialog"}, [
                m("div", {class: "modal-content"}, [
                    m("div", {class: "modal-header"}, [
                        m("h4", {class: "modal-title"}, "Login"),
                        m("div", {class: "alert alert-danger",
                                  style: { display: vnode.state.login_dialog_alert_danger_display },
                                  id: "login-dialog-alert-danger"}),
                    ]),
                    m("div", {class: "modal-body"}, [
                        m("form", [
                            m("div", {class: "form-group"}, [
                                m("label", {for: "email"}, "Email"),
                                m("input", {id: "login-dialog-email",
                                            type: "email",
                                            class: "form-control",}),
                            ]),
                            m("div", {class: "form-group"}, [
                                m("label", {for: "password"}, "Password"),
                                m("input", {id: "login-dialog-password",
                                            type: "password",
                                            class: "form-control"}),
                            ]),
                            m("button", {type: "submit",
                                         class: "blue-button",
                                         onclick: function(event) {
                                             event.preventDefault();
                                             LoginDialog.signIn(vnode);
                                         }},
                                "Submit"),
                        ]),
                    ]),
                    m("div", {class: "modal-footer"}, [
                        m("div", {class: "pull-left"}, [
                            "Not a member? ",
                            m("a", {href: "/createAccount",
                                    oncreate: m.route.link,
                                    onclick: function() { LoginDialog.hide(); },},
                                "Sign Up Now"),
                        ]),
                        m("div", {class: "pull-right"}, [
                            m("a", {href: "#",
                                    onclick: function() {
                                        LoginDialog.hide();
                                        ForgotPasswordDialog.show();
                                    }},
                                "Forgot password"),
                        ]),
                    ])
                ]),
            ]),
           ]);
}

LoginDialog.clearAlerts = function(vnode) {
    var e = document.getElementById("login-dialog-alert-danger");
    if (e) {
        e.textContent = "";
    }
    vnode.state.login_dialog_alert_danger_display = 'none';
}

LoginDialog.setDangerAlert = function(vnode, s) {
    var e = document.getElementById("login-dialog-alert-danger");
    e.textContent = s;
    vnode.state.login_dialog_alert_danger_display = 'block';
}

LoginDialog.signIn = function(vnode) {
    if (vnode.state.submitted === true) {
        return;
    }
    vnode.state.submitted = true;
    LoginDialog.clearAlerts(vnode);

    const email = document.getElementById("login-dialog-email").value;
    if (!validateEmail(email)) {
        LoginDialog.setDangerAlert(vnode, VALID_EMAIL_RULE);
        vnode.state.submitted = false;
        return;
    }
    const password = document.getElementById("login-dialog-password").value;
    if (!validatePassword(password)) {
        LoginDialog.setDangerAlert(vnode, VALID_PASSWORD_RULE);
        vnode.state.submitted = false;
        return;
    }

    // Use POST so the backend doesn't log plaintext passwords in query param.
    const url = BACKEND_URL + "/public/user/" + email + "/login";
    const data = { 'password' : password };
    m.request({method: "POST", url: url, data:data}).then(function(ok) {
        const email = ok["email"];
        const user_id = ok["user_id"];
        const access_token = ok["access_token"];
        const auth = ok["auth"];
        if (!setCurrentUser(email, user_id, access_token, auth)) {
            LoginDialog.setDangerAlert(vnode, "Failed to login. Try again later, or create a new account!");
            vnode.state.submitted = false;
            return;
        }
        LoginDialog.hide();
        vnode.state.submitted = false;
        m.route.set('/home');
    }, function(error) {
        console.log("GET /public/user/.../login error:", error);
        handleAJAXError(error);
        LoginDialog.setDangerAlert(vnode, "Failed to login. Try again later, or create a new account!");
        vnode.state.submitted = false;
    });
}
