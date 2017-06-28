// TODO
// + Cleanup this state machines
// + Handle failures in state machines

var Data = {};

const STATE_NEW = 'new';
const STATE_IN_PROGRESS = 'in progress';
const STATE_FINISHED = 'finished'

function initUserCache() {
    delete Data["properties"];
    delete Data["fetch_properties_status"];
    delete Data["fetch_properties_queue"];
    Data.properties = {};
    Data.fetch_properties_status = STATE_NEW;
    Data.fetch_properties_queue = [];

    delete Data["rooms"];
    delete Data["fetch_property_status"];
    delete Data["fetch_property_queue"];
    Data.rooms = {};
    Data.fetch_property_status = {};
    Data.fetch_property_queue = [];

    delete Data["room_templates"];
    delete Data["fetch_all_room_templates_status"];
    delete Data["fetch_all_room_templates_queue"];
    Data.room_templates = {};
    Data.fetch_all_room_templates_status = {};
    Data.fetch_all_room_templates_queue = [];

    delete Data["product_templates"];
    delete Data["fetch_all_product_templates_status"];
    delete Data["fetch_all_product_templates_queue"];
    Data.product_templates = {};
    Data.fetch_all_product_templates_status = {};
    Data.fetch_all_product_templates_queue = [];

    delete Data["user_data"];
    Data.user_data = {};
}
initUserCache();

// ###########################
//          Users
// ###########################
Data.fetchCurrentUserData = function(succ_cb) {
    const access_token = getCookieValue("access_token");
    if (!access_token) {
        return;
    }
    const user_id = getCookieValue("user_id");
    if (!access_token) {
        return;
    }

    const url = BACKEND_URL + "/user/" + user_id + "?access_token=" + access_token;
    return m.request({method: "GET", url: url}).then(function(user_data) {
        console.log("Data.fetchCurrentUserData:", user_data);
        Data.user_data = user_data;
        if (!!succ_cb) {
            succ_cb(user_data);
        }
    }, function(error) {
        console.log("Data.fetchCurrentUserData, error:", error);
        handleAJAXError(error);
    });
}

Data.removeCreditCard = function(succ_cb) {
    const access_token = getCookieValue("access_token");
    if (!access_token) {
        return;
    }
    const user_id = getCookieValue("user_id");
    if (!user_id) {
        return;
    }
    const url = BACKEND_URL + "/user/" + user_id + "/creditcard";
    const data = { access_token: access_token };
    m.request({method: "DELETE", url: url, data: data}).then(function(resp) {
        Data.properties[resp.id] = resp;
        if (!!succ_cb) {
            succ_cb(resp);
        }
    }, function(error) {
        console.log("Data.removeCreditCard, error:", error);
        handleAJAXError(error);
    });
}

// ###########################
//         Properties
// ###########################
Data.fetchProperties = function(succ_cb) {
    if (Data.fetch_properties_status === STATE_IN_PROGRESS) {
        if (!!succ_cb) {
            Data.fetch_properties_queue.push(succ_cb);
        }
        return;
    } else if (Data.fetch_properties_status === STATE_FINISHED) {
        if (!!succ_cb) {
            succ_cb();
        }
        return;
    }
    Data.fetch_properties_status = STATE_IN_PROGRESS;

    const access_token = getCookieValue("access_token");
    if (!access_token) {
        Data.fetch_properties_status = STATE_FINISHED;
        return;
    }
    const user_id = getCookieValue("user_id");
    if (!access_token) {
        Data.fetch_properties_status = STATE_FINISHED;
        return;
    }

    const url = BACKEND_URL + "/property?user_id=" + user_id + "&access_token=" + access_token;
    return m.request({method: "GET", url: url}).then(function(resp_properties) {
        Data.properties = resp_properties;
        Data.fetch_properties_status = STATE_FINISHED;
        Data.fetch_properties_queue.forEach(function(cb) {
            cb();
        });
        Data.fetch_properties_queue = [];
        if (!!succ_cb) {
            succ_cb();
        }
    }, function(error) {
        console.log("Data.fetchProperties, request error:", error);
        handleAJAXError(error);
        Data.fetch_properties_status = STATE_FINISHED;
    });
};

