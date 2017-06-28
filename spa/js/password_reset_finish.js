var PasswordResetFinish = {};

PasswordResetFinish.oninit = function(vnode) {
    vnode.state.password_reset_token = m.route.param("password_reset_token");
    vnode.state.user_id = m.route.param("user_id");
    PasswordResetFinish.clearAlerts(vnode);
    vnode.state.submitted = false;
}

PasswordResetFinish.view = function(vnode) {
    return m("div", {class: "container"}, [
            m("div", {class: "col-xs-12"}, [
                m("div", {class: "row"}, [
                    m("div", {class: "alert alert-danger",
                              style: {display: vnode.state.password_reset_finish_alert_danger_display},
                               id: "password-reset-finish-alert-danger"}),
                ]),
                m("div", {class: "row"}, [
                    m("h3", "Finish Password Reset")
                ]),
                m("div", {class: "row"}, [
                    m("label", {for: "password"}, "New Password"),
                    m("input", {type: "password", class: "form-control", id: "form-password-reset-finish-password"}),
                ]),
                m("div", {class: "row"}, [
                    m("label", {for: "password"}, "Confirm Password"),
                    m("input", {type: "password", class: "form-control", id: "form-password-reset-finish-confirm-password"}),
                ]),
                m("div", {class: "row"}, [
                    m("button", {type: "submit",
                                 class: "btn btn-default",
                                 onclick: function() {PasswordResetFinish.onSubmit(vnode);}},
                        "Submit"),
                ]),
            ])
           ]);
}

PasswordResetFinish.clearAlerts = function(vnode) {
    e = document.getElementById("password-reset-finish-alert-danger");
    if (e) {
        e.textContent = "";
    }
    vnode.state.password_reset_finish_alert_danger_display = 'none';
}

PasswordResetFinish.setDangerAlert = function(vnode, s) {
    var e = document.getElementById("password-reset-finish-alert-danger");
    e.textContent = s;
    vnode.state.password_reset_finish_alert_danger_display = 'block';
}

PasswordResetFinish.onSubmit = function(vnode) {
    if (vnode.state.submitted === true) {
        return;
    }
    vnode.state.submitted = true;
    PasswordResetFinish.clearAlerts(vnode);

    const password = document.getElementById("form-password-reset-finish-password").value;
    if (!validatePassword(password)) {
        PasswordResetFinish.setDangerAlert(vnode, VALID_PASSWORD_RULE);
        vnode.state.submitted = false;
        return;
    }
    const cpassword = document.getElementById("form-password-reset-finish-confirm-password").value;
    if (password !== cpassword) {
        console.log("Passwords don't match!");
        PasswordResetFinish.setDangerAlert(vnode, "Your passwords don't match; please fix!");
        vnode.state.submitted = false;
        return;
    }

    const url = BACKEND_URL + "/user/" + vnode.state.user_id + "/passwordReset/verify";
    const data = {
        "password_reset_token": vnode.state.password_reset_token,
        "password" : password
    };
    m.request({method: "PUT", url: url, data: data}).then(function(ok) {
        console.log("passwordResetFinish c/b: ", ok);
        m.route.set('/welcome');
    }, function(error) {
        console.log("PUT /user/.../passwordReset/verify error:", error);
        handleAJAXError(error);
        PasswordResetFinish.setDangerAlert(vnode, "Your password reset request was rejected!");
        vnode.state.submitted = false;
    });
}
