var ForgotPasswordDialog = {};

ForgotPasswordDialog.show = function() {
    $('#forgot-password-dialog').modal('show');
}

ForgotPasswordDialog.hide = function() {
    $('#forgot-password-dialog').modal('hide');
}

ForgotPasswordDialog.oninit = function(vnode) {
    ForgotPasswordDialog.clearAlerts(vnode);
    vnode.state.submitted = false;
}

ForgotPasswordDialog.view = function(vnode) {
    return m("div", {id: "forgot-password-dialog", class: "modal fade", role: "dialog"}, [
            m("div", {class: "modal-dialog"}, [
                m("div", {class: "modal-content"}, [
                    m("div", {class: "modal-header"}, [
                        m("h4", {class: "modal-title"}, "Reset Password"),
                        m("div", {class: "alert alert-success",
                                  style: { display: vnode.state.forgot_password_dialog_alert_success_display },
                                  id: "forgot-password-dialog-alert-success"}),
                        m("div", {class: "alert alert-danger",
                                  style: { display: vnode.state.forgot_password_dialog_alert_danger_display },
                                  id: "forgot-password-dialog-alert-danger"}),
                    ]),
                    m("div", {class: "modal-body"}, [
                        m("div", {class: "form-group"}, [
                            m("label", {for: "email"}, "Email"),
                            m("input", {id: "forgot-password-dialog-email",
                                        type: "email",
                                        class: "form-control"}),
                        ]),
                        m("button", {type: "submit",
                                     class: "blue-button",
                                     onclick: function() {ForgotPasswordDialog.submit(vnode);}},
                            "Submit"),
                    ]),
                ]),
            ]),
           ]);
}

ForgotPasswordDialog.clearAlerts = function(vnode) {
    var e = document.getElementById("forgot-password-dialog-alert-success");
    if (e) {
        e.textContent = "";
    }
    vnode.state.forgot_password_dialog_alert_success_display = 'none';

    e = document.getElementById("forgot-password-dialog-alert-danger");
    if (e) {
        e.textContent = "";
    }
    vnode.state.forgot_password_dialog_alert_danger_display = 'none';
}

ForgotPasswordDialog.submit = function(vnode) {
    if (vnode.state.submitted === true) {
        return;
    }
    vnode.state.submitted = true;
    ForgotPasswordDialog.clearAlerts(vnode);

    const email = document.getElementById("forgot-password-dialog-email").value;
    if (!validateEmail(email)) {
        var e = document.getElementById("forgot-password-dialog-alert-danger");
        e.textContent = "Enter a valid email address.";
        vnode.state.forgot_password_dialog_alert_danger_display = 'block';
        vnode.state.submitted = false;
        return;
    }

    const url = BACKEND_URL + "/public/user/" + email + "/passwordReset";
    m.request({method: "GET", url: url}).then(function(ok) {
        var e = document.getElementById("forgot-password-dialog-alert-success");
        e.textContent = "Check your email for a reset message!";
        vnode.state.forgot_password_dialog_alert_success_display = 'block';

        e = document.getElementById("forgot-password-dialog-email");
        e.value = '';
        vnode.state.submitted = false;
    }, function(error) {
        console.log("GET /public/user/.../passwordReset failed:", error);
        handleAJAXError(error);
        var e = document.getElementById("forgot-password-dialog-alert-danger");
        e.textContent = "Failed to reset password. Try again later, or create a new account!";
        vnode.state.forgot_password_dialog_alert_danger_display = 'block';
        vnode.state.submitted = false;
    });
}