Data.fetchProperty = function(property_id, succ_cb) {
    const state = Data.fetch_property_status[property_id];
    if (state == STATE_IN_PROGRESS) {
        if (!!succ_cb) {
            Data.fetch_property_queue.push(succ_cb);
        }
        return;
    } else if (status == STATE_FINISHED) {
        if (!!succ_cb) {
            succ_cb();
        }
        return;
    }
    Data.fetch_property_status[property_id] = STATE_IN_PROGRESS;

    const access_token = getCookieValue("access_token");
    if (!access_token) {
        Data.fetch_property_status[property_id] = STATE_FINISHED;
        return;
    }
    const user_id = getCookieValue("user_id");
    if (!access_token) {
        Data.fetch_property_status[property_id] = STATE_FINISHED;
        return;
    }

    const url = BACKEND_URL + "/property/" + property_id + "?user_id=" + user_id + "&access_token=" + access_token;
    return m.request({method: "GET", url: url}).then(function(resp_prop) {
        console.log("Data.fetchProperty:", property_id, resp_prop);
        Object.getOwnPropertyNames(resp_prop).forEach(function(rid) {
            const r = resp_prop[rid];
            Data.rooms[rid] = r;
        });
        Data.fetch_property_status[property_id] = STATE_FINISHED;
        Data.fetch_property_queue.forEach(function(cb) {
            cb();
        });
        Data.fetch_property_queue = [];
        if (!!succ_cb) {
            succ_cb();
        }
    }, function(error) {
        console.log("Data.fetchProperty, request error:", error);
        handleAJAXError(error);
        Data.fetch_property_status[property_id] = STATE_FINISHED;
    });
}

Data.createProperty = function(fields, succ_cb) {
    const access_token = getCookieValue("access_token");
    if (!access_token) {
        return;
    }
    const user_id = getCookieValue("user_id");
    if (!user_id) {
        return;
    }
    const url = BACKEND_URL + "/property";
    const data = Object.assign({}, fields);
    data.access_token = access_token;
    data.user_id = Number(user_id);
    m.request({method: "POST", url: url, data: data}).then(function(resp) {
        Data.properties[resp.id] = resp;
        if (!!succ_cb) {
            succ_cb(resp);
        }
    }, function(error) {
        console.log("Data.createProperty, request error:", error);
        handleAJAXError(error);
    });
}

Data.deleteProperty = function(property_id, succ_cb) {
    const user_id = getCookieValue('user_id');
    const access_token = getCookieValue('access_token');
    const url = BACKEND_URL + "/property/" + property_id + "?user_id=" + user_id + "&access_token=" + access_token;
    m.request({method: "DELETE", url: url}).then(function(ok) {
        // Remove property from local cache
        delete Data.properties[property_id];
        if (!!succ_cb) {
            succ_cb();
        }
    }, function(error) {
        console.log("Data.deleteProperty, request error:", error);
        handleAJAXError(error);
    });
}

Data.updateProperties = function(properties) {
    const url = BACKEND_URL + "/property";
    const data = {
        properties: {},
        access_token: getCookieValue('access_token'),
        user_id: Number(getCookieValue('user_id')),
    };
    properties.forEach(function(p) {
        data.properties[p.id] = p;
    });

    // Optimistically update local cache. This avoids input field flicker in
    // the normal case.
    const old_properties = JSON.parse(JSON.stringify(Data.properties));
    properties.forEach(function(p) {
        // Be careful not to delete Data.properties[x].rooms
        Object.getOwnPropertyNames(p).forEach(function(field_name) {
            Data.properties[p.id][field_name] = p[field_name];
        });
    });

    m.request({method: "PUT", url: url, data: data}).then(function(resp) {
    }, function(error) {
        console.log("Data.updateProperties, request error:", error);
        handleAJAXError(error);
        Data.properties = old_properties;
    });
}

// ###########################
//           Rooms
// ###########################
Data.createRoom = function(property_id, room_template_id, room_name, succ_cb) {
    const access_token = getCookieValue("access_token");
    if (!access_token) {
        return;
    }
    const user_id = getCookieValue("user_id");
    if (!user_id) {
        return;
    }
    const url = BACKEND_URL + "/room";
    const data = {
        "access_token": access_token,
        "user_id" : Number(user_id),
        "property_id" : Number(property_id),
        "room_template_id" : room_template_id,
        "room_name" : room_name,
    };
    m.request({method: "POST", url: url, data: data}).then(function(resp) {
        // Emulate the server response when we fetch an 'existing' property
        // with rooms.
        Data.properties[property_id].rooms[resp.id] = {
            id: resp.id,
            template_id: room_template_id,
            name: resp.name,
        };

        Data.rooms[resp.id] = resp;
        if (!!succ_cb) {
            succ_cb(resp);
        }
    }, function(error) {
        console.log("Data.createRoom, request error:", error);
        handleAJAXError(error);
    });
}

