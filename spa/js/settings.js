var Settings = {}

Settings.page_type = "SETTINGS_PAGE";

Settings.oninit = function(vnode) {
    Settings.clearAlerts(vnode);
    vnode.state.submitted = false;
    vnode.state.user_data = {};
    Data.fetchCurrentUserData(function() {
        vnode.state.user_data = Data.user_data;
    });
}

Settings.view = function(vnode) {
    var payment_info = [];

    if (!vnode.state.user_data || !vnode.state.user_data["pretty_credit_card"]) {
        payment_info.push(m("li", "This account has no associated credit card."));
        payment_info.push(m("li", m("a", {href: '#', onclick: function(event) {Settings.stripeAddCreditCard(event, vnode);}}, "Add a new card.")));
    } else {
        payment_info.push(m("li", "The card for this account is " + vnode.state.user_data["pretty_credit_card"] + ". "));
        payment_info.push(m("li", m("a", {href: '#', onclick: function(event) {Settings.stripeAddCreditCard(event, vnode);}}, "Use a different card.")));
        payment_info.push(m("li", m("a", {href: '#',
                                          onclick: function() {
                                              Data.removeCreditCard(function() {
                                                // Update the Settings page
                                                Data.fetchCurrentUserData(function() {
                                                    Settings.setSuccessAlert(vnode, "Autorenew is disabled");
                                                    vnode.state.user_data = Data.user_data;
                                                });
                                              });
                                          }},
            "Disable autorenew.")));
    }

    payment_info.push(m("li", "The annual subcription to Ultimate Rehab Estimator is $79.00. "));
    if (!vnode.state.user_data || !vnode.state.user_data["active_sub_end_date"]) {
        payment_info.push(m("li", "This account does not have an active subcription."));
    } else {
        payment_info.push(m("li", "The current subscription will end on " + vnode.state.user_data["active_sub_end_date"] + "."));
    }

    return [
        m("div", {class: "row"}, [
            m("div", {class: "alert alert-warning",
                      style: { display: getCookieValue('auth') === UNVERIFIED_AUTH ? 'block' : 'none'}}, [
                "This account is unverified.  Check your inbox for the verification email.  Verified accounts have access to more features.",
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "alert alert-warning",
                      style: { display: getCookieValue('auth') === SUSPENDED_AUTH ? 'block' : 'none'}}, [
                "This account is suspended.  Update billing to immediately regain access to the account.",
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "alert alert-success",
                      style: {display: vnode.state.settings_alert_success_display},
                      id: "settings-alert-success"})
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "alert alert-danger",
                      style: {display: vnode.state.settings_alert_danger_display},
                      id: "settings-alert-danger"}),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h1", {class: "text-center"}, "Settings"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", "Billing"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, payment_info),
        ]),
        m("hr"),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", "Change Password"),
            ]),
        ]),
        m("form", [
            m("div", {class: "form-group"}, [
                m("label", {for: "password"}, "Current Password"),
                m("input", {type: "password", class: "form-control", id: "form-settings-current-password"}),
            ]),
            m("div", {class: "form-group"}, [
                m("label", {for: "password"}, "New Password"),
                m("input", {type: "password", class: "form-control", id: "form-settings-new-password"}),
            ]),
            m("div", {class: "form-group"}, [
                m("label", {for: "password"}, "Confirm New Password"),
                m("input", {type: "password", class: "form-control", id: "form-settings-confirm-new-password"}),
            ]),
            m("div", {class: "form-group"}, [
                m("button", {type: "submit",
                             class: "blue-button",
                             onclick: function(event) {
                                 event.preventDefault();
                                 Settings.onChangePassword(vnode);
                             }},
                    "Change Password"),
            ]),
        ]),
        m("hr"),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("h3", "Delete Account"),
            ]),
        ]),
        m("div", {class: "row"}, [
            m("div", {class: "col-xs-12"}, [
                m("p", "Account deletion is permanent. Are you sure you want to permanently erase all property data?"),
            ]),
        ]),
        m("form", [
            m("button", {type: "submit",
                         class: "blue-button",
                         "data-toggle": "modal",
                         "data-target": "#delete-account-modal",
                         onclick: function(event) {event.preventDefault();}},
                "Delete Account"),
        ]),
        m("div", {id: "delete-account-modal", class: "modal fade", role: "dialog"}, [
            m("div", {class: "modal-dialog"}, [
                m("div", {class: "modal-content"}, [
                    m("div", {class: "modal-header"}, [
                        m("button", {type: "button",
                                     class: "close",
                                     "data-dismiss": "modal"}, [
                            m("i", {class: "fa fa-close fa-sm"}),
                        ]),
                        m("h4", {class: "modal-title"},
                            "Yes, permanently delete my account!"),
                    ]),
                    m("div", {class: "modal-body"}, [
                        m("button", {type: "button",
                                     class: "blue-button",
                                     onclick: function() {Settings.onDeleteAccount(vnode);}},
                            "Delete"),
                    ]),
                ])
            ]),
        ]),
       ];
}

Settings.clearAlerts = function(vnode) {
    var e = document.getElementById("settings-alert-danger");
    if (e) {
        e.textContent = "";
    }
    vnode.state.settings_alert_success_display = 'none';

    e = document.getElementById("settings-alert-success");
    if (e) {
        e.textContent = "";
    }
    vnode.state.settings_alert_danger_display = 'none';
};

