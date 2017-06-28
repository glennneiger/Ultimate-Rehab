var Verify = {};

Verify.oninit = function() {
    const verification_token = m.route.param("verification_token");
    const user_id = m.route.param("user_id");

    const url = BACKEND_URL + "/user/" + user_id + "/verify";
    const data = {
        "verification_token": verification_token
    };
    m.request({method: "PUT", url: url, data: data}).then(function(ok) {
        deleteCurrentUser();
        m.route.set('/welcome');
    }, function(error) {
        console.log("PUT /user/.../verify failed:", error);
        m.route.set('/welcome');
    });
}

Verify.view = function(vnode) { }