Data.deleteRoom = function(room_id, succ_cb) {
    const user_id = getCookieValue('user_id');
    const access_token = getCookieValue('access_token');
    const url = BACKEND_URL + "/room/" + room_id + "?user_id=" + user_id + "&access_token=" + access_token;
    m.request({method: "DELETE", url: url}).then(function(ok) {
        // Remove room from local cache
        delete Data.rooms[room_id];
        if (!!succ_cb) {
            succ_cb();
        }
    }, function(error) {
        console.log("Data.deleteRoom, request error:", error);
        handleAJAXError(error);
    });
}

Data.updateRooms = function(property_id, rooms) {
    const url = BACKEND_URL + "/property/" + property_id + "/room";
    const data = {
        rooms: {},
        access_token: getCookieValue('access_token'),
        user_id: Number(getCookieValue('user_id')),
    };
    rooms.forEach(function(r) {
        data.rooms[r.id] = r;
    });

    // Optimistically update local cache. This avoids input field flicker in
    // the normal case.
    const old_rooms = JSON.parse(JSON.stringify(Data.rooms));
    rooms.forEach(function(r) {
        Object.getOwnPropertyNames(r).forEach(function(field_name) {
            Data.rooms[r.id][field_name] = r[field_name];
        });
    });

    m.request({method: "PUT", url: url, data: data}).then(function(resp) {
    }, function(error) {
        console.log("Data.updateRooms, request error:", error);
        handleAJAXError(error);
        Data.rooms = old_rooms;
    });
}

// ###########################
//          Templates
// ###########################
Data.fetchAllRoomTemplates = function(succ_cb) {
    if (Data.fetch_all_room_templates_status === STATE_IN_PROGRESS) {
        if (!!succ_cb) {
            Data.fetch_all_room_templates_queue.push(succ_cb);
        }
        return;
    } else if (Data.fetch_all_room_templates_status === STATE_FINISHED) {
        if (!!succ_cb) {
            succ_cb();
        }
        return;
    }
    Data.fetch_all_room_templates_status = STATE_IN_PROGRESS;

    const access_token = getCookieValue("access_token");
    if (!access_token) {
        Data.fetch_all_room_templates_status = STATE_FINISHED;
        return;
    }
    const user_id = getCookieValue("user_id");
    if (!access_token) {
        Data.fetch_all_room_templates_status = STATE_FINISHED;
        return;
    }

    const url = BACKEND_URL + "/roomTemplate?user_id=" + user_id + "&access_token=" + access_token;
    return m.request({method: "GET", url: url}).then(function(resp) {
        console.log("Data.fetchAllRoomTemplates: ", resp);
        Data.room_templates = resp;
        Data.fetch_all_room_templates_status = STATE_FINISHED;
        Data.fetch_all_room_templates_queue.forEach(function(cb) {
            cb();
        });
        Data.fetch_all_room_templates_queue = [];
        if (!!succ_cb) {
            succ_cb();
        }
    }, function(error) {
        console.log("Data.fetchAllRoomTemplates, request error:", error);
        handleAJAXError(error);
        Data.fetch_all_room_templates_status = STATE_FINISHED;
    });
}

Data.fetchAllProductTemplates = function(succ_cb) {
    if (Data.fetch_all_product_templates_status === STATE_IN_PROGRESS) {
        if (!!succ_cb) {
            Data.fetch_all_product_templates_queue.push(succ_cb);
        }
        return;
    } else if (Data.fetch_all_product_templates_status === STATE_FINISHED) {
        if (!!succ_cb) {
            succ_cb();
        }
        return;
    }
    Data.fetch_all_product_templates_status = STATE_IN_PROGRESS;

    const access_token = getCookieValue("access_token");
    if (!access_token) {
        Data.fetch_all_product_templates_status = STATE_FINISHED;
        return;
    }
    const user_id = getCookieValue("user_id");
    if (!access_token) {
        Data.fetch_all_product_templates_status = STATE_FINISHED;
        return;
    }

    const url = BACKEND_URL + "/productTemplate?user_id=" + user_id + "&access_token=" + access_token;
    return m.request({method: "GET", url: url}).then(function(resp) {
        console.log("Data.fetchAllProductTemplates: ", resp);
        Data.product_templates = resp;
        Data.fetch_all_product_templates_status = STATE_FINISHED;
        Data.fetch_all_product_templates_queue.forEach(function(cb) {
            cb();
        });
        Data.fetch_all_product_templates_queue = [];
        if (!!succ_cb) {
            succ_cb();
        }
    }, function(error) {
        console.log("Data.fetchAllProductTemplates, request error:", error);
        handleAJAXError(error);
        Data.fetch_all_product_templates_status = STATE_FINISHED;
    });
}
