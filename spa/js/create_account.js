var CreateAccount = {};

CreateAccount.oninit = function(vnode) {
    CreateAccount.clearAlerts(vnode);
    vnode.state.submitted = false;
    vnode.state.stripe_card_token = null;
}

CreateAccount.view = function(vnode) {
    var submit_button_attribs = {
        type: "submit",
        class: "blue-button",
        onclick: function() {
            CreateAccount.submit(vnode);
        }
    };
    if (vnode.state.submitted == true) {
        submit_button_attribs['class'] = 'greyed-button';
        submit_button_attribs['disabled'] = true;
    } else {
        submit_button_attribs['class'] = 'blue-button';
    }

    return m("div", {class: "container welcome-white-container"}, [
            m("div", {class: "row"}, [
                m("div", {class: "alert alert-success",
                          style: { display: vnode.state.create_account_alert_success_display },
                          id: "create-account-alert-success"}),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "alert alert-danger",
                          style: { display: vnode.state.create_account_alert_danger_display },
                          id: "create-account-alert-danger"}),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("h3", "Create Account")
                ]),
            ]),
            m("div", {class: "row"}, [
                m("div", {class: "col-xs-12"}, [
                    m("label", {for: "name"}, "Name"),
                    m("input", {type: "text", class: "form-control", id: "create-account-name"}),
                    m("label", {for: "email"}, "Email"),
                    m("input", {type: "email", class: "form-control", id: "create-account-email"}),
                    m("label", {for: "password"}, "Password"),
                    m("input", {type: "password", class: "form-control", id: "create-account-password"}),
                    m("label", {for: "confirm-password"}, "Confirm Password"),
                    m("input", {type: "password", class: "form-control", id: "create-account-confirm-password"}),
                    m("h3", "Payment"),
                    m("p", "New subscribers receive free access to Ultimate Rehab Estimator for 7 days.  After 7 days, you will be charged $79.00 for a one year subscription."),
                    m("a", {href: '#',
                            onclick: function(event) {CreateAccount.stripeAddCreditCard(event, vnode);}}, [
                        "Click here to add a credit card. ",
                        (vnode.state.stripe_card_token === null ?
                            m("span", {class: "glyphicon glyphicon-remove", style: {color: "red"}})
                            : m("span", {class: "glyphicon glyphicon-ok", style: {color: "green"}})),
                    ]),
                    m("h3", "Terms and Conditions"),
                    m("p", [
                        "By submitting this form, you agree to accept our ",
                        m("a", {href: '#',
                                onclick: function() { $('#privacy-dialog').modal('show'); }},
                            "privacy policy "),
                        "and ",
                        m("a", {href: '#',
                                onclick: function() { $('#disclaimer-dialog').modal('show'); }},
                            "disclaimer"),
                        ".",
                    ]),
                    m("button", submit_button_attribs, [
                        m("span", {class: "glyphicon glyphicon-repeat right-spinner",
                                   style: {display: vnode.state.submitted ? 'inline-block' : 'none'}}),
                        " Submit"
                    ]),
                ]),
            ]),
            m("div", {id: "privacy-dialog", class: "modal fade", role: "dialog"}, [
                m("div", {class: "modal-dialog"}, [
                    m("div", {class: "modal-content"}, [
                        m("div", {class: "modal-header"}, [
                            m("h4", {class: "modal-title"}, "Privacy Policy"),
                        ]),
                        m("div", {class: "modal-body"}, [
                            m("p", "Serenity Software, Inc.is creator of Ultimate Rehab Estimator in the United States. The following " +
                                   "is Serenity Software, Inc.'s online privacy policy, which governs how visitor information (your " +
                                   "information) is gathered and used on Serenity Software, Inc.'s Internet sites. Please take a few " +
                                   "minutes to read this policy carefully."),
                            m("h4", "Your Information that Serenity Software, Inc. May Collect Online"),
                            m("p", "You can affirmatively submit to Serenity Software, Inc. certain user information pertaining to " +
                                   "your interaction with Serenity Software, Inc. and the Ultimate Rehab Estimator product.  User " +
                                   "information may include a search query (such as the name and location of a business or charity) " +
                                   "or other information as described more fully below.  You can also provide location information, " +
                                   "or billing information.  We also may infer your geographic location based on your IP address or " +
                                   "other information.  User information may also include information such as your name, postal and " +
                                   "e-mail address, phone and facsimile numbers."),
                            m("p", "When you submit a comment to the Ultimate Rehab Estimator website, you also submit your " +
                                   "name and email address.  Serenity Software Inc.'s websites are not designed with the purpose of " +
                                   "attracting any person under age 18. Serenity Software Inc. does not knowingly collect or " +
                                   "maintain any personal information from children under the age of 18."),
                            m("h4", "How Serenity Software Inc. Uses Your Information"),
                            m("p", "We will use information you affirmatively submit to Serenity Software, Inc. for the purpose for " +
                                   "which it is submitted, such as to reply to your email, handle your complaint, publish your " +
                                   "comment, process billing transactions, or respond to requests related to the product. We may also " +
                                   "use such information to provide operational notices, in program record-keeping and to conduct " +
                                   "research on industry marketplace practices. We may publish aggregate data, but the aggregate " +
                                   "data will not include any unique information you provided to us.  We may use third party " +
                                   "contractors to act on our behalf, and these contractors are obligated to not disclose or use your " +
                                   "information for other purposes."),
                            m("p", "At certain points where your information is collected on our site, there may be a box where you " +
                                   "may indicate you would like to be on a mailing list to receive information about Serenity " +
                                   "Software Inc., or its products. This election box only appears in places where the service " +
                                   "collecting your information maintains such lists. You can remove your name from a Serenity " +
                                   "Software Inc. mailing list by utilizing the appropriate unsubscribe feature contained in the " +
                                   "emails."),
                            m("h4", "Cookies and Other Persistent Identifiers"),
                            m("p", "Serenity Software Inc. or third parties we contract with may use persistent identifiers such as " +
                                   "cookies, embedded scripts, beacons, tags and similar technologies for a number of purposes, " +
                                   "such as to provide easier site navigation, access to forms, analytics and advertising. You can still " +
                                   "use Serenity Software's websites if you have set your browser to reject cookies, but it may " +
                                   "prevent you from viewing or accessing some of the features of our sites."),
                            m("h4", "Uses of Persistent Identifiers for Analysis and Advertising"),
                            m("p", "Serenity Software Inc. or third parties may use identifiers to generate certain kinds of site usage " +
                                   "data, such as the number of hits and visits to our sites. This information is used to understand " +
                                   "how visitors use our sites and provide better services to you. Serenity Software, Inc. or third " +
                                   "parties may also use identifiers to personalize the display of sponsorships or advertisements and " +
                                   "customize the content you see while using our sites and sometimes while visiting other websites. " +
                                   "Serenity Software, Inc. may transfer, or allow third parties to collect, analytic information about " +
                                   "your visit to our websites to help us improve our websites and better serve you when you visit us " +
                                   "online in the future.  Analytic information may include such identifiers as your browser type, IP " +
                                   "address, referring site URL, web pages you view and links you click on while navigating within " +
                                   "our sites."),
                            m("h4", "Updates"),
                            m("p", "If Serenity Software, Inc. changes this policy in the future, we will post the changes here and " +
                                   "indicate the date of the changes at the top of the policy."),
                            m("h4", "Problems or Complaints with Serenity Software, Inc.'s Privacy Policy"),
                            m("p", "If you have a complaint about Serenity Software, Inc. compliance with this privacy policy, you " +
                                   "may contact us at sales@ultimaterehabestimator.com"),
                            m("h4", "Additional Disclosure to California Residents"),
                            m("p", "At this time we do not respond to \"do not track\" signals issued by web browsers."),
                        ]),
                    ]),
                ]),
           ]),
           m("div", {id: "disclaimer-dialog", class: "modal fade", role: "dialog"}, [
                m("div", {class: "modal-dialog"}, [
                    m("div", {class: "modal-content"}, [
                        m("div", {class: "modal-header"}, [
                            m("h4", {class: "modal-title"}, "Disclaimer"),
                        ]),
                        m("div", {class: "modal-body"}, [
                            m("p", "Last updated: March 03, 2017"),
                            m("p", "The information contained on the www.ultimaterehabestimator.com website and in the Ultimate " +
                                   "Rehab Estimator application (the \"Service\") is for general information purposes only."),
                            m("p", "Serenity Software Inc. and Ultimate Rehab Estimator assume no responsibility for errors or " +
                                   "omissions in the contents on the Service."),
                            m("p", "In no event shall Serenity Software Inc. or Ultimate Rehab Estimator be liable for any special, " +
                                   "direct, indirect, consequential, or incidental damages or any damages whatsoever, whether in an " +
                                   "action of contract, negligence or other tort, arising out of or in connection with the use of the " +
                                   "Service or the contents of the Service. Ultimate Rehab Estimator reserves the right to make " +
                                   "additions, deletions, or modification to the contents on the Service at any time without prior " +
                                   "notice."),
                            m("p", "Ultimate Rehab Estimator is for ESTIMATING purposes ONLY. Your labor and material costs " +
                                   "may vary from those used in this application. The user of this application is 100% responsible for " +
                                   "verifying his/her own labor and material costs, as well as any applicable taxes, delivery charges, " +
                                   "and/or any other cost not delineated in this application. Use of this application is at your own " +
                                   "risk. Serenity Software Inc. assumes NO responsibility for your use of Ultimate Rehab Estimator " +
                                   "nor the results you get, nor your profit and/or loss resulting from the use of Ultimate Rehab " +
                                   "Estimator."),
                            m("p", "Serenity Software, Inc. does not warrant that the www.ultimaterehabestimator website is free of " +
                                   "viruses or other harmful components."),
                        ]),
                    ]),
                ]),
           ]),

    ]);
}