Settings.setDangerAlert = function(vnode, s) {
    var e = document.getElementById("settings-alert-danger");
    e.textContent = s;
    vnode.state.settings_alert_danger_display = 'block';
}

Settings.setSuccessAlert = function(vnode, s) {
    var e = document.getElementById("settings-alert-success");
    e.textContent = s;
    vnode.state.settings_alert_success_display = 'block';
}

Settings.onChangePassword = function(vnode) {
    if (vnode.state.submitted === true) {
        return;
    }
    vnode.state.submitted = true;
    Settings.clearAlerts(vnode);

    const current_password = document.getElementById("form-settings-current-password").value;
    const new_password = document.getElementById("form-settings-new-password").value;
    if (!validatePassword(new_password)) {
        Settings.setDangerAlert(vnode, VALID_PASSWORD_RULE);
        vnode.state.submitted = false;
        return;
    }
    const cnew_password = document.getElementById("form-settings-confirm-new-password").value;
    if (new_password !== cnew_password) {
        Settings.setDangerAlert(vnode, "Your new passwords don't match; please fix!");
        vnode.state.submitted = false;
        return;
    }

    const url = BACKEND_URL + "/user/" + getCookieValue("user_id") + "/passwordReset";
    const data = {
        "current_password": current_password,
        "new_password" : new_password
    };
    m.request({method: "PUT", url: url, data: data}).then(function(ok) {
        Settings.setSuccessAlert(vnode, "Password reset success!");

        e = document.getElementById("form-settings-current-password");
        e.value = '';
        e = document.getElementById("form-settings-new-password");
        e.value = '';
        e = document.getElementById("form-settings-confirm-new-password");
        e.value = '';

        vnode.state.submitted = false;
    }, function(error) {
        console.log("PUT /user/.../passwordReset error:", error);
        handleAJAXError(error);
        Settings.setDangerAlert(vnode, "Password reset failed! Make sure 'Current Password' is correct.");
        vnode.state.submitted = false;
    });
}

Settings.onDeleteAccount = function(vnode) {
    if (vnode.state.submitted === true) {
        return;
    }
    vnode.state.submitted = true;
    Settings.clearAlerts(vnode);

    const user_id = getCookieValue("user_id");
    const access_token = getCookieValue('access_token');
    const url = BACKEND_URL + "/user/" + user_id + "?access_token=" + access_token;
    m.request({method: "DELETE", url: url}).then(function(ok) {
        deleteCurrentUser();

        e = document.getElementById("form-settings-current-password");
        e.value = '';
        e = document.getElementById("form-settings-new-password");
        e.value = '';
        e = document.getElementById("form-settings-confirm-new-password");
        e.value = '';

        $('#delete-account-modal').modal('hide');
        vnode.state.submitted = false;
        m.route.set('/welcome');
    }, function(error) {
        console.log("DELETE /user/... error:", error);
        handleAJAXError(error);
        $('#delete-account-modal').modal('hide');
        vnode.state.submitted = false;
    });
}

Settings.stripeAddCreditCard = function(event, vnode) {
    // HACK
    stripe_cb = function(token) {
        Settings.clearAlerts(vnode);

        const user_id = getCookieValue("user_id");
        if (!user_id) {
            Settings.setDangerAlert(vnode, "StripCheckout.configure: unknown user_id");
            return;
        }

        const access_token = getCookieValue("access_token");
        if (!access_token) {
            Settings.setDangerAlert(vnode, "StripCheckout.configure: unknown access_token");
            return;
        }

        const url = BACKEND_URL + "/user/" + user_id + "/creditcard";
        const data = {
            access_token: access_token,
            stripe_card_token: token["id"],
        };
        m.request({method: "POST", url: url, data: data}).then(function(ok) {
            console.log("POST credit card succeeded!");
            if (getCookieValue('auth') === SUSPENDED_AUTH) {
                const url = BACKEND_URL + "/user/" + user_id + "/subscription";
                const data = { access_token: access_token, };
                m.request({method: "POST", url: url, data: data}).then(function(ok) {
                    // User will have full access after login.
                    console.log("new credit card charged successfully");
                    logoutCurrentUser();
                }, function(error) {
                    console.log("POST /user/.../subscription error:", error);
                    handleAJAXError(error);

                    // Update the Settings page
                    Data.fetchCurrentUserData(function() {
                        vnode.state.user_data = Data.user_data;
                        Settings.setDangerAlert(vnode, "Failed to charge the new credit card!");
                    });
                })
            } else {
                // Update the Settings page
                Data.fetchCurrentUserData(function() {
                    vnode.state.user_data = Data.user_data;
                    Settings.setSuccessAlert(vnode, "New Credit Card accepted!");
                });
            }
        }, function(error) {
            console.log("POST /user/.../creditcard error:", error);
            handleAJAXError(error);
            Settings.setDangerAlert(vnode, "Failed to create account. Try again later, or use a different email address!");
        });

        stripe_cb = null;
    }

    stripe_handler.open({
        name: 'Ultimate Rehab Estimator',
        description: 'Add Credit Card',
        locale: 'auto',
        zipCode: true,
        email: getCookieValue('email'),
        panelLabel: 'Submit',
        allowRememberMe: false,
    });
    event.preventDefault();
}
