(function(win, options) {

    var utlViewIDKey = "__utl_vp_id";
(function(p) {
    function uuid() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
            return v.toString(16);
        });
    }
    if (!window[p]) {
        window[p] = uuid();
    }
})(utlViewIDKey);
var utils = {

    proxy : function (context, args, functionName) {
        if (typeof args === 'function') {
            return function() {
                args.apply(context, arguments);
            }
        }
        else {
            return function() {
                var mergedArgs=args.concat(arguments);
                functionName.apply(context, mergedArgs);
            }
        }

    },

    /**
     * utils.wrap(window, 'onfocus', function() { ... } )
     */
    wrap : function(context, previous, wrapper) {
        var old = context[previous];
        if (old) {
            context[previous] = function() {
                old();
                wrapper();
            }
        }
        else {
            context[previous] = wrapper;
        }
    },


    /**
     * @param defaultOptions
     * @param extend1Options
     * @param extend2Options
     * @param ...
     * @returns extendedOptions
     */
    extend : function () {
        var result = {};
        for (var i = 0, len = arguments.length; i < len; i++) {
            var obj = arguments[i];
            if (obj!=undefined) {
                for (var attrname in obj) {
                    if (obj.hasOwnProperty(attrname)) {
                        result[attrname] = obj[attrname];
                    }
                }
            }
        }
        return result;
    },


    load_js : function (url, callback) {
        var el = document.createElement("script");
        el.type = "text/javascript";
        el.charset = 'utf-8';
        el.src = url;

        el.isLoaded = false;
        if (callback) {
            el.onload = el.onreadystatechange = function () {
                if ((el.readyState && el.readyState != "complete" && el.readyState != "loaded") || el.isLoaded) {
                    return;
                }
                el.isLoaded = true;
                callback();
            };
        }
        document.getElementsByTagName('head')[0].appendChild(el);
    },

    load_script : function (url, id, reload) {
        if (typeof (reload) == "undefined" ) {
            reload = false;
        }

        if (reload == false) {
            if (document.getElementById(id)) {
                return;
            }
        }

        var po = document.createElement('script');
        po.type = 'text/javascript';
        po.async = true;
        po.src = url;
        if (typeof (id) != 'undefined') {
            po.id = id;
        }
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    },


    registerGlobalWindowFocusListener : function()  {
        if (window["__utl_global_window_focus_registered"]) {
            return;
        }


        //http://stackoverflow.com/questions/1060008/is-there-a-way-to-detect-if-a-browser-window-is-not-currently-active
        (function() {
            var hidden = "hidden";

            // Standards:
            if (hidden in document)
                document.addEventListener("visibilitychange", onchange);
            else if ((hidden = "mozHidden") in document)
                document.addEventListener("mozvisibilitychange", onchange);
            else if ((hidden = "webkitHidden") in document)
                document.addEventListener("webkitvisibilitychange", onchange);
            else if ((hidden = "msHidden") in document)
                document.addEventListener("msvisibilitychange", onchange);
            // IE 9 and lower:
            else if ('onfocusin' in document) {
                utils.wrap(document, "onfocusin", onchange);
                utils.wrap(document, "onfocusout", onchange);
            }
            // All others:
            else {
                utils.wrap(document, "onpageshow", onchange);
                utils.wrap(document, "onpagehide", onchange);
                utils.wrap(document, "onfocus", onchange);
                utils.wrap(document, "onblur", onchange);
            }

            window.addEventListener("focus", function() {
                utils.fireEvent("window-blur", {
                    state: "visible"
                });
            });
            window.addEventListener("blur", function() {
                utils.fireEvent("window-blur", {
                    state: "hidden"
                });
            });


            function onchange (evt) {
                var v = 'visible', h = 'hidden',
                    evtMap = {
                        focus:v, focusin:v, pageshow:v, blur:h, focusout:h, pagehide:h
                    };

                evt = evt || window.event;
                var state;
                if (evt.type in evtMap) {
                    state = evtMap[evt.type];
                }
                else {
                    state = this[hidden] ? "hidden" : "visible";
                }
                utils.fireEvent("window-blur", {
                    state: state
                });
            }
        })();


        window["__utl_global_window_focus_registered"] = true;
    },

    registerGlobalClickListener : function()  {
        if (window["__utl_global_click_registered"]) {
            return;
        }
        var closeListener = function(e) {
            e = e || window.event; // IE
            utils.fireEvent("window-click", e);
        };
        if (typeof window.attachEvent != 'undefined') {
            document.attachEvent('onclick', closeListener);
        }
        else {
            document.addEventListener('mouseup', closeListener);
            document.addEventListener("touchend", closeListener);
        }
        window["__utl_global_click_registered"] = true;
    },

    registerGlobalKeyListener : function()  {
        if (window["__utl_global_key_registered"]) {
            return;
        }
        var listener = function(e) {
            e = e || window.event; // IE
            utils.fireEvent("window-keyup", e);
        };
        if (typeof window.attachEvent != 'undefined') {
            document.attachEvent('onkeyup', listener);
        }
        else {
            document.addEventListener('keyup', listener);
        }
        window["__utl_global_key_registered"] = true;
    },


    addListener: function(name, callback) {
        var globalName = "__utl_listeners_"+name;
        window[globalName] = window[globalName] || [];
        window[globalName].push(callback);
    },

    removeListener: function(name, callback) {
        var globalName = "__utl_listeners_"+name;
        window[globalName] = window[globalName] || [];
        var idx = window[globalName].indexOf(callback);
        if (idx > -1) {
            window[globalName].splice(idx, 1);
        }
    },

    fireEvent: function(name, event) {
        var globalName = "__utl_listeners_"+name;
        if (!window[globalName]) {
            return;
        }
        for (var idx = 0; idx < window[globalName].length; idx++) {
            var listener = window[globalName][idx];
            listener(event);
        }
    },
    styles : [],
    addStyle : function (str, id) {

        var elementId = "__utlk_wdgt_stl_"+id;

        if (this.styles.indexOf(id) == -1 && !document.getElementById(elementId)) {
            this.styles.push(id);
            var el = document.createElement('style');
            el.type = "text/css";
            el.id = elementId;

            document.getElementsByTagName('head')[0].appendChild(el);

            if (el.styleSheet) {
                el.styleSheet.cssText= str;
                el.type = "text/css";
            } else {
                var i = document.createTextNode(str);
                el.appendChild(i);
            }
        }
    },

    sendRequest : function(url, options) {
        options = options || {};
        var zeroPixelAddClass = options["zeroPixelAddClass"];


        var element = document.createElement("img");
        element.src = url;
        element.style.display = 'block';
        element.style.position = 'absolute';
        element.style.top = '0';
        element.style.left = '-100px';
        element.style.width = '1px';
        element.style.height = '1px';
        element.style.border = 'none';
        if (zeroPixelAddClass) {
            element.className = zeroPixelAddClass;
        }

        document.getElementsByTagName('body')[0].appendChild(element);

    },

    sendImpression: function(options) {
        var host = options["host"] || "w.uptolike.com";
        var path = options["path"];
        var params = options["params"];

        params["url"] = params["url"] || window.location.href;
        params["ref"] = params["ref"] || document.referrer;
        params["rnd"] = params["rnd"] || Math.random();

        if (!params["ref"]) {
            delete params["ref"];
        }


        var url = "//" + host + path;
        var first = true;
        if (params) {
            url += "?";
            for (var param in params) {
                if (params.hasOwnProperty(param)) {
                    if (!first) {
                        url += "&";
                    }
                    url+= param + "=" + encodeURIComponent(params[param]);
                    first = false;
                }
            }
        }

        utils.sendRequest(url, options);


    }



};