CreateAccount.clearAlerts = function(vnode) {
    var e = document.getElementById("create-account-alert-success");
    if (e) {
        e.textContent = "";
    }
    vnode.state.create_account_alert_success_display = 'none';

    e = document.getElementById("create-account-alert-danger");
    if (e) {
        e.textContent = "";
    }
    vnode.state.create_account_alert_danger_display = 'none';
}

CreateAccount.setDangerAlert = function(vnode, s) {
    var e = document.getElementById("create-account-alert-danger");
    e.textContent = s;
    vnode.state.create_account_alert_danger_display = 'block';
}

CreateAccount.submit = function(vnode) {
    if (vnode.state.submitted === true) {
        return;
    }
    vnode.state.submitted = true;
    CreateAccount.clearAlerts(vnode);

    const name = document.getElementById("create-account-name").value;
    if (!validateName(name)) {
        CreateAccount.setDangerAlert(vnode, VALID_NAME_RULE);
        vnode.state.submitted = false;
        return;
    }
    const email = document.getElementById("create-account-email").value;
    if (!validateEmail(email)) {
        CreateAccount.setDangerAlert(vnode, VALID_EMAIL_RULE);
        vnode.state.submitted = false;
        return;
    }
    const password = document.getElementById("create-account-password").value;
    if (!validatePassword(password)) {
        CreateAccount.setDangerAlert(vnode, VALID_PASSWORD_RULE);
        vnode.state.submitted = false;
        return;
    }
    const cpassword = document.getElementById("create-account-confirm-password").value;
    if (password !== cpassword) {
        CreateAccount.setDangerAlert(vnode, "Passwords do not match!");
        vnode.state.submitted = false;
        return;
    }
    if (!vnode.state.stripe_card_token) {
        CreateAccount.setDangerAlert(vnode, "You must set a credit card!");
        vnode.state.submitted = false;
        return;
    }

    const url = BACKEND_URL + "/user";
    const data = {
        name: name,
        email: email,
        password: password,
        stripe_card_token: vnode.state.stripe_card_token,
    };
    m.request({method: "POST", url: url, data: data}).then(function(ok) {
        var e = document.getElementById("create-account-alert-success");
        e.textContent = "Check your email for a verification message!";
        vnode.state.create_account_alert_success_display = 'block';

        e = document.getElementById("create-account-name");
        e.value = '';
        e = document.getElementById("create-account-email");
        e.value = '';
        e = document.getElementById("create-account-password");
        e.value = '';
        e = document.getElementById("create-account-confirm-password");
        e.value = '';

        vnode.state.submitted = false;
        vnode.state.stripe_card_token = null;
    }, function(error) {
        console.log("POST /user error:", error);
        handleAJAXError(error);
        CreateAccount.setDangerAlert(vnode,
            "Failed to create account. Try again later, or use a different email address!");
        vnode.state.submitted = false;
    });
};

CreateAccount.stripeAddCreditCard = function(event, vnode) {
    // HACK
    stripe_cb = function(token) {
        vnode.state.stripe_card_token = token.id;
        stripe_cb = null;
        m.redraw();
    }
    stripe_handler.open({
        name: 'Ultimate Rehab Estimator',
        description: 'Add Credit Card',
        locale: 'auto',
        zipCode: true,
        panelLabel: 'Submit',
        email: document.getElementById('create-account-email').value || '',
        allowRememberMe: false,
    });
    event.preventDefault();
}
