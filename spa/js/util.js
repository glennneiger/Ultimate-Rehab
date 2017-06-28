if (window.location.hostname === 'ultimaterehabestimator.com') {
    MODE = 'prod';
} else if (window.location.hostname === 'ultimaterehab.charstarstar.com') {
    MODE = 'char';
} else {
    MODE = 'dev';
}

if (MODE == 'prod') {
    BACKEND_URL = "https://backend.ultimaterehabestimator.com:444";
    STRIPE_PK = 'pk_test_UT7IoHQtlyIqWlaR2dn2SsC5';
} else if (MODE == 'char') {
    BACKEND_URL = "https://ultimaterehab-backend.charstarstar.com:444";
    STRIPE_PK = 'pk_test_J4piBQ0RCREw6RoYKmrorXZZ';
} else {
    BACKEND_URL = "http://127.0.0.1:5000";
    STRIPE_PK = 'pk_test_J4piBQ0RCREw6RoYKmrorXZZ';
}

UNVERIFIED_AUTH = 'unverified';
SUSPENDED_AUTH = 'suspended';
LIMITED_AUTH = 'limited';
FULL_AUTH = 'full';

SELECTED_DETAIL = 'Selected';

// http://stackoverflow.com/a/25490531
function getCookieValue(a) {
    var b = document.cookie.match('(^|;)\\s*' + a + '\\s*=\\s*([^;]+)');
    return b ? b.pop() : '';
}

function deleteCookie(name) {
  document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}

// http://jsfiddle.net/iamjohnlong/7qcd4tak/
var CheckAuth = function(comp, sufficient_auths) {
    return {
        oninit: function() {
            const auth = getCookieValue('auth');
            if (sufficient_auths.indexOf(auth) >= 0) {
                return;
            }

            if (auth === UNVERIFIED_AUTH || auth === SUSPENDED_AUTH) {
                m.route.set('/settings');
                return;
            } else if (auth === FULL_AUTH || auth === LIMITED_AUTH) {
                m.route.set('/home');
                return;
            } else {
                m.route.set('/welcome');
                return;
            }
        },
        view: function() {
            return m(comp);
        }
    };
}

function deleteCurrentUser() {
    const user_id = getCookieValue('user_id');
    initUserCache();

    deleteCookie('email');
    deleteCookie('user_id');
    deleteCookie('access_token');
    deleteCookie('auth');

    deleteCookie('remember_to_save');
}

function logoutCurrentUser() {
    deleteCurrentUser();
    m.route.set('/welcome');
}

function setCurrentUser(email, user_id, access_token, auth) {
    if (!email || !user_id || !access_token || !auth) {
        return false;
    }

    document.cookie = 'email=' + email + ';';
    document.cookie = 'user_id=' + user_id + ';';
    document.cookie = 'access_token=' + access_token + ';';
    document.cookie = 'auth=' + auth + ';';
    initUserCache();

    Data.fetchProperties();
    return true;
}

function getRoomsHref(property_id, room_id) {
    if (!room_id) {
        return "/property/" + property_id + "/rooms";
    } else {
        return "/property/" + property_id + "/rooms/" + room_id;
    }
}

function dealAnalyzerHref(property_id) {
    return "/property/" + property_id + "/dealAnalyzer";
}

function statementOfWorkHref(property_id) {
    return "/property/" + property_id + "/statementOfWork";
}

function billOfMaterialsHref(property_id) {
    return "/property/" + property_id + "/billOfMaterials";
}

function aboutUsHref() {
    return "/info/aboutUs";
}

function wholesalersHref() {
    return "/info/wholesalers";
}

function rehabbersHref() {
    return "/info/rehabbers";
}

function isEmpty(obj) {
    return Object.keys(obj).length === 0;
}

function screenSize() {
    const w = $(window).width();

    if (w > 1200) {
        return "lg";
    } else if (w > 992) {
        return "md";
    } else if (w > 768) {
        return "sm";
    } else {
        return "xs";
    }
}

function removeNonNumeric(s) {
    return s.replace(/[^\d.]/g, '')
}

function toNumber(s) {
    return Number(s.replace(/[^\d.]/g, '')) || 0;
}

function flatten(xs) {
    return [].concat.apply([], xs);
}

VALID_EMAIL_RULE = "Enter valid email address";
function validateEmail(s) {
    return s.length >= 3 && /\@/.test(s);
}

VALID_PASSWORD_RULE = "Password must have between 8 and 100 characters.";
function validatePassword(s) {
    return 8 <= s.length && s.length <= 100;
}

VALID_NAME_RULE = "Fix your name";
function validateName(s) {
    return s.length > 0;
}

function getTrimmedString(x) {
    if (typeof x === 'string') {
        return x.trim();
    } else {
        return '';
    }
}

function handleAJAXError(error) {
    if (typeof error !== 'object') {
        return;
    }

    if (error['error'] === 'authorization') {
        logoutCurrentUser();
    }
}

function prettyPropertyName(property_id, fallback_name) {
    const property = Data.properties[property_id];
    if (property && typeof(property.address) === 'string' && property.address.length > 0 &&
            typeof(property.zip_code) === 'string' && property.zip_code.length > 0) {
        return property.address + " (" + property.zip_code + ")";
    }

    if (typeof(fallback_name) === 'string') {
        return fallback_name;
    }

    return '<Property>';
}

function prettyRoomName(room_name, room_template_id) {
    if (typeof(room_name) === 'string' && room_name.length > 0) {
        return room_name;
    }

    const x = Data.room_templates[room_template_id];
    if (x && typeof(x.name) === 'string' && x.name.length > 0) {
        return x.name;
    }

    return "<Room>";
}

function addressTag(vm_property) {
    const address = vm_property.address;
    const city = vm_property.city;
    const state = vm_property.state;
    if (typeof(address) === 'string' && address.length > 0 &&
            typeof(city) === 'string' && city.length > 0 &&
            typeof(state) === 'string' && state.length > 0) {
        return m("div", {class: "row"}, [
                m("h4", {class: "room-measurements-hd text-center"}, [
                    address,
                    m("br"),
                    city + ", " + state,
                ]),
               ]);
    }

    return m("div");
}

// Object.assign() polyfill
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/assign#Polyfill
if (typeof Object.assign != 'function') {
  Object.assign = function(target, varArgs) { // .length of function is 2
    'use strict';
    if (target == null) { // TypeError if undefined or null
      throw new TypeError('Cannot convert undefined or null to object');
    }

    var to = Object(target);

    for (var index = 1; index < arguments.length; index++) {
      var nextSource = arguments[index];

      if (nextSource != null) { // Skip over if undefined or null
        for (var nextKey in nextSource) {
          // Avoid bugs when hasOwnProperty is shadowed
          if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)) {
            to[nextKey] = nextSource[nextKey];
          }
        }
      }
    }
    return to;
  };
}