function trim(str){return str? str.replace(/^\s+|\s+$/g, '') : str;}
function ltrim(str){return str? str.replace(/^\s+/,'') : str;}
function rtrim(str){return str? str.replace(/\s+$/,'') : str;}
function fulltrim(str){return str? str.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ') : str;}


function hasParent(element, parent) {
    if (!element) {
        return false;
    }
    if (!parent) {
        return false;
    }

    var cur = element;
    while (cur!=null) {
        if (cur==parent) {
            return true;
        }
        cur = cur.parentNode;
    }
    return false;
}


function getOffset(elem) {

    function getOffsetSum(elem) {
        var top=0, left=0;
        while(elem) {
            top = top + parseInt(elem.offsetTop);
            left = left + parseInt(elem.offsetLeft);
            elem = elem.offsetParent;
        }

        return {top: top, left: left};
    }

    function getOffsetRect(elem) {
        var box = elem.getBoundingClientRect();
        var body = document.body;
        var docElem = document.documentElement;
        var scrollTop = window.pageYOffset || docElem.scrollTop || body.scrollTop;
        var scrollLeft = window.pageXOffset || docElem.scrollLeft || body.scrollLeft;
        var clientTop = docElem.clientTop || body.clientTop || 0;
        var clientLeft = docElem.clientLeft || body.clientLeft || 0;
        var top  = box.top +  scrollTop - clientTop;
        var left = box.left + scrollLeft - clientLeft;
        return { top: Math.round(top), left: Math.round(left) }
    }


    if (elem.getBoundingClientRect) {
        return getOffsetRect(elem);
    } else {
        return getOffsetSum(elem);
    }
}



var JSON;JSON||(JSON={});
var utils = utils || {};
utils.JSON = utils.JSON || {};
var f = function(JSON){function k(a){return a<10?"0"+a:a}function o(a){p.lastIndex=0;return p.test(a)?'"'+a.replace(p,function(a){var c=r[a];return typeof c==="string"?c:"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4)})+'"':'"'+a+'"'}function l(a,j){var c,d,h,m,g=e,f,b=j[a];b&&!(b instanceof Array)&&typeof b==="object"&&typeof b.toJSON==="function"&&(b=b.toJSON(a));typeof i==="function"&&(b=i.call(j,a,b));switch(typeof b){case "string":return o(b);case "number":return isFinite(b)?String(b):"null";case "boolean":case "null":return String(b);case "object":if(!b)return"null";
    e+=n;f=[];if(Object.prototype.toString.apply(b)==="[object Array]"){m=b.length;for(c=0;c<m;c+=1)f[c]=l(c,b)||"null";h=f.length===0?"[]":e?"[\n"+e+f.join(",\n"+e)+"\n"+g+"]":"["+f.join(",")+"]";e=g;return h}if(i&&typeof i==="object"){m=i.length;for(c=0;c<m;c+=1)typeof i[c]==="string"&&(d=i[c],(h=l(d,b))&&f.push(o(d)+(e?": ":":")+h))}else for(d in b)Object.prototype.hasOwnProperty.call(b,d)&&(h=l(d,b))&&f.push(o(d)+(e?": ":":")+h);h=f.length===0?"{}":e?"{\n"+e+f.join(",\n"+e)+"\n"+g+"}":"{"+f.join(",")+
        "}";e=g;return h}}if(typeof Date.prototype.toJSON!=="function")Date.prototype.toJSON=function(){return isFinite(this.valueOf())?this.getUTCFullYear()+"-"+k(this.getUTCMonth()+1)+"-"+k(this.getUTCDate())+"T"+k(this.getUTCHours())+":"+k(this.getUTCMinutes())+":"+k(this.getUTCSeconds())+"Z":null},String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(){return this.valueOf()};var q=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
    p=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,e,n,r={"\u0008":"\\b","\t":"\\t","\n":"\\n","\u000c":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},i;if(typeof JSON.stringify!=="function")JSON.stringify=function(a,j,c){var d;n=e="";if(typeof c==="number")for(d=0;d<c;d+=1)n+=" ";else typeof c==="string"&&(n=c);if((i=j)&&typeof j!=="function"&&(typeof j!=="object"||typeof j.length!=="number"))throw Error("JSON.stringify");return l("",
    {"":a})};if(typeof JSON.parse!=="function")JSON.parse=function(a,e){function c(a,d){var g,f,b=a[d];if(b&&typeof b==="object")for(g in b)Object.prototype.hasOwnProperty.call(b,g)&&(f=c(b,g),f!==void 0?b[g]=f:delete b[g]);return e.call(a,d,b)}var d,a=String(a);q.lastIndex=0;q.test(a)&&(a=a.replace(q,function(a){return"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4)}));if(/^[\],:{}\s]*$/.test(a.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,
    "]").replace(/(?:^|:|,)(?:\s*\[)+/g,"")))return d=eval("("+a+")"),typeof e==="function"?c({"":d},""):d;throw new SyntaxError("JSON.parse");}};

f(utils.JSON); f(JSON);
String.prototype.replaceAll = function(search, replace){
    return this.split(search).join(replace);
}

    var scope = "zp";
function isArray(b) {
    return "[object Array]" == Object.prototype.toString.call(b)
}


function appendRight(array, addedArray) {
    for (var i = 1; i < arguments.length; i++) {
        array.push(arguments[i]);
    }
    return array.length;
}

function trim(text, length) {
    text = String(text).replace(/^\s+|\s+$/g, "");
    length && text.length > length && (text = text.substr(0, length));
    return text;
}


function isEmptyObject(obj) {
    for(var prop in obj) {
        if (obj.hasOwnProperty(prop)) {
            return false;
        }
    }
    return true;
}

function param(parameters) {
    var tokens = [],
        param;
    for (param in parameters) {
        if (parameters.hasOwnProperty(param)) {
            (tokens[tokens.length] = param + "=" + encodeURIComponent(parameters[param]).replace(/\+/g, "%2B"));
        }
    }
    return tokens.join("&");
}

function forEachKey(object, callback, context) {
    for (var prop in object) if (object.hasOwnProperty(prop)) {
        callback.call(context, prop, object[prop], object)
    }
}

function  inArray(array, object) {
    for (var c = 0; c < array.length; c++) {
        if (array[c] == object) return true;
    }
    return false
}




var Utils = {
    mixin: function (mix) {
        for (var c = 1; c < arguments.length; c++)
            if (arguments[c]) {
                for (var e in arguments[c]) {
                    if (arguments[c].hasOwnProperty(e)) {
                        mix[e] = arguments[c][e];
                    }
                }
                if (arguments[c].hasOwnProperty("toString")) {
                    mix.toString = arguments[c].toString;
                }
            }
        return mix
    }
};
var Obj = function (b) {
    b = b || {};
    Utils.mixin(this, b);
    this._initComponent()
};
Obj.prototype._initComponent = function () {};
Obj.inherit = function (parent) {
    parent = parent || {};
    var c = "function" == typeof this ? this : Object;
    parent.hasOwnProperty("constructor") || (parent.constructor = function () {
        c.apply(this, arguments)
    });
    var e = function () {};
    e.prototype = c.prototype;
    parent.constructor.prototype = new e;
    Utils.mixin(parent.constructor.prototype, parent);
    parent.constructor.prototype.constructor = parent.constructor;
    parent.constructor.superclass = c.prototype;
    parent.constructor.inherit = Obj.inherit;
    return parent.constructor
};


var Storage = Obj.inherit({
    counterId: "",
    _initComponent: function () {
        Storage.superclass._initComponent.apply(this, arguments);
        this._buffer = {};
        this._ls = null;
        try {
            this._ls = window.localStorage
        } catch (b) {}
    },
    set: function (key, value) {
        if (this.isEnabled()) {
            try {
                if (!value || value && isArray(value) && !value.length) {
                    this.remove(key);
                }
                else {
                    this._ls.setItem(this._getLsKey(key), JSON.stringify(value));
                }
            } catch (e) {}
        }

    },
    get: function (key) {
        if (this.isEnabled()) {
            try {
                return JSON.parse(this._ls.getItem(this._getLsKey(key)))
            } catch (c) {}
        }
        return null
    },
    remove: function (key) {
        if (this.isEnabled()) {
            try {
                this._ls.removeItem(this._getLsKey(key))
            } catch (c) {}
        }
    },
    isEnabled: function () {
        return this._ls && window.JSON && "object" == typeof this._ls && "object" == typeof window.JSON
    },
    _getLsKey: function (key) {
        return "__utl_zp" + this.counterId + "_" + key
    }
});


var BaseSender = Obj.inherit({

    senderTypes: ["htmlfile", "xhr", "img"],
    postParams: [],
    _initComponent: function () {

        this._htmlfile = this._createHtmlfile();
        this._senders = {
            htmlfile: this._sendByHtmlfile,
            xhr: this._sendByXhr,
            img: this._sendByImg
        }
    },
    send: function (zpHandlerUrl, requestParams, callback, context) {
        callback = callback || function () {};
        var requestParams = this._createRequestParams(zpHandlerUrl, requestParams);
        for (var i = 0; i < this.senderTypes.length && !this._senders[this.senderTypes[i]].call(this, requestParams, callback, context); i++);
    },

    _sendByHtmlfile: function (requestParams, context, callback) {
        if (this._htmlfile) {
            this._submitForm(this._htmlfile, requestParams, "application/x-www-form-urlencoded", context, callback);
            return true;
        }
        else {
            return false;
        }
    },

    _sendByXhr: function (requestParams, context, callback) {
        if ("XMLHttpRequest" in window) {
            var xhr = new XMLHttpRequest;
        /**/
            xhr.open(requestParams.method, requestParams.url, !0);
        /**/
            if ("POST" == requestParams.method) {
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            }
            setTimeout(function() {xhr.send(requestParams.postBody);}, 50);

            var invokeCallBackFN = function () {
                if (4 == xhr.readyState) {
                    context.call(callback);
                }
                else {
                    setTimeout(invokeCallBackFN, 50);
                }
            };
            setTimeout(invokeCallBackFN, 50);
            return true;
        /**/
        }
        return false
    },
    _sendByImg: function (requestParams, callback, context) {
        var img = new Image;
        img.onload = function () {
            callback.call(context);
        };
        img.src = requestParams.onlyGetUrl;
        return true
    },

    _submitForm: function (document, requestParams, encType, callback, context) {
        var iframeName = "ifr" + Math.round(1E10 * Math.random()),
            formWrapper = document.createElement("div");
        formWrapper.style.position = "absolute";
        formWrapper.style.left = "-99999px";
        formWrapper.style.top = "-99999px";
        var formContent = ['<iframe name="', iframeName, '"></iframe>', '<form action="', requestParams.url, '" method="' + requestParams.method + '" target="',
            iframeName, '" enctype="', encType, '">'
        ];

        for (var param in requestParams.postParams) {
            if (requestParams.hasOwnProperty(param)) {
                appendRight(formContent, '<textarea name="', param, '"></textarea>')
            }
        }
        appendRight(formContent, "</form>");

        formWrapper.innerHTML = formContent.join("");
        document.body.appendChild(formWrapper);

        var form = formWrapper.getElementsByTagName("form")[0];
        var iframe = formWrapper.getElementsByTagName("iframe")[0];

        for (param in requestParams.postParams) {
            if (requestParams.postParams.hasOwnProperty(param)) {
                form[param].value = requestParams.postParams[param];
            }
        }
        iframe.onload = function () {
            iframe.onload = null;
            callback.call(context)
        };
        form.submit();
        setTimeout(function () {
            document.body.removeChild(formWrapper)
        }, 1E4);
    },


    _createRequestParams: function (href, parameters) {
        var sendViaGet = {}, sendViaPost = {};
        forEachKey(parameters, function (key, value) {
            if (inArray(this.postParams, key)){
                sendViaPost[key] = value
            } else {
                sendViaGet[key] = value
            }
        }, this);
        href += -1 < href.indexOf("?") ? "&" : "?";

        var hasPostData = !isEmptyObject(sendViaPost);

        return {
            method: hasPostData ? "POST" : "GET",
            url: href + param(sendViaGet),
            postBody: hasPostData ? param(sendViaPost) : null,
            postParams: sendViaPost,
            onlyGetUrl: href + param(parameters)
        }
    },
    _createHtmlfile: function () {
        try {
            if (window.ActiveXObject) {
                var a = new ActiveXObject("htmlfile");
                a.open();
                a.write("<html><body></body></html>");
                a.close();
                return a
            }
        } catch (b) {}
        return null
    }
});

var Sender = BaseSender.inherit({
    protocol: "http:",
    host: "w.uptolike.com",
    resource: "/",
    counterType: 0,
    retry: false,
    _initComponent: function () {
        Sender.superclass._initComponent.apply(this, arguments);
        if (this.retry) {
            this._storage = new Storage();
        }
    },
    send: function (requestParams, browserInfo, callback, context) {

        if (this.retry && this._storage.isEnabled()) {
            browserInfo.rqnl = browserInfo.rqnl || 0;
            browserInfo.rqnl++;

            requestParams["n"] = browserInfo.rqnl;

            for (var req = this._storage.get("retryReqs") || {}, h = 0; req[h];) h++;
            req[h] = {
                protocol: this.protocol,
                host: this.host,
                resource: this.resource,
                params: requestParams,
                browserInfo: browserInfo,
                time: +new Date
            };
            this._storage.set("retryReqs", req);
        }
        var handlerUrl = [this.protocol, "//", this.host, this.resource ].join("");
        var browserInfoJoined = [];

        if (browserInfo)
            for (var prop in browserInfo) {
                if (browserInfo.hasOwnProperty(prop) && browserInfo[prop]) {
                    browserInfoJoined.push(prop, browserInfo[prop]);
                }
            }

        if (browserInfoJoined.length>0) {
            requestParams["browser-info"] = browserInfoJoined.join(":")
        }

        if (this.counterType) {
            requestParams["cnt-class"] = this.counterType
        }
        if (scope) {
            requestParams["scope"] = scope;
        }

        return Sender.superclass.send.call(this, handlerUrl, requestParams, function () {
            if (this.retry && this._storage.isEnabled()) {
                var a = this._storage.get("retryReqs") || {};
                delete a[h];
                this._storage.set("retryReqs", a)
            }
            if (callback) {
                callback.apply(context, arguments)
            }
        }, this);
    }

});
Sender.retransmit = function () {
    var storage = new Storage();
    var retryReqs = storage.get("retryReqs") || {};
    storage.remove("retryReqs");
    forEachKey(retryReqs, function (prop, value) {
        if (value.time && value.time + 6E5 > +new Date) {
            new Sender({
                protocol: value.protocol,
                host: value.host,
                resource: value.resource,
                retry: true
            }).send(value.params, value.browserInfo);
        }
    });
};

if (window["__utl_retransmitted"]===undefined) {
    window["__utl_retransmitted"]=true;
    Sender.retransmit();
}







    function ready(callback) {
        var done = false, top = true,

            doc = win.document, root = doc.documentElement,

            add = doc.addEventListener ? 'addEventListener' : 'attachEvent',
            rem = doc.addEventListener ? 'removeEventListener' : 'detachEvent',
            pre = doc.addEventListener ? '' : 'on',

            init = function(e) {
                if (e.type == 'readystatechange' && doc.readyState != 'complete') return;
                (e.type == 'load' ? win : doc)[rem](pre + e.type, init, false);
                if (!done && (done = true)) callback.call(win, e.type || e);
            },

            poll = function() {
                try { root.doScroll('left'); } catch(e) { setTimeout(poll, 50); return; }
                init('poll');
            };

        if (doc.readyState == 'complete') callback.call(win, 'lazy');
        else {
            if (doc.createEventObject && root.doScroll) {
                try { top = !win.frameElement; } catch(e) { }
                if (top) poll();
            }
            doc[add](pre + 'DOMContentLoaded', init, false);
            doc[add](pre + 'readystatechange', init, false);
            win[add](pre + 'load', init, false);
        }

    }


    function viewport() {
        var e = window, a = 'inner';
        if ( !( 'innerWidth' in window ) ) {
            a = 'client';
            e = document.documentElement || document.body;
        }
        return { width : e[ a+'Width' ] , height : e[ a+'Height' ] }
    }





    //   INITIALIZATION


    var viewId = window[utlViewIDKey];
    var projectId = options.pid;



    if (options["extMet"]===false) {
if (!window["__utl__ext__counters"]) {

    window["__utl__ext__counters"] = true;

    (function (d, w, c) {
        (w[c] = w[c] || []).push(function() {
            try {
                w.yaCounter23414332 = new Ya.Metrika({id:23414332,
                    clickmap:true,
                    trackLinks:true,
                    accurateTrackBounce:true});
            } catch(e) { }
        });

        var n = d.getElementsByTagName("script")[0],
            s = d.createElement("script"),
            f = function () { n.parentNode.insertBefore(s, n); };
        s.type = "text/javascript";
        s.async = true;
        s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js";

        if (w.opera == "[object Opera]") {
            d.addEventListener("DOMContentLoaded", f, false);
        } else { f(); }
    })(document, window, "yandex_metrika_callbacks");
}

(function() {
    return;
    if (window["__utl_advombat"]) {
        return;
    }

    window["__utl_advombat"] = true;
    var src = encodeURIComponent(window.document.URL),
        ref = encodeURIComponent(window.document.referrer),
        protocol = window.location.protocol,
        url = (protocol != 'http:' && protocol != 'https:' ? 'http:' : protocol) +
            '//advombat.ru/0.js?pid=UPTOLIKE&src=' + src + '&ref=' + ref + '&_t=' + new Date().getTime();
    (function(url){
        var iframe = document.createElement('iframe');
        (iframe.frameElement || iframe).style.cssText = "width: 0; height: 0; border: 0; position: absolute; left: -100px; top: 0;";
        var where = document.getElementsByTagName('script');
        where = where[where.length - 1];
        where.parentNode.insertBefore(iframe, where);
        var doc = iframe.contentWindow.document;
        doc.open().write('<body onload="' +
            'var js = document.createElement(\'script\');'+
            'js.src = \'' + url +'\';' +
            'document.body.appendChild(js);">');
        doc.close();
    })(url);

})();

    }


    ready(function() {

        var sw = screen.width, sh = screen.height;
        var vp = viewport();
        var vw = vp.width, vh = vp.height;

        var hasFlash = false;
        try {
            var fo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
            if(fo) hasFlash = true;
        }catch(e){
            if(navigator.mimeTypes ["application/x-shockwave-flash"] != undefined) hasFlash = true;
        }

        utils.sendImpression({
            host: options.host,
            path: options.imp,
            params: {
                pid: options["pid"],
                fl: hasFlash,
                sw: sw,
                sh: sh,
                vw: vw,
                vh: vh,
                vp: viewId
            }
        });

        var rotatorHost = options.host;
        var projectId = options.pid;
/*
*/

var rotatorHost = rotatorHost || "w.uptolike.com";
var projectId = projectId || 0;

var uptolike = uptolike || {};
uptolike.cnf = {
    version : '1413205950'
};

(function(){

    var installMarker = "utl_adContextParserLoaded";
    if (window[installMarker]) {
        return;
    }
    window[installMarker] = true;


    if ( (typeof utils == 'undefined')  || !utils.load_js) {
        return;
    }

    utils.load_js("//"+rotatorHost+"/widgets/v1/cprs.js?v="+uptolike.cnf.version);

})();(function(window) {

    if (window["___utl_watcher_registered"]) {
        return;
    }
    window["___utl_watcher_registered"] = true;

    var triggerInterval = 1000;
    var maxTriggerInterval = 5 * 60 * 1000;
    var maxSessionInactivity = 30 * 60 * 1000;
    var keepCachedPeriod = 10 * 60 * 1000;
    var viewId = window[utlViewIDKey];

    var initialTime = new Date().getTime();


    function isPageHidden(){
        return document.hidden || document.msHidden || document.webkitHidden;
    }



    var blurListener = function(e) {
        var state = e.state;
        if (state === 'hidden') {
            timer.stop();
        }
        else {
            timer.start();
        }
    };


    var timer = {

        period: 1000,
        spend: 0,
        intervalId : undefined,

        increment: function() {
            if (!isPageHidden()) {
                timer.spend++;
            }
        },


        install: function() {
            utils.registerGlobalWindowFocusListener();
            utils.addListener("window-blur", blurListener);
            timer.start();
        },

        start: function() {
            if (!timer.intervalId) {
                timer.intervalId = setInterval(function() {
                    timer.increment();
                }, timer.period);
            }
        },

        stop: function() {
            if (timer.intervalId) {
                clearInterval(timer.intervalId);
                timer.intervalId = undefined;
            }
        }

    };


    function destroy() {
        utils.removeListener("window-blur", blurListener);
        timer.stop();
    }


    var prevSpend = 0;
    var lastSentTime = initialTime;
    var trigger = function() {

        var now = new Date().getTime();
        var fromInitial = now - initialTime;


        if (fromInitial <= keepCachedPeriod || prevSpend<timer.spend) {
            utils.sendRequest("//" + rotatorHost + "/widgets/v1/watch?vp="+viewId+"&n="+timer.spend+"&rnd="+Math.random()+"&url="+encodeURIComponent(window.location.href));
            prevSpend = timer.spend;
            lastSentTime = now;
        }

        triggerInterval = triggerInterval * 2;
        if (triggerInterval > maxTriggerInterval) {
            triggerInterval = maxTriggerInterval;
        }

        if ((now - lastSentTime) < maxSessionInactivity) {
            setTimeout(trigger, triggerInterval);
        }
        else {
            destroy();
        }
    };

    timer.install();
    setTimeout(trigger, triggerInterval);


})(window);(function() {

    var installMarker = "utl_ext_req_"+rotatorHost;
    if (window[installMarker]) {
        return;
    }
    window[installMarker] = true;

    var el = document.createElement("script");
    el.type = "text/javascript";
    el.charset = 'utf-8';
    el.async = 'true';
    el.src = "//" + rotatorHost + "/widgets/v1/extra.js?rnd="+Math.random();

    el.isLoaded = false;
    document.getElementsByTagName('head')[0].appendChild(el);

})();(function() {

    var EventSender = Sender.inherit({
        retry: true,
        postParams: ["site-info"],
        senderTypes: ["htmlfile", "xhr", "img"],

        sendClickLink: function (url, text, options) {
            console.log("Caught ext click");
            this._hitExt(url, text, window.document.location.href, null, options)
        },

        _hitExt: function (url, text, localHref, d, options, browserInfo, callback, context) {
            options = options || {};
            browserInfo = browserInfo || {};

            var requestParams = {};
            if (options.ar && !options.onlyData) {
                localHref = this._prepareHitUrl(localHref);
                url = this._prepareHitUrl(url)
            }
            options.reqNum = !0;
            var trimmed = trim(localHref, 2048);
            if (trimmed){
                requestParams["ref"] = trimmed
            }

            requestParams.pid = projectId;
            requestParams.vp = viewId;
            requestParams.url = trim(url, 2048);
            requestParams.rnd = Math.random();

                    this.send(requestParams, browserInfo, callback, context);
        },
        _prepareHitUrl: function (url) {
            var host = window.document.location.host,
                localHref = window.document.location.href;
            if (!url) return localHref;
            if (-1 != url.search(/^\w+:\/\//)) {
                return url;
            }
            var firstChar = url.charAt(0),
                idx;
            if ("?" == firstChar) {
                idx = localHref.search(/\?/);
                if (idx == -1) {
                    return localHref + url;
                }
                else {
                    return localHref.substr(0, idx) + url;
                }
            }
            if ("#" == firstChar) {
                idx = localHref.search(/#/);
                if (idx == -1) {
                    return localHref + url;
                }
                else {
                    return localHref.substr(0, idx) + url;
                }
            }
            if ("/" == firstChar) {
                idx = localHref.search(host);
                if (idx != -1) {
                    return localHref.substr(0, idx + host.length) + url
                }
            } else {
                host = localHref.split("/");
                host[host.length - 1] = url
                return host.join("/");
            }
            return url
        }

    });



    var eventSender = new EventSender({
        protocol: window.document.location.protocol,
        host:rotatorHost,
        counterType: "zp",
        resource: "/widgets/v1/zp/clk"
    });


    function getHostname(url) {
        var a = window.document.createElement('a');
        a.href = url;
        return a.hostname;
    }


    function attachEvent(doc, event, handler, phase) {
        doc.addEventListener ? doc.addEventListener(event, handler, !! phase) : doc.attachEvent &&
            doc.attachEvent("on" + event, handler)
    }

    function sendClick(event) {
        var target = event.target||event.srcElement;
        if (target) {
            var tagName = target.nodeName;
            var href = "" + target.href;
            var url= href ? href.split(/\?/)[0] : "";
            var text = target.innerHTML ? target.innerHTML.toString().replace(/<\/?[^>]+>/gi, "") : "";
            var hostname = getHostname(href);
            if (tagName==='A' && localDomain!==hostname && href.search(/^https?:/i)>=0) {
                iframe.contentWindow.postMessage({action: "store_link", event: {href: href, text: text, params: {pid: projectId, viewId: viewId, ref: localHref}}}, "*");
                eventSender.sendClickLink(href, text, {});
            }
        }

    }


    function ready(callback) {
        var done = false, top = true,

            doc = window.document, root = doc.documentElement,

            add = doc.addEventListener ? 'addEventListener' : 'attachEvent',
            rem = doc.addEventListener ? 'removeEventListener' : 'detachEvent',
            pre = doc.addEventListener ? '' : 'on',

            init = function(e) {
                if (e.type == 'readystatechange' && doc.readyState != 'complete') return;
                (e.type == 'load' ? window : doc)[rem](pre + e.type, init, false);
                if (!done && (done = true)) callback.call(window, e.type || e);
            },

            poll = function() {
                try { root.doScroll('left'); } catch(e) { setTimeout(poll, 50); return; }
                init('poll');
            };

        if (doc.readyState == 'complete') callback.call(window, 'lazy');
        else {
            if (doc.createEventObject && root.doScroll) {
                try { top = !window.frameElement; } catch(e) { }
                if (top) poll();
            }
            doc[add](pre + 'DOMContentLoaded', init, false);
            doc[add](pre + 'readystatechange', init, false);
            window[add](pre + 'load', init, false);
        }

    }




    var localDomain = window.document.location.hostname;
    var localHref = window.document.location.href;

    var viewId = window[utlViewIDKey];


    if (window["__utl_zp_clk_inst"]) {
        return;
    }
    window["__utl_zp_clk_inst"] = true;

    var iframe;

    function install() {

        iframe = window.document.createElement("iframe");
        iframe.src = "//"+rotatorHost+"/widgets/v1/zp/support?1";
        iframe.style.width = "1px";
        iframe.style.height = "1px";
        iframe.style.left = "-100px";
        iframe.style.top = "-100px";
        iframe.style.position = "absolute";
        iframe.style.margin = "0";
        iframe.style.border = "0";

        window.document.body.appendChild(iframe);

        attachEvent(window.document, "click", function(event) {
            sendClick(event);
        });

    }


    function checker() {
        if (window.document.body) {
            install();
        }
        else {
            setTimeout(checker, 1000);
        }
    }

    setTimeout(checker, 1000);



})()
    });


})(window, {
    "host": "w.uptolike.com",
    "imp":"/widgets/v1/zp/imp",
    "support":"/widgets/v1/zp/support",
    "clk":"/widgets/v1/zp/clk",
    "pid":"51860",
    "extMet": false
});