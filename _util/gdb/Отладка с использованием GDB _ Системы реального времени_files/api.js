// api is always called from a loader.js which provides window.mailru object, die if not called that way
if (window.mailru === undefined) {
    throw new Error('use loader.js to init the api');
}

// only define api if it's not defined and initialised yet
if (window.mailru.inited === undefined) {

    (function () {

        function getEnv() {
            var isHttps = location.protocol === 'https:',
                branchMatch = location.href.match(/__branch=([a-z0-9\-]*)/i),
                // either branch (as set in queryString) or empty string
                branch = (branchMatch && branchMatch.length > 0) ? branchMatch[1] : '';
            return { 'branch': branch, 'isHttps': isHttps};
        }
        function getMode(moduleEnv) {

            //default mode is always http-live
            var mode = 'http-live';

            if (moduleEnv.branch !== '' && moduleEnv.isHttps) {
                // if current protocol is HTTPS and the branch is set, all content will be served from alphas via https, 
                // branch parameter will be persisted in all consequent URLs
                mode = 'https-alpha';
            } else if (moduleEnv.branch !== '') {
                // if current protocol is not https but branch is set, content will be served from alphas with branch 
                // via http, branch will be persisted in all consequent URLs
                mode = 'http-alpha';
            } else if (moduleEnv.isHttps) {
                // if current protocol is https and no branch is set, then it's a live site with 
                // https, all content should be served from live https
                mode = 'https-live';
            }

            // if no conditions apply, it's just a live site served via http
            return mode;
        }

        function getConnectUrl(resource) {
            var env = getEnv(), modulePaths = {
                'https-alpha': 'https://' + env.branch + '.connect.myalpha15.i.mail.ru/',
                'http-alpha':  'http://'  + env.branch + '.connect.myalpha15.i.mail.ru/',
                'https-live':  'https://connect.mail.ru/',
                'http-live':   'http://connect.mail.ru/'
            },
                modulePath = modulePaths[getMode(env)] + resource + '?';
            if (env.branch !== '') {
                modulePath += '__branch=' + env.branch + '&';
            }

            return modulePath;
        }
        function getImgsHost() {
            var env = getEnv(), modulePaths = {
                'https-alpha': 'https://' + env.branch + '.myalpha.imgsmail.ru',
                'http-alpha':  'http://'  + env.branch + '.myalpha.imgsmail.ru',
                'https-live':  'https://my1.imgsmail.ru',
                'http-live':   'http://my1.imgsmail.ru'
            },
                modulePath = modulePaths[getMode(env)];
            return modulePath;
        }
        function getMyHost() {
            var env = getEnv(), modulePaths = {
                'https-alpha': 'https://' + env.branch + '.my.myalpha15.i.mail.ru/cgi-bin/connect/api/',
                'http-alpha':  'http://' + env.branch + '.my.myalpha15.i.mail.ru/cgi-bin/connect/api/',
                'https-live':  'https://my.mail.ru/cgi-bin/connect/api/',
                'http-live':   'http://my.mail.ru/cgi-bin/connect/api/'
            },
                modulePath = modulePaths[getMode(env)];
            return modulePath;
        }
        function getDialogUrl(dialogName) {
            var env = getEnv(), modulePath = getMyHost() + dialogName + '?';
            if (env.branch !== '') {
                modulePath += '__branch=' + env.branch + '&';
            }
            return modulePath;
        }
        function prepareOptions(options) {
            var env = getEnv();
            //adds branch to the options object (for the social apps) if needed
            if (env.branch !== '') {
                /*jslint nomen: true */
                options.__branch = env.branch;
                /*jslint nomen: false */
            }
            return options;
        }

        function api_init(isConnect) {
            isConnect = isConnect || false;

            mailru.intercom.init(isConnect);

            if (mailru.isIE) {
                mailru.utils.addHandler(window, 'load', function () {
                    mailru.connect.initButton();
                });
            } else {
                mailru.connect.initButton();
            }
            mailru.inited = true;

            var css = '#flash-transport-container {height: 0; font-size: 0;}' +
                    '.mrc__translayer {filter: progid:DXImageTransform.Microsoft.Alpha(opacity=70); -moz-opacity: 0.7; -khtml-opacity: 0.7; opacity: 0.7; background: #FFF url(//img6.imgsmail.ru/r/my/preloader_circle_32.gif) no-repeat center center; position: fixed; left: 0; top: 0; width: 100%; height: 100%; z-index: 999999; display: none}\n' +
                    '.mrc__translayer_on iframe {visibility: hidden;}' +
                    '.mrc__translayer_on {background-image:none;}';
            if (mailru.isIE || mailru.isOpera) {
                css += '.mrc__translayer_on object {visibility: hidden}\n';
            }

            var head = document.getElementsByTagName('head')[0],
                style = document.createElement('style'),
                rules = document.createTextNode(css);

            style.type = 'text/css';
            if (style.styleSheet) {
                style.styleSheet.cssText = rules.nodeValue;
            } else {
                style.appendChild(rules);
            }
            head.appendChild(style);
        }

        mailru.isApp = false;
        mailru.app_id = -1;
        mailru.session = false;
        mailru.inited = false;
        mailru.def = {
            DOMAIN: (function () {
                try {
                    return document.URL.match(/(?:https?:\/\/)?([^\/\?#]+)/i)[1];
                } catch (e) {
                    (new Image()).src = '//gstat.imgsmail.ru/gstat?api.param4=1&rnd=' + Math.random();
                    try {
                        return document.domain;
                    } catch (e2) {
                        return '';
                    }
                }
            }()),
            API_URL: (function () {
                // will put alpha urls back as soon as correct certs are set
                // return '//www.appsmail.ru/platform/japi';
                var path = '//', env = getEnv();
                if (env.branch !== "") {
                    path += env.branch + '.myalpha15';
                } else {
                    path += 'www';
                }
                path += ".appsmail.ru/platform/japi";
                return path;
            }()),
            PROXY_URL: getConnectUrl('proxy'),
            CONNECT_FORM_URL: 'http://connect.mail.ru/connect?',
            CONNECT_LOGOUT_URL: 'https://auth.mail.ru/cgi-bin/logout?app=1',
            CONNECT_OAUTH: getConnectUrl('oauth/authorize'),
            CONNECT_XDM_HELPER: '//connect.mail.ru/xdm.html',
            WIDGET_URL: '//my.mail.ru/cgi-bin/connect/api/',
            DIALOG_URL: '//my.mail.ru/cgi-bin/connect/api/',
            GET_DIALOG_URL: getDialogUrl,
            PLUGIN_URL: (function () {
                var url, branch, result = '//connect.mail.ru/';
                try {
                    url = document.location.search;
                    branch = url.match(/__branch=([a-z0-9\-]*)/i);
                    if (branch && branch.length > 1) {
                        result = '//' + branch[1] + '.connect.myalpha15.i.mail.ru/';
                    }
                } catch (ignore) {}
                return result;
            }()),
            EMAIL: {
                BUTTON_URL: 'http://my.mail.ru/cgi-bin/connect/plugin/email?layout=button&'
            },
            LIKE: {
                BUTTON_URL: getConnectUrl('share_button'),
                UBER_BUTTON_URL: getConnectUrl('share_button') + 'uber-share=1&',
                CAPTCHA_URL: getConnectUrl('share') + 'layout=captcha&',
                COMMENT_URL: getConnectUrl('share_comment')
            },
            PERMISSION_URL: 'http://my.mail.ru/cgi-bin/connect/permissions?',
            CONNECT_COOKIE: 'mrc',
            PARTNER_ID_COOKIE: 'partner_id',
            CONNECT_BUTTON_BG_URL: getImgsHost() + '/r/my/app/connect/connect-button.png',
            FLASH_TRANSPORT_URL: getImgsHost() + '/r/my/app/flash_lc_debug3.swf',
            SESSION_REFRESH_EVERY: 60 * 60 * 1000
        };
        var batcher_batchlist = [];
        mailru.batcher = {
            isBatching: false,
            // _batchlist: [],
            start: function () {
                this.isBatching = true;
            },

            /**
             * Batchable GET request
             * @param {String} method                    API method name
             * @param {Hash} params (optional)            API mathod arguments
             * @param {Function} callback (optional)    Callback for result
             * @return {undefined}
             */
            reqest: function (method, params, callback) {

                callback = callback || function () {
                    return;
                };

                var cbid = mailru.callbacks.add(callback);

                params = params || {};
                params.method = method;

                params.app_id = mailru.app_id;
                params.cb = 'mailru.callbacks[' + cbid + ']';
                params.session_key = mailru.session.session_key || '';
                params = mailru.utils.sign(params);

                if (this.isBatching) {
                    batcher_batchlist.push(params);
                } else {
                    mailru.utils.apiOverJSONP(params);
                }
            },
            exec: function () {
                var i, len, batch = {};
                if (this.isBatching) {
                    this.isBatching = false;

                    len = batcher_batchlist.length;
                    i = len - 1;
                    if (len > 0) {
                        while (i >= 0) {
                            batch['request' + i] = mailru.utils.makeGet(batcher_batchlist[i]);
                            i = i - 1;
                        }
                    }

                    batch.method = 'batcher';

                    batch.app_id = mailru.app_id;
                    batch.session_key = mailru.session.session_key || '';
                    batch = mailru.utils.sign(batch);
                    mailru.utils.apiOverJSONP(mailru.utils.sign(batch));
                    batcher_batchlist = {};
                }
            }
        };
        mailru.utils = {
            uniqid: function () {
                return Math.round(Math.random(+new Date() + Math.random()) * 10000000);
            },
            apiOverJSONP: function (params, base) {
                var url, script = document.getElementsByTagName('head')[0].appendChild(document.createElement('script'));
                script.type = 'text/javascript';
                base = base || mailru.def.API_URL;
                url = base + (base.indexOf('?') === -1 ? '?' : '&') + mailru.utils.makeGet(params);
                script.src = url;
            },
            utcDate: function () {
                return parseInt(new Date().getTime() / 1000, 10);
            },
            requestOverProxy: function (params, base) {
                var url, rop, iframe;
                if (mailru.intercomType === 'flash') {
                    if (!mailru.intercom.flash.flashReady) {
                        mailru.events.listen(mailru.common.events.transportReady, function () {
                            mailru.utils.requestOverProxy(params, base);
                        });
                        return false;
                    }
                    params.fcid = mailru.intercom.flash.params.fcid;
                    params.app_id = mailru.app_id;
                }
                base = base || mailru.def.PROXY_URL;
                //params.host = 'http://' + mailru.def.DOMAIN;
                params.host = location.protocol + '//' + mailru.def.DOMAIN;
                url = base + mailru.utils.makeGet(params);
                if (mailru.isApp && mailru.intercomType === 'xdm') {
                    rop = new mrcXDM.Socket({
                        windowName: true,
                        isHost: true,
                        remote: url + '&appProxy=1',
                        onMessage: function (message) {
                            mailru.intercom.receiver(message);
                        }
                    });
                } else {
                    iframe = document.createElement('iframe');
                    iframe.src = url;
                    iframe.style.border = '0';
                    iframe.style.position = 'absolute';
                    iframe.style.left = '-10000px';
                    iframe.style.top = '-10000px';
                    iframe.style.height = '0';
                    document.body.insertBefore(iframe, document.body.getElementsByTagName('*')[0]);
                }

                // never used anywhere, just satisfying jslint here
                return rop;
            },
            makeGet: function (hash) {
                var r = [], k;
                for (k in hash) {
                    if (hash.hasOwnProperty(k)) {
                        r[r.length] = k + '=' + encodeURIComponent(hash[k]);
                    }
                }
                return r.join('&');
            },
            parseGet: function (str) {
                var p = str.split('&'), i = p.length - 1, r = {}, di;
                if (p.length > 0) {
                    while (i >= 0) {
                        di = p[i].indexOf('=');
                        try {
                            r[p[i].substr(0, di)] = decodeURIComponent(p[i].substr(di + 1));
                        } catch (ignore) {
                        }
                        i = i - 1;
                    }
                }
                return r;
            },
            toArray: function (likeArr) {
                var r = [], l = likeArr.length, i = l - 1;

                if (l > 0) {
                    while (i >= 0) {
                        r[i] = likeArr[i];
                        i = i - 1;
                    }
                }

                return r;
            },
            fromJSON: function (str) {
                if (str === undefined || str.replace(/\s+/, '') === '') {
                    return undefined;
                }
                try {
                    return (new Function('return ' + str + ';'))();
                } catch (e) {
                    return str;
                }
            },

            foreach: function (arr, cb) {
                var i, k;
                if (arr.length !== undefined) {
                    for (i = 0; i < arr.length; i += 1) {
                        cb(arr[i], i);
                    }
                } else {
                    for (k in arr) {
                        if (arr.hasOwnProperty(k)) {
                            cb(arr[k], k);
                        }
                    }
                }
            },

            /**
             * Set cookie
             * @param {Hash} opt        Hash like {
             *                                 name: '',        // Required
             *                                 value: '',        // Required, will be escaped
             *                                 domain: '',        // document.location.host by default
             *                                 path: '',        // "/" by default
             *                                 secure: '',
             *                                 expires: '',    // End of session
             *                             }
             * @return {undefined}
             */
            setCookie: function (opt) {

                if (!opt || !opt.name) {
                    return false;
                }

                opt.domain = opt.domain || mailru.def.DOMAIN;
                opt.path = opt.path || '/';

                document.cookie = opt.name + "=" + window.escape(opt.value) +
                    ((opt.expires) ? "; expires=" + (new Date(opt.expires)).toUTCString() : '') +
                    ((opt.path) ? "; path=" + opt.path : '') +
                    ((opt.domain) ? "; domain=." + opt.domain : '') +
                    ((opt.secure) ? "; secure" : '');
            },
            getCookie: function (name) {
                var value = document.cookie.match((new RegExp('(^|;\\s*)' + name + '=([^;]+)(;|$)')));
                if (value) {
                    return window.unescape(value[2]);
                }
                return undefined;
            },
            addHandler: function (obj, name, cb) {
                if (obj.addEventListener) {
                    obj.addEventListener(name, cb, false);
                } else if (obj.attachEvent) {
                    obj.attachEvent('on' + name, cb);
                }
            },
            mixin: function (dst, src, no_override) {
                var k;
                for (k in src) {
                    if (src.hasOwnProperty(k) && (!no_override || !dst[k])) {
                        dst[k] = src[k];
                    }
                }
            },
            extend: function (dst, src) {
                var o = {}, p;
                /*jslint eqeq: true*/
                for (p in src) {
                    if (src.hasOwnProperty(p) && o[p] === undefined && p != 0) {
                        if (dst.hasOwnProperty(p)) {
                            mailru.utils.extend(dst[p], src[p]);
                        } else {
                            dst[p] = src[p];
                        }
                    }
                }
                /*jslint eqeq: false*/
            },
            /* takes hash and returns it modified with .sig property added that is an md5-checksum of required fields */
            sign: function (hash) {
                var arr = [], params = [], k, i, emptyStr = '';
                for (k in hash) {
                    if (hash.hasOwnProperty(k)) {
                        arr[arr.length] = k;
                    }
                }
                arr = arr.sort();
                for  (i = 0; i < arr.length; i += 1) {
                    params += arr[i] + '=' + hash[arr[i]];
                }
                hash.sig = mailru.utils.md5(emptyStr + mailru.session.vid + params + mailru.private_key);
                return hash;
            },
            css: {
                getStyle: function (el, styleProp) {
                    var x = typeof el === 'string' ? document.getElementById(el) : el, y = null;

                    if (x.currentStyle) {
                        y = x.currentStyle[styleProp];
                    } else {
                        if (window.getComputedStyle) {
                            y = document.defaultView.getComputedStyle(x, null).getPropertyValue(styleProp);
                        }
                    }
                    return y;
                }
            },
            md5: function (string) {
                return mailru.utils.CryptoJS.MD5(string).toString();
            },
            modal: {
                open: function (url, params) {
                    var wid, st;
                    if (params.type && params.type === 'modal') {
                        if (mailru.utils.modal.windows.length && mailru.utils.modal.windows.length > 0) {
                            params.wid = params.wid || mailru.utils.uniqid();
                            mailru.utils.modal.queue.add(url, params);
                            return params.wid;
                        }
                    }
                    wid = params.wid || mailru.utils.uniqid();

                    mailru.utils.modal.windows[wid] = document.createElement('iframe');

                    if (params === undefined) {
                        params = {};
                    }
                    if (params.id === undefined) {
                        params.id = wid;
                    }
                    if (params.id === undefined) {
                        params.name = params.id;
                    }
                    if (params.url === undefined) {
                        params.url = {};
                    }
                    params.url.wid = wid;
                    params.url.type = params.type;

                    // yes, we have both appid and app_id properties
                    if (mailru.app_id !== -1) {
                        params.url.appid = mailru.app_id;
                    }
                    params.url.app_id = mailru.app_id;
                    if (mailru.session.session_key) {
                        params.url.session_key = mailru.session.session_key;
                    }
                    if (mailru.intercomType === 'flash') {
                        params.url.fcid = mailru.intercom.flash.params.fcid;
                    }

                    params.url.host = location.protocol + '//' + mailru.def.DOMAIN;
                    url += mailru.utils.makeGet(params.url);
                    mailru.utils.modal.windows[wid].frameBorder = '0';
                    mailru.utils.modal.windows[wid].style.height = 0;
                    mailru.utils.modal.windows[wid].allowtransparency = "true";
                    mailru.utils.modal.windows[wid].scrolling = 'no';
                    if (params.type) {
                        mailru.utils.modal.windows[wid].modalType = params.type;
                    }
                    // if styles are passed — copy them onto the modal window
                    if (params.style) {
                        for (st in params.style) {
                            if (params.style.hasOwnProperty(st)) {
                                mailru.utils.modal.windows[wid].style[st] = params.style[st];
                            }
                        }
                    } else {
                        params.style = {};
                    }
                    // tanslayer is a nice gray overlay on top of the current window, 
                    // it should be created only once
                    if (!mailru.utils.modal.tanslayer) {
                        mailru.utils.modal.tanslayer = document.createElement('div');
                    }

                    // and is shown only for "modal" dialogues
                    if (params.type && params.type === 'modal') {
                        mailru.utils.modal.windows.length += 1;
                        mailru.utils.modal.tanslayer.style.display = 'block';
                        mailru.utils.modal.tanslayer.className = 'mrc__translayer';
                    }
                    if (params.url.tp === 'ok' && params.url.type === 'insertable') {
                        url = 'http://connect.ok.ru/dk?st.cmd=WidgetShare&' +
                              'st.shareUrl=' + params.url.url + '&st.fid=' + params.id + '&st.settings=' +
                              '{width:125,height:25,st:"oval",sz:' + params.url.sz + ',ck:1}';
                    }
                    mailru.utils.modal.windows[wid].src = url;

                    switch (params.type) {
                    case 'modal':
                        document.body.appendChild(mailru.utils.modal.windows[wid]);
                        if (!mailru.utils.modal.tanslayer) {
                            mailru.utils.modal.tanslayer = document.createElement('div');
                        }
                        mailru.utils.modal.tanslayer.className = 'mrc__translayer';
                        mailru.utils.modal.tanslayer.style.display = 'block';
                        if (!mailru.isIE || !mailru.isOpera) {
                            mailru.utils.modal.flashArray = document.getElementsByTagName('object');
                        }
                        if (!mailru.utils.modal.tanslayer.appended) {
                            document.body.appendChild(mailru.utils.modal.tanslayer);
                            mailru.utils.modal.tanslayer.appended = true;
                        }
                        break;
                    case 'insertable':
                        mailru.utils.modal.windows[wid].setAttribute('allowTransparency', true);
                        if (params.insertOptions.insertAfter) {
                            params.place = params.place.nextSibling;
                        }
                        if (params.insertOptions.position) {
                            mailru.utils.modal.windows[wid].style.position = "absolute";
                            mailru.utils.modal.windows[wid].style.left = params.insertOptions.position.left + "px";
                            mailru.utils.modal.windows[wid].style.top = params.insertOptions.position.top + "px";
                        }
                        if (params.insertOptions.body) {
                            document.body.appendChild(mailru.utils.modal.windows[wid]);
                        } else {
                            if (params.insertOptions.wrap) {
                                var wrp = document.createElement('span');
                                wrp.setAttribute('style', 'position: relative; left: 0; top: 0; margin: 0; padding: 0; visibility: visible;');
                                wrp.appendChild(mailru.utils.modal.windows[wid]);
                                params.place.parentNode.insertBefore(wrp, params.place);
                            } else {
                                params.place.parentNode.insertBefore(mailru.utils.modal.windows[wid], params.place);
                            }
                        }
                        if (!params.insertOptions.noreplace) {
                            params.place.style.display = 'none';
                        }
                        break;
                    }
                    mailru.utils.modal.windows[wid].type = params.type;
                    mailru.utils.modal.windows[wid].name = params.name;
                    mailru.utils.modal.windows[wid].id = params.id;
                    if (params.type === 'modal') {
                        mailru.utils.modal.windows[wid].style.width = params.style.width || '515px';
                        mailru.utils.modal.windows[wid].style.height = '0';
                        mailru.utils.modal.windows[wid].style.marginLeft = '-10000px';
                        mailru.utils.modal.windows[wid].style.top = '50%';
                        mailru.utils.modal.windows[wid].style.left = '50%';
                        mailru.utils.modal.windows[wid].style.position = 'absolute';
                        mailru.utils.modal.windows[wid].style.zIndex = '999999999';
                    }
                    if (params.type === 'insertable') {
                        mailru.utils.modal.windows[wid].style.backgroundColor = 'transparent';
                        if (params.url.width) {
                            params.url.width = params.url.width.toString();
                            switch (params.url.width.replace(/\d*/gim, '')) {
                            case "em":
                                params.url.width = params.url.width.replace(/\D*/gim, '') + 'em';
                                break;
                            case "px":
                                params.url.width = params.url.width.replace(/\D*/gim, '') + 'px';
                                break;
                            case "%":
                                params.url.width = params.url.width.replace(/\D*/gim, '') + '%';
                                break;
                            default:
                                params.url.width = params.url.width.replace(/\D*/gim, '') + 'px';
                            }
                            mailru.utils.modal.windows[wid].style.width = params.url.width;
                        }


                        mailru.utils.modal.windows[wid].style.height = params.url.height + 'px' || '';

                    }
                    mailru.utils.modal.windows[wid].style.border = 'solid #FFFF00 0px';

                    // whenever the main window is resized, we need to resize the modal dialogue accordingly
                    mailru.events.listen(mailru.common.events.modalWindow, function (d) {
                        mailru.utils.modal.resize(d.wid, d.modalWindowWidth, d.modalWindowHeight);
                    });
                    return wid;
                },
                close: function (wid) {
                    var i, j, queueModal;
                    if (mailru.utils.modal.windows[wid] === undefined) {
                        return false;
                    }
                    if (mailru.utils.modal.tanslayer) {
                        mailru.utils.modal.tanslayer.style.display = 'none';
                    }

                    document.body.className = document.body.className.replace('mrc__translayer_on', '');
                    if (!mailru.isIE && !mailru.isOpera) {
                        for (i = 0; i < mailru.utils.modal.flashArray.length; i += 1) {
                            mailru.utils.modal.flashArray[i].style.zIndex = mailru.utils.modal.flashArray[i].originalZIndex;
                            if (mailru.utils.modal.flashArray[i].noWmode) {
                                for (j = 0; j < mailru.utils.modal.flashArray[i].childNodes.length; j += 1) {
                                    if (mailru.utils.modal.flashArray[i].childNodes[j].value === 'opaque') {
                                        mailru.utils.modal.flashArray[i].removeChild(mailru.utils.modal.flashArray[i].childNodes[j]);
                                    }
                                }
                            }
                        }
                    }
                    if (wid !== undefined && mailru.utils.modal.windows[wid] !== undefined && mailru.utils.modal.windows[wid].parentNode !== null) {
                        mailru.utils.modal.windows[wid].parentNode.removeChild(mailru.utils.modal.windows[wid]);
                        if (mailru.utils.modal.windows[wid].modalType && mailru.utils.modal.windows[wid].modalType === 'modal') {
                            mailru.utils.modal.windows.length -= 1;
                        }
                        delete mailru.utils.modal.windows[wid];

                        queueModal = mailru.utils.modal.queue.get();
                        if (queueModal !== undefined) {
                            mailru.utils.modal.open(queueModal.url, queueModal.params);
                        }
                    }
                },
                resize: function (wid, w, h) {
                    var i;
                    if (wid !== undefined && mailru.utils.modal.windows[wid] !== undefined) {
                        if (mailru.utils.modal.windows[wid].type === 'modal') {
                            for (i = 0; i < mailru.utils.modal.flashArray.length; i += 1) {
                                if (!mailru.isIE && !mailru.isOpera) {
                                    if (mailru.utils.modal.flashArray[i].innerHTML.indexOf('wmode') === -1) {
                                        mailru.utils.modal.flashArray[i].noWmode = true;
                                        mailru.utils.modal.flashArray[i].paramWmode = '<param name="wmode" value="opaque" />';
                                        mailru.utils.modal.flashArray[i].innerHTML += mailru.utils.modal.flashArray[i].paramWmode;
                                        mailru.utils.modal.flashArray[i].originalPosition = mailru.utils.getStyle(mailru.utils.modal.flashArray[i], 'position');
                                        if (mailru.utils.modal.flashArray[i].originalPosition !== 'static') {
                                            mailru.utils.modal.flashArray[i].originalZIndex = mailru.utils.getStyle(mailru.utils.modal.flashArray[i], 'zIndex');
                                            mailru.utils.modal.flashArray[i].style.zIndex = '1';
                                        } else {
                                            mailru.utils.modal.flashArray[i].style.position = 'relative';
                                        }
                                    }
                                }
                            }
                            document.body.setAttribute('class', (document.body.getAttribute('className') || '') + ' mrc__translayer_on');
                            mailru.utils.modal.tanslayer.style.display = 'block';
                        }
                        setTimeout(function () {
                            if (!mailru.utils.modal.windows[wid]) {
                                return;
                            }
                            mailru.utils.modal.windows[wid].frameborder = '0';
                            if (w && w !== 'false') {
                                mailru.utils.modal.windows[wid].style.width = parseInt(w, 10) + 'px';
                                if (mailru.utils.modal.windows[wid].modalType && mailru.utils.modal.windows[wid].modalType === 'modal') {
                                    mailru.utils.modal.windows[wid].style.marginLeft = '-' + parseInt(w, 10) / 2 + 'px';
                                }
                            }
                            if (h) {
                                mailru.utils.modal.windows[wid].style.height = parseInt(h, 10) + 'px';
                            }
                            mailru.utils.modal.windows[wid].style.borderStyle = "none";

                            if (!mailru.isApp) {
                                mailru.utils.modal.windows[wid].style.display = 'block';
                            }

                            if (mailru.utils.modal.windows[wid].type === 'modal') {
                                mailru.utils.modal.windows[wid].style.top = mailru.utils.modal.getScrollTop() + mailru.utils.modal.getWindowSize() / 2 - h / 2 + 'px';
                                mailru.utils.modal.windows[wid].style.visibility = 'visible';
                            }
                        }, 5);
                    }
                    return true;
                },
                getScrollTop: function () {
                    return window.self.pageYOffset || (document.documentElement && document.documentElement.scrollTop) || (document.body && document.body.scrollTop);
                },
                getWindowSize: function () {
                    return typeof window.innerHeight === 'number' ? window.innerHeight : (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight ? document.documentElement.clientHeight : (document.body && (document.body.clientWidth || document.body.clientHeight ? document.body.clientHeight : null))));
                },
                translayer: null,
                flashArray: [],
                windows: {
                    length: 0
                },
                queue: {
                    elements: null,
                    add: function (url, params) {
                        if (!this.elements) {
                            this.elements = [];
                        }
                        this.elements.push({url: url, params: params});
                        this.length = this.elements.length;
                    },
                    get: function () {
                        var el;
                        if (this.length) {
                            this.length -= 1;
                            el = this.elements[0] || false;
                            this.elements = this.elements.slice(1);
                            return el;
                        }
                    },
                    length: 0
                }
            },
            window: {
                getBody: function (w) {
                    if (!w) {
                        w = window;
                    }
                    return w.document.body;
                },
                // seems to be not used at all — grep didn't show any occurrences 
                getDocumentWidth: function (w) {
                    if (!w) {
                        w = window;
                    }
                    if (mailru.isIE) {
                        return mailru.utils.window.getBody(w).scrollWidth;
                    }
                    if (mailru.isOpera) {
                        return w.document.body.style.pixelWidth;
                    }
                    return w.document.width;
                },
                // seems to be not used at all — grep didn't show any occurrences 
                getDocumentHeight: function (w) {
                    if (!w) {
                        w = window;
                    }
                    if (mailru.isIE) {
                        return mailru.utils.window.getBody(w).scrollHeight;
                    }
                    if (mailru.isOpera) {
                        return w.document.body.style.pixelHeight;
                    }
                    return w.document.height;
                },
                // seems to be not used at all — grep didn't show any occurrences 
                getClientWidth: function () {
                    return document.compatMode === 'CSS1Compat' && !window.opera ? document.documentElement.clientWidth : document.body.clientWidth;
                },
                // seems to be not used at all — grep didn't show any occurrences 
                getClientHeight: function () {
                    return document.compatMode === 'CSS1Compat' && !window.opera ? document.documentElement.clientHeight : document.body.clientHeight;
                },
                getPosition: function (el) {
                    function getOffsetRect(el) {
                        var box = el.getBoundingClientRect(),
                            body = document.body,
                            docElem = document.documentElement,
                            scrollTop = window.pageYOffset || docElem.scrollTop || body.scrollTop,
                            scrollLeft = window.pageXOffset || docElem.scrollLeft || body.scrollLeft,
                            clientTop = docElem.clientTop || body.clientTop || 0,
                            clientLeft = docElem.clientLeft || body.clientLeft || 0,
                            top = box.top + scrollTop - clientTop,
                            left = box.left + scrollLeft - clientLeft;
                        return { top: Math.round(top), left: Math.round(left) };
                    }

                    function getOffsetSum(el) {
                        var top = 0, left = 0;
                        while (el) {
                            top = top + parseInt(el.offsetTop, 10);
                            left = left + parseInt(el.offsetLeft, 10);
                            el = el.offsetParent;
                        }
                        return {top: top, left: left};
                    }

                    if (el.getBoundingClientRect) {
                        return getOffsetRect(el);
                    }
                    return getOffsetSum(el);
                }
            }
        };

        /*
        CryptoJS v3.1.2
        code.google.com/p/crypto-js
        (c) 2009-2013 by Jeff Mott. All rights reserved.
        code.google.com/p/crypto-js/wiki/License

        made jslint-compliant
        */
        /**
         * CryptoJS core components.
         */
        /*jslint nomen: true*/
        /*jslint bitwise: true */
        /*jslint unparam: false*/
        mailru.utils.CryptoJS = (function (Math) {
            /**
             * CryptoJS namespace.
             */
            var C = {}, Hex, C_lib, Base, WordArray, C_enc, Latin1, Utf8, BufferedBlockAlgorithm, C_algo;

            /**
             * Library namespace.
             */
            C.lib = {};
            C_lib = C.lib;

            /**
             * Base object for prototypal inheritance.
             */
            C_lib.Base = (function () {
                function F() {
                    return this;
                }

                return {
                    /**
                     * Creates a new object that inherits from this object.
                     *
                     * @param {Object} overrides Properties to copy into the new object.
                     *
                     * @return {Object} The new object.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var MyType = CryptoJS.lib.Base.extend({
                     *         field: 'value',
                     *
                     *         method: function () {
                     *         }
                     *     });
                     */
                    extend: function (overrides) {
                        // Spawn
                        F.prototype = this;
                        var subtype = new F();

                        // Augment
                        if (overrides) {
                            subtype.mixIn(overrides);
                        }

                        // Create default initializer
                        if (!subtype.hasOwnProperty('init')) {
                            subtype.init = function () {
                                subtype.$super.init.apply(this, arguments);
                            };
                        }

                        // Initializer's prototype is the subtype object
                        subtype.init.prototype = subtype;

                        // Reference supertype
                        subtype.$super = this;

                        return subtype;
                    },

                    /**
                     * Extends this object and runs the init method.
                     * Arguments to create() will be passed to init().
                     *
                     * @return {Object} The new object.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var instance = MyType.create();
                     */
                    create: function () {
                        var instance = this.extend();
                        instance.init.apply(instance, arguments);

                        return instance;
                    },

                    /**
                     * Initializes a newly created object.
                     * Override this method to add some logic when your objects are created.
                     *
                     * @example
                     *
                     *     var MyType = CryptoJS.lib.Base.extend({
                     *         init: function () {
                     *             // ...
                     *         }
                     *     });
                     */
                    init: function () {
                        return undefined;
                    },

                    /**
                     * Copies properties into this object.
                     *
                     * @param {Object} properties The properties to mix in.
                     *
                     * @example
                     *
                     *     MyType.mixIn({
                     *         field: 'value'
                     *     });
                     */
                    mixIn: function (properties) {
                        var propertyName;
                        for (propertyName in properties) {
                            if (properties.hasOwnProperty(propertyName)) {
                                this[propertyName] = properties[propertyName];
                            }
                        }

                        // IE won't copy toString using the loop above
                        if (properties.hasOwnProperty('toString')) {
                            this.toString = properties.toString;
                        }
                    },

                    /**
                     * Creates a copy of this object.
                     *
                     * @return {Object} The clone.
                     *
                     * @example
                     *
                     *     var clone = instance.clone();
                     */
                    clone: function () {
                        return this.init.prototype.extend(this);
                    }
                };
            }());
            Base = C_lib.Base;

            /**
             * An array of 32-bit words.
             *
             * @property {Array} words The array of 32-bit words.
             * @property {number} sigBytes The number of significant bytes in this word array.
             */
            C_lib.WordArray = Base.extend({
                /**
                 * Initializes a newly created word array.
                 *
                 * @param {Array} words (Optional) An array of 32-bit words.
                 * @param {number} sigBytes (Optional) The number of significant bytes in the words.
                 *
                 * @example
                 *
                 *     var wordArray = CryptoJS.lib.WordArray.create();
                 *     var wordArray = CryptoJS.lib.WordArray.create([0x00010203, 0x04050607]);
                 *     var wordArray = CryptoJS.lib.WordArray.create([0x00010203, 0x04050607], 6);
                 */
                init: function (words, sigBytes) {
                    words = this.words = words || [];

                    if (sigBytes !== undefined) {
                        this.sigBytes = sigBytes;
                    } else {
                        this.sigBytes = words.length * 4;
                    }
                },

                /**
                 * Converts this word array to a string.
                 *
                 * @param {Encoder} encoder (Optional) The encoding strategy to use. Default: CryptoJS.enc.Hex
                 *
                 * @return {string} The stringified word array.
                 *
                 * @example
                 *
                 *     var string = wordArray + '';
                 *     var string = wordArray.toString();
                 *     var string = wordArray.toString(CryptoJS.enc.Utf8);
                 */
                toString: function (encoder) {
                    return (encoder || Hex).stringify(this);
                },

                /**
                 * Concatenates a word array to this word array.
                 *
                 * @param {WordArray} wordArray The word array to append.
                 *
                 * @return {WordArray} This word array.
                 *
                 * @example
                 *
                 *     wordArray1.concat(wordArray2);
                 */
                concat: function (wordArray) {
                    // Shortcuts
                    var thisWords = this.words;
                    var thatWords = wordArray.words;
                    var thisSigBytes = this.sigBytes;
                    var thatSigBytes = wordArray.sigBytes;
                    var i, thatByte;

                    // Clamp excess bits
                    this.clamp();

                    // Concat
                    /*jslint bitwise: true */
                    if (thisSigBytes % 4) {
                        // Copy one byte at a time
                        for (i = 0; i < thatSigBytes; i += 1) {
                            thatByte = (thatWords[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
                            thisWords[(thisSigBytes + i) >>> 2] |= thatByte << (24 - ((thisSigBytes + i) % 4) * 8);
                        }
                    } else if (thatWords.length > 0xffff) {
                        // Copy one word at a time
                        for (i = 0; i < thatSigBytes; i += 4) {
                            thisWords[(thisSigBytes + i) >>> 2] = thatWords[i >>> 2];
                        }
                    } else {
                        // Copy all words at once
                        thisWords.push.apply(thisWords, thatWords);
                    }
                    this.sigBytes += thatSigBytes;
                    /*jslint bitwise: false */

                    // Chainable
                    return this;
                },

                /**
                 * Removes insignificant bits.
                 *
                 * @example
                 *
                 *     wordArray.clamp();
                 */
                clamp: function () {
                    // Shortcuts
                    var words = this.words;
                    var sigBytes = this.sigBytes;

                    // Clamp
                    /*jslint bitwise: true */
                    words[sigBytes >>> 2] &= 0xffffffff << (32 - (sigBytes % 4) * 8);
                    /*jslint bitwise: false */
                    words.length = Math.ceil(sigBytes / 4);
                },

                /**
                 * Creates a copy of this word array.
                 *
                 * @return {WordArray} The clone.
                 *
                 * @example
                 *
                 *     var clone = wordArray.clone();
                 */
                clone: function () {
                    var clone = Base.clone.call(this);
                    clone.words = this.words.slice(0);

                    return clone;
                },

                /**
                 * Creates a word array filled with random bytes.
                 *
                 * @param {number} nBytes The number of random bytes to generate.
                 *
                 * @return {WordArray} The random word array.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var wordArray = CryptoJS.lib.WordArray.random(16);
                 */
                random: function (nBytes) {
                    var words = [], i;
                    for (i = 0; i < nBytes; i += 4) {
                        /*jslint bitwise: true */
                        words.push((Math.random() * 0x100000000) | 0);
                        /*jslint bitwise: false */
                    }

                    return new WordArray.init(words, nBytes);
                }
            });
            WordArray = C_lib.WordArray;

            /**
             * Encoder namespace.
             */
            C.enc = {};
            C_enc = C.enc;

            /**
             * Hex encoding strategy.
             */
            C_enc.Hex = {
                /**
                 * Converts a word array to a hex string.
                 *
                 * @param {WordArray} wordArray The word array.
                 *
                 * @return {string} The hex string.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var hexString = CryptoJS.enc.Hex.stringify(wordArray);
                 */
                stringify: function (wordArray) {
                    // Shortcuts
                    var words = wordArray.words;
                    var sigBytes = wordArray.sigBytes;

                    // Convert
                    var hexChars = [], i, bite;
                    for (i = 0; i < sigBytes; i += 1) {
                        /*jslint bitwise: true */
                        bite = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
                        hexChars.push((bite >>> 4).toString(16));
                        hexChars.push((bite & 0x0f).toString(16));
                        /*jslint bitwise: false */
                    }

                    return hexChars.join('');
                },

                /**
                 * Converts a hex string to a word array.
                 *
                 * @param {string} hexStr The hex string.
                 *
                 * @return {WordArray} The word array.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var wordArray = CryptoJS.enc.Hex.parse(hexString);
                 */
                parse: function (hexStr) {
                    // Shortcut
                    var hexStrLength = hexStr.length;

                    // Convert
                    var words = [], i;
                    for (i = 0; i < hexStrLength; i += 2) {
                        /*jslint bitwise: true */
                        words[i >>> 3] |= parseInt(hexStr.substr(i, 2), 16) << (24 - (i % 8) * 4);
                        /*jslint bitwise: false */
                    }

                    return new WordArray.init(words, hexStrLength / 2);
                }
            };
            Hex = C_enc.Hex;

            /**
             * Latin1 encoding strategy.
             */
            C_enc.Latin1 = {
                /**
                 * Converts a word array to a Latin1 string.
                 *
                 * @param {WordArray} wordArray The word array.
                 *
                 * @return {string} The Latin1 string.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var latin1String = CryptoJS.enc.Latin1.stringify(wordArray);
                 */
                stringify: function (wordArray) {
                    // Shortcuts
                    var words = wordArray.words;
                    var sigBytes = wordArray.sigBytes;

                    // Convert
                    var latin1Chars = [], i, bite;
                    for (i = 0; i < sigBytes; i += 1) {
                        /*jslint bitwise: true */
                        bite = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
                        latin1Chars.push(String.fromCharCode(bite));
                        /*jslint bitwise: false */
                    }

                    return latin1Chars.join('');
                },

                /**
                 * Converts a Latin1 string to a word array.
                 *
                 * @param {string} latin1Str The Latin1 string.
                 *
                 * @return {WordArray} The word array.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var wordArray = CryptoJS.enc.Latin1.parse(latin1String);
                 */
                parse: function (latin1Str) {
                    // Shortcut
                    var latin1StrLength = latin1Str.length;

                    // Convert
                    var words = [], i;
                    for (i = 0; i < latin1StrLength; i += 1) {
                        /*jslint bitwise: true */
                        words[i >>> 2] |= (latin1Str.charCodeAt(i) & 0xff) << (24 - (i % 4) * 8);
                        /*jslint bitwise: false */
                    }

                    return new WordArray.init(words, latin1StrLength);
                }
            };
            Latin1 = C_enc.Latin1;

            /**
             * UTF-8 encoding strategy.
             */
            C_enc.Utf8 = {
                /**
                 * Converts a word array to a UTF-8 string.
                 *
                 * @param {WordArray} wordArray The word array.
                 *
                 * @return {string} The UTF-8 string.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var utf8String = CryptoJS.enc.Utf8.stringify(wordArray);
                 */
                stringify: function (wordArray) {
                    try {
                        return decodeURIComponent(window.escape(Latin1.stringify(wordArray)));
                    } catch (e) {
                        throw new Error('Malformed UTF-8 data');
                    }
                },

                /**
                 * Converts a UTF-8 string to a word array.
                 *
                 * @param {string} utf8Str The UTF-8 string.
                 *
                 * @return {WordArray} The word array.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var wordArray = CryptoJS.enc.Utf8.parse(utf8String);
                 */
                parse: function (utf8Str) {
                    return Latin1.parse(window.unescape(encodeURIComponent(utf8Str)));
                }
            };
            Utf8 = C_enc.Utf8;

            /**
             * Abstract buffered block algorithm template.
             *
             * The property blockSize must be implemented in a concrete subtype.
             *
             * @property {number} _minBufferSize The number of blocks that should be kept unprocessed in the buffer. Default: 0
             */
            C_lib.BufferedBlockAlgorithm = Base.extend({
                /**
                 * Resets this block algorithm's data buffer to its initial state.
                 *
                 * @example
                 *
                 *     bufferedBlockAlgorithm.reset();
                 */
                reset: function () {
                    // Initial values
                    this._data = new WordArray.init();
                    this._nDataBytes = 0;
                },

                /**
                 * Adds new data to this block algorithm's buffer.
                 *
                 * @param {WordArray|string} data The data to append. Strings are converted to a WordArray using UTF-8.
                 *
                 * @example
                 *
                 *     bufferedBlockAlgorithm._append('data');
                 *     bufferedBlockAlgorithm._append(wordArray);
                 */
                _append: function (data) {
                    // Convert string to WordArray, else assume WordArray already
                    if (typeof data === 'string') {
                        data = Utf8.parse(data);
                    }

                    // Append
                    this._data.concat(data);
                    this._nDataBytes += data.sigBytes;
                },

                /**
                 * Processes available data blocks.
                 *
                 * This method invokes _doProcessBlock(offset), which must be implemented by a concrete subtype.
                 *
                 * @param {boolean} doFlush Whether all blocks and partial blocks should be processed.
                 *
                 * @return {WordArray} The processed data.
                 *
                 * @example
                 *
                 *     var processedData = bufferedBlockAlgorithm._process();
                 *     var processedData = bufferedBlockAlgorithm._process(!!'flush');
                 */
                _process: function (doFlush) {
                    // Shortcuts
                    var data = this._data,
                        dataWords = data.words,
                        dataSigBytes = data.sigBytes,
                        blockSize = this.blockSize,
                        blockSizeBytes = blockSize * 4;

                    // Count blocks ready
                    var nBlocksReady = dataSigBytes / blockSizeBytes;
                    if (doFlush) {
                        // Round up to include partial blocks
                        nBlocksReady = Math.ceil(nBlocksReady);
                    } else {
                        // Round down to include only full blocks,
                        // less the number of blocks that must remain in the buffer
                        nBlocksReady = Math.max((nBlocksReady | 0) - this._minBufferSize, 0);
                    }

                    // Count words ready
                    var nWordsReady = nBlocksReady * blockSize;

                    // Count bytes ready
                    var nBytesReady = Math.min(nWordsReady * 4, dataSigBytes);
                    var offset;
                    var processedWords;

                    // Process blocks
                    if (nWordsReady) {
                        for (offset = 0; offset < nWordsReady; offset += blockSize) {
                            // Perform concrete-algorithm logic
                            this._doProcessBlock(dataWords, offset);
                        }

                        // Remove processed words
                        processedWords = dataWords.splice(0, nWordsReady);
                        data.sigBytes -= nBytesReady;
                    }

                    // Return processed words
                    return new WordArray.init(processedWords, nBytesReady);
                },

                /**
                 * Creates a copy of this object.
                 *
                 * @return {Object} The clone.
                 *
                 * @example
                 *
                 *     var clone = bufferedBlockAlgorithm.clone();
                 */
                clone: function () {
                    var clone = Base.clone.call(this);
                    clone._data = this._data.clone();

                    return clone;
                },

                _minBufferSize: 0
            });
            BufferedBlockAlgorithm = C_lib.BufferedBlockAlgorithm;

            /**
             * Abstract hasher template.
             *
             * @property {number} blockSize The number of 32-bit words this hasher operates on. Default: 16 (512 bits)
             */
            C_lib.Hasher = BufferedBlockAlgorithm.extend({
                /**
                 * Configuration options.
                 */
                cfg: Base.extend(),

                /**
                 * Initializes a newly created hasher.
                 *
                 * @param {Object} cfg (Optional) The configuration options to use for this hash computation.
                 *
                 * @example
                 *
                 *     var hasher = CryptoJS.algo.SHA256.create();
                 */
                init: function (cfg) {
                    // Apply config defaults
                    this.cfg = this.cfg.extend(cfg);

                    // Set initial values
                    this.reset();
                },

                /**
                 * Resets this hasher to its initial state.
                 *
                 * @example
                 *
                 *     hasher.reset();
                 */
                reset: function () {
                    // Reset data buffer
                    BufferedBlockAlgorithm.reset.call(this);

                    // Perform concrete-hasher logic
                    this._doReset();
                },

                /**
                 * Updates this hasher with a message.
                 *
                 * @param {WordArray|string} messageUpdate The message to append.
                 *
                 * @return {Hasher} This hasher.
                 *
                 * @example
                 *
                 *     hasher.update('message');
                 *     hasher.update(wordArray);
                 */
                update: function (messageUpdate) {
                    // Append
                    this._append(messageUpdate);

                    // Update the hash
                    this._process();

                    // Chainable
                    return this;
                },

                /**
                 * Finalizes the hash computation.
                 * Note that the finalize operation is effectively a destructive, read-once operation.
                 *
                 * @param {WordArray|string} messageUpdate (Optional) A final message update.
                 *
                 * @return {WordArray} The hash.
                 *
                 * @example
                 *
                 *     var hash = hasher.finalize();
                 *     var hash = hasher.finalize('message');
                 *     var hash = hasher.finalize(wordArray);
                 */
                finalize: function (messageUpdate) {
                    // Final message update
                    if (messageUpdate) {
                        this._append(messageUpdate);
                    }

                    // Perform concrete-hasher logic
                    var hash = this._doFinalize();

                    return hash;
                },

                blockSize: 512 / 32,

                /**
                 * Creates a shortcut function to a hasher's object interface.
                 *
                 * @param {Hasher} hasher The hasher to create a helper for.
                 *
                 * @return {Function} The shortcut function.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var SHA256 = CryptoJS.lib.Hasher._createHelper(CryptoJS.algo.SHA256);
                 */
                _createHelper: function (hasher) {
                    return function (message, cfg) {
                        return new hasher.init(cfg).finalize(message);
                    };
                },

                /**
                 * Creates a shortcut function to the HMAC's object interface.
                 *
                 * @param {Hasher} hasher The hasher to use in this HMAC helper.
                 *
                 * @return {Function} The shortcut function.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var HmacSHA256 = CryptoJS.lib.Hasher._createHmacHelper(CryptoJS.algo.SHA256);
                 */
                _createHmacHelper: function (hasher) {
                    return function (message, key) {
                        return new C_algo.HMAC.init(hasher, key).finalize(message);
                    };
                }
            });

            /**
             * Algorithm namespace.
             */
            C.algo = {};
            C_algo = C.algo;

            return C;
        }(Math));
        (function (Math) {
            // Shortcuts
            var C = mailru.utils.CryptoJS;
            var C_lib = C.lib;
            var WordArray = C_lib.WordArray;
            var Hasher = C_lib.Hasher;
            var C_algo = C.algo;

            // Constants table
            var T = [];

            // Compute constants
            (function () {
                var i;
                for (i = 0; i < 64; i += 1) {
                    T[i] = (Math.abs(Math.sin(i + 1)) * 0x100000000) | 0;
                }
            }());

            function FF(a, b, c, d, x, s, t) {
                var n = a + ((b & c) | (~b & d)) + x + t;
                return ((n << s) | (n >>> (32 - s))) + b;
            }

            function GG(a, b, c, d, x, s, t) {
                var n = a + ((b & d) | (c & ~d)) + x + t;
                return ((n << s) | (n >>> (32 - s))) + b;
            }

            function HH(a, b, c, d, x, s, t) {
                var n = a + (b ^ c ^ d) + x + t;
                return ((n << s) | (n >>> (32 - s))) + b;
            }

            function II(a, b, c, d, x, s, t) {
                var n = a + (c ^ (b | ~d)) + x + t;
                return ((n << s) | (n >>> (32 - s))) + b;
            }


            /**
             * MD5 hash algorithm.
             */
            C_algo.MD5 = Hasher.extend({
                _doReset: function () {
                    this._hash = new WordArray.init([
                        0x67452301, 0xefcdab89,
                        0x98badcfe, 0x10325476
                    ]);
                },

                _doProcessBlock: function (M, offset) {
                    var i, offset_i, M_offset_i, H,
                        M_offset_0, M_offset_1, M_offset_2,
                        M_offset_3, M_offset_4, M_offset_5,
                        M_offset_6, M_offset_7, M_offset_8,
                        M_offset_9, M_offset_10, M_offset_11,
                        M_offset_12, M_offset_13, M_offset_14,
                        M_offset_15, a, b, c, d;

                    // Swap endian
                    for (i = 0; i < 16; i += 1) {
                        // Shortcuts
                        offset_i = offset + i;
                        M_offset_i = M[offset_i];

                        M[offset_i] = (
                            (((M_offset_i << 8)  | (M_offset_i >>> 24)) & 0x00ff00ff) |
                            (((M_offset_i << 24) | (M_offset_i >>> 8))  & 0xff00ff00)
                        );
                    }

                    // Shortcuts
                    /*jslint nomen: true*/
                    H = this._hash.words;
                    M_offset_0  = M[offset];
                    M_offset_1  = M[offset + 1];
                    M_offset_2  = M[offset + 2];
                    M_offset_3  = M[offset + 3];
                    M_offset_4  = M[offset + 4];
                    M_offset_5  = M[offset + 5];
                    M_offset_6  = M[offset + 6];
                    M_offset_7  = M[offset + 7];
                    M_offset_8  = M[offset + 8];
                    M_offset_9  = M[offset + 9];
                    M_offset_10 = M[offset + 10];
                    M_offset_11 = M[offset + 11];
                    M_offset_12 = M[offset + 12];
                    M_offset_13 = M[offset + 13];
                    M_offset_14 = M[offset + 14];
                    M_offset_15 = M[offset + 15];
                    a = H[0];
                    b = H[1];
                    c = H[2];
                    d = H[3];
                    /*jslint nomen: false*/

                    // Computation
                    a = FF(a, b, c, d, M_offset_0,  7,  T[0]);
                    d = FF(d, a, b, c, M_offset_1,  12, T[1]);
                    c = FF(c, d, a, b, M_offset_2,  17, T[2]);
                    b = FF(b, c, d, a, M_offset_3,  22, T[3]);
                    a = FF(a, b, c, d, M_offset_4,  7,  T[4]);
                    d = FF(d, a, b, c, M_offset_5,  12, T[5]);
                    c = FF(c, d, a, b, M_offset_6,  17, T[6]);
                    b = FF(b, c, d, a, M_offset_7,  22, T[7]);
                    a = FF(a, b, c, d, M_offset_8,  7,  T[8]);
                    d = FF(d, a, b, c, M_offset_9,  12, T[9]);
                    c = FF(c, d, a, b, M_offset_10, 17, T[10]);
                    b = FF(b, c, d, a, M_offset_11, 22, T[11]);
                    a = FF(a, b, c, d, M_offset_12, 7,  T[12]);
                    d = FF(d, a, b, c, M_offset_13, 12, T[13]);
                    c = FF(c, d, a, b, M_offset_14, 17, T[14]);
                    b = FF(b, c, d, a, M_offset_15, 22, T[15]);

                    a = GG(a, b, c, d, M_offset_1,  5,  T[16]);
                    d = GG(d, a, b, c, M_offset_6,  9,  T[17]);
                    c = GG(c, d, a, b, M_offset_11, 14, T[18]);
                    b = GG(b, c, d, a, M_offset_0,  20, T[19]);
                    a = GG(a, b, c, d, M_offset_5,  5,  T[20]);
                    d = GG(d, a, b, c, M_offset_10, 9,  T[21]);
                    c = GG(c, d, a, b, M_offset_15, 14, T[22]);
                    b = GG(b, c, d, a, M_offset_4,  20, T[23]);
                    a = GG(a, b, c, d, M_offset_9,  5,  T[24]);
                    d = GG(d, a, b, c, M_offset_14, 9,  T[25]);
                    c = GG(c, d, a, b, M_offset_3,  14, T[26]);
                    b = GG(b, c, d, a, M_offset_8,  20, T[27]);
                    a = GG(a, b, c, d, M_offset_13, 5,  T[28]);
                    d = GG(d, a, b, c, M_offset_2,  9,  T[29]);
                    c = GG(c, d, a, b, M_offset_7,  14, T[30]);
                    b = GG(b, c, d, a, M_offset_12, 20, T[31]);

                    a = HH(a, b, c, d, M_offset_5,  4,  T[32]);
                    d = HH(d, a, b, c, M_offset_8,  11, T[33]);
                    c = HH(c, d, a, b, M_offset_11, 16, T[34]);
                    b = HH(b, c, d, a, M_offset_14, 23, T[35]);
                    a = HH(a, b, c, d, M_offset_1,  4,  T[36]);
                    d = HH(d, a, b, c, M_offset_4,  11, T[37]);
                    c = HH(c, d, a, b, M_offset_7,  16, T[38]);
                    b = HH(b, c, d, a, M_offset_10, 23, T[39]);
                    a = HH(a, b, c, d, M_offset_13, 4,  T[40]);
                    d = HH(d, a, b, c, M_offset_0,  11, T[41]);
                    c = HH(c, d, a, b, M_offset_3,  16, T[42]);
                    b = HH(b, c, d, a, M_offset_6,  23, T[43]);
                    a = HH(a, b, c, d, M_offset_9,  4,  T[44]);
                    d = HH(d, a, b, c, M_offset_12, 11, T[45]);
                    c = HH(c, d, a, b, M_offset_15, 16, T[46]);
                    b = HH(b, c, d, a, M_offset_2,  23, T[47]);

                    a = II(a, b, c, d, M_offset_0,  6,  T[48]);
                    d = II(d, a, b, c, M_offset_7,  10, T[49]);
                    c = II(c, d, a, b, M_offset_14, 15, T[50]);
                    b = II(b, c, d, a, M_offset_5,  21, T[51]);
                    a = II(a, b, c, d, M_offset_12, 6,  T[52]);
                    d = II(d, a, b, c, M_offset_3,  10, T[53]);
                    c = II(c, d, a, b, M_offset_10, 15, T[54]);
                    b = II(b, c, d, a, M_offset_1,  21, T[55]);
                    a = II(a, b, c, d, M_offset_8,  6,  T[56]);
                    d = II(d, a, b, c, M_offset_15, 10, T[57]);
                    c = II(c, d, a, b, M_offset_6,  15, T[58]);
                    b = II(b, c, d, a, M_offset_13, 21, T[59]);
                    a = II(a, b, c, d, M_offset_4,  6,  T[60]);
                    d = II(d, a, b, c, M_offset_11, 10, T[61]);
                    c = II(c, d, a, b, M_offset_2,  15, T[62]);
                    b = II(b, c, d, a, M_offset_9,  21, T[63]);

                    // Intermediate hash value
                    H[0] = (H[0] + a) | 0;
                    H[1] = (H[1] + b) | 0;
                    H[2] = (H[2] + c) | 0;
                    H[3] = (H[3] + d) | 0;
                },

                _doFinalize: function () {
                    // Shortcuts
                    /*jslint nomen: true*/
                    /*jslint bitwise: true */
                    var data = this._data;
                    var dataWords = data.words;

                    var nBitsTotal = this._nDataBytes * 8;
                    var nBitsLeft = data.sigBytes * 8;

                    // Add padding
                    dataWords[nBitsLeft >>> 5] |= 0x80 << (24 - nBitsLeft % 32);

                    var nBitsTotalH = Math.floor(nBitsTotal / 0x100000000);
                    var nBitsTotalL = nBitsTotal;

                    var hash, H, i, H_i;

                    dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 15] = (
                        (((nBitsTotalH << 8)  | (nBitsTotalH >>> 24)) & 0x00ff00ff) |
                        (((nBitsTotalH << 24) | (nBitsTotalH >>> 8))  & 0xff00ff00)
                    );
                    dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 14] = (
                        (((nBitsTotalL << 8)  | (nBitsTotalL >>> 24)) & 0x00ff00ff) |
                        (((nBitsTotalL << 24) | (nBitsTotalL >>> 8))  & 0xff00ff00)
                    );

                    data.sigBytes = (dataWords.length + 1) * 4;

                    // Hash final blocks
                    this._process();

                    // Shortcuts
                    hash = this._hash;
                    H = hash.words;

                    // Swap endian
                    for (i = 0; i < 4; i += 1) {
                        // Shortcut
                        H_i = H[i];

                        H[i] = (((H_i << 8)  | (H_i >>> 24)) & 0x00ff00ff) |
                               (((H_i << 24) | (H_i >>> 8))  & 0xff00ff00);
                    }

                    // Return final computed hash
                    return hash;
                },

                clone: function () {
                    var clone = Hasher.clone.call(this);
                    clone._hash = this._hash.clone();

                    return clone;
                }
            });
            var MD5 = C_algo.MD5;

            /**
             * Shortcut function to the hasher's object interface.
             *
             * @param {WordArray|string} message The message to hash.
             *
             * @return {WordArray} The hash.
             *
             * @static
             *
             * @example
             *
             *     var hash = CryptoJS.MD5('message');
             *     var hash = CryptoJS.MD5(wordArray);
             */
            C.MD5 = Hasher._createHelper(MD5);

            /**
             * Shortcut function to the HMAC's object interface.
             *
             * @param {WordArray|string} message The message to hash.
             * @param {WordArray|string} key The secret key.
             *
             * @return {WordArray} The HMAC.
             *
             * @static
             *
             * @example
             *
             *     var hmac = CryptoJS.HmacMD5(message, key);
             */
            C.HmacMD5 = Hasher._createHmacHelper(MD5);
        }(Math));
        /*jslint unparam: true */
        /*jslint nomen: false*/
        /*jslint bitwise: false */

        mailru.intercom = {
            chunkBuff: [],
            chunkLen: 0,
            chunkTimeout: null,
            chunkFinished: function () {
                return;
            },
            init: function (isConnect) {
                this.wrp = this[mailru.intercomType];
                this.wrp.init(isConnect);
            },

            /**
             * Intercom receiver
             * @param {String} params
             * @return {undefined}
             */
            receiver: function (params) {
                params = mailru.utils.parseGet(params);
                if (params.result) {
                    if (+params.rt) {
                        params.res_hash = mailru.utils.parseGet(params.result);
                    } else {
                        params.res_hash = mailru.utils.fromJSON(params.result);
                    }
                }
                params.res_hash = params.res_hash || {};
                if (params.res_hash.error && params.res_hash.error.error_code.toString() === '102' && mailru.session) {
                    mailru.events.notify(mailru.connect.events.logout);
                }
                if (params.event) {
                    mailru.events.notify(params.event, params.res_hash, params.result);
                } else if (params.cbid && mailru.callbacks[params.cbid]) {
                    if (params.chunk) {
                        if (!this.chunkBuff.length) {
                            this.chunkLen = params.len;
                            this.chunkFinished = (function (cbid) {
                                return function () {
                                    /*
                                    var i;
                                    for (i = 0; i < mailru.intercom.chunkLen; i += 1) {
                                        if (!mailru.intercom.chunkBuff[i]) {
                                            // debugger;
                                        }
                                    }
                                    */
                                    mailru.callbacks[cbid]({result: mailru.intercom.chunkBuff.join('')});
                                    mailru.intercom.chunkBuff = [];
                                    mailru.intercom.chunkLen = 0;
                                    mailru.intercom.chunkFinished = function () {
                                        return;
                                    };
                                };
                            }(params.cbid));
                        }

                        window.clearTimeout(this.chunkTimeout);
                        this.chunkTimeout = window.setTimeout(this.chunkFinished, 3000);

                        this.chunkBuff[+params.index] = params.res_hash.result;
                        this.chunkLen -= 1;
                        if (!this.chunkLen) {
                            window.clearTimeout(this.chunkTimeout);
                            this.chunkFinished();
                        }
                    } else {
                        mailru.callbacks[params.cbid](params.res_hash, params.result);
                    }
                }
            },

            /**
             * @private
             */
            makeRequest: function (method, params, callback) {
                params = params || {};
                params.method = method;
                params.resource = 'app';
                if (callback) {
                    params.cbid = mailru.callbacks.add(callback);
                }
                return params;
            },

            /**
             * Intercom wrapper interface
             */
            wrp: {
                init: function () {
                    return;
                },

                /**
                 * request
                 * @param {String} method                            Mail.ru API method name
                 * @param {Hash} params (optional)                    Arguments
                 * @param {Function} callback (optional)            Accept result
                 * @return {undefined}
                 */
                request: function (method, params, callback) {
                    return;
                }
            },

            /**
             * Wrappers implementation
             */
            hash: {
                init: function () {
                    return;
                },
                request: function (method, params, callback) {
                    params = mailru.intercom.makeRequest(method, params, callback);

                    mailru.utils.requestOverProxy(params, mailru.def.PROXY_URL);
                }
            },
            event: {
                init: function () {
                    mailru.utils.addHandler(window, 'message', function (ev) {
                        mailru.intercom.receiver(ev.data);
                    });
                },
                request: function (method, params, callback) {
                    params = mailru.intercom.makeRequest(method, params, callback);

                    //if this is IE and we're about to init a GET request, text should be stripped here so that it fits into IE's url length restriction
                    if (mailru.isIE && params.method === 'showStreamPublish' && mailru.utils.makeGet(params).length > 2500) {
                        // just cut the description and title?
                        if (params.posttitle.length > 80) {
                            params.posttitle = params.posttitle.substring(0, 80) + '...';
                        }
                        if (params.apptext.length > 200) {
                            params.apptext = params.apptext.substring(0, 200) + '...';
                        }
                    }
                    parent.postMessage(mailru.utils.makeGet(params), '*');
                }
            },
            flash: {
                transport: '',
                params: {},
                toSend: [],
                flashReady: false,
                insertFlash: function () {
                    var emptyStr = '';
                    mailru.intercom.flash.transport = document.createElement('div');
                    document.body.insertBefore(mailru.intercom.flash.transport, document.body.getElementsByTagName('*')[0]);
                    mailru.intercom.flash.transport.id = 'flash-transport-container';
                    mailru.intercom.flash.transport.innerHTML = emptyStr +
                            '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="//download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab" id="api-lcwrapper" name="api-lcwrapper" height="1" width="1" type="application/x-shockwave-flash">' +
                            '<param value="always" name="allowScriptAccess"/>' +
                            '<param value="' + mailru.def.FLASH_TRANSPORT_URL + '" name="movie"/>' +
                            '<param value="' + mailru.intercom.flash.vars + '" name="FlashVars"/>' +
                            '</object>';
                },
                init: function (isConnect) {
                    if (document.URL.match(/\?(.*)/)) {
                        mailru.intercom.flash.params.fcid = mailru.utils.parseGet(document.URL.match(/\?(.*)/)[0]).fcid;
                    }

                    if (!mailru.intercom.flash.params.fcid || mailru.intercom.flash.params.fcid === undefined) {
                        mailru.intercom.flash.params.fcid = mailru.utils.parseGet(window.name).fcid;
                    }

                    if (!mailru.intercom.flash.params.fcid || mailru.intercom.flash.params.fcid === undefined) {
                        mailru.intercom.flash.params.fcid = mailru.utils.uniqid();
                    }

                    mailru.intercom.flash.vars = mailru.utils.makeGet({
                        CBReceive: 'mailru.intercom.flash.receive',
                        CBReady: 'mailru.intercom.flash.ready',
                        listenTo: 'api',
                        connectTo: 'server',
                        cid: mailru.intercom.flash.params.fcid,
                        host: mailru.def.DOMAIN,
                        role: 'server',
                        noOpposite: isConnect ? 1 : 0
                    });

                    mailru.intercom.flash.insertFlash();

                },
                request: function (method, params, callback) {
                    var t, i;
                    params = mailru.utils.makeGet(mailru.intercom.makeRequest(method, params, callback));
                    t = document.getElementById('api-lcwrapper');
                    if (t && t.send) {
                        t.send(params);
                    } else {
                        mailru.intercom.flash.toSend.push(params);
                        mailru.events.listen(mailru.common.events.transportReady, function () {
                            for (i = mailru.intercom.flash.toSend.length - 1; i >= 0; i -= 1) {
                                document.getElementById('api-lcwrapper').send(mailru.intercom.flash.toSend[i]);
                            }
                        });
                    }
                    t = null;
                },
                receive: function (params) {
                    mailru.intercom.receiver(params);
                },
                ready: function () {
                    if (navigator.appName.indexOf("Microsoft") !== -1) {
                        mailru.intercom.flash.transport = window['api-lcwrapper'];
                    } else {
                        mailru.intercom.flash.transport = document['api-lcwrapper'];
                    }

                    mailru.intercom.flash.flashReady = true;
                    mailru.events.notify(mailru.common.events.transportReady);
                }
            }
        };
        mailru.callbacks = {
            add: function (callback) {
                var cbid = mailru.utils.uniqid();

                mailru.callbacks[cbid] = function () {
                    delete mailru.callbacks[cbid];

                    if (callback) {
                        callback.apply(window, arguments);
                    }
                };
                return cbid;
            }
        };
        mailru.events = {
            listeners: {},
            hidHash: {},
            listen: function (event, callback) {
                var index, hid;
                event = mailru.events.alias[event] || event;
                this.listeners[event] = this.listeners[event] || {
                    index: -1,
                    list: {}
                };
                this.listeners[event].index += 1;
                index = this.listeners[event].index;
                this.listeners[event].list[index] = callback;
                hid = mailru.utils.uniqid();
                this.hidHash[hid] = [event, index];
                return hid;
            },
            remove: function (hid) {
                if (this.hidHash[hid]) {
                    delete this.listeners[this.hidHash[hid][0]].list[this.hidHash[hid][1]];
                }
            },
            notify: function (event) {
                var args;
                if (event !== 'event') {
                    args = mailru.utils.toArray(arguments);
                    args.unshift('event');
                    this.notify.apply(this, args);
                }
                args = mailru.utils.toArray(arguments).splice(1, arguments.length);
                if (this.listeners[event] && this.listeners[event].index !== -1) {
                    mailru.utils.foreach(this.listeners[event].list, function (cb) {
                        cb.apply(window, args);
                    });
                }
            },
            alias : {
                'stream.post' : 'common.streamPublish',
                'mailru.common.events.streamPublish' : 'common.streamPublish',
                'message.post' : 'common.sendMessage',
                'guestbook.post' : 'common.guestbookPublish',
                'mailru.common.events.guestbookPublish' : 'common.guestbookPublish',

                'common.upload' : mailru.isApp ? 'common.upload' : 'common.uploadPhoto',
                'mailru.common.events.upload' : 'common.upload',
                'mailru.common.events.uploadAvatar' : 'common.uploadAvatar',

                'mailru.app.events.friendsInvitation' : 'common.friendsInvitation',
                'mailru.app.events.friendsRequest' : 'common.friendsRequest',
                'mailru.common.events.createAlbum' : 'common.createAlbum',
                'mailru.common.events.friends.add' : 'common.friends.add',
                'mailru.common.events.gift.send' : 'common.gift.send',
                'mailru.app.events.incomingPayment' : 'app.incomingPayment',
                'mailru.app.events.paymentDialogStatus' : 'app.paymentDialogStatus',
                'mailru.app.events.hash.read' : 'app.hash.read',
                'mailru.app.events.scrollTo' : 'app.scrollY'
            }
        };
        mailru.common = {
            email: {
                getUnreadCount: function (callback) {
                    mailru.batcher.reqest('email.getUnreadCount', {
                        uid: mailru.session.vid || ''
                    }, callback);
                }
            },
            messages: {
                getUnreadCount: function (callback) {
                    mailru.batcher.reqest('messages.getUnreadCount', {}, callback);
                },
                getThreadsList: function (callback, params) {
                    params = params || {};
                    mailru.batcher.reqest('messages.getThreadsList', {
                        offset: params.offset || 0,
                        limit: params.limit || 10
                    }, callback);
                },
                getThread: function (callback, uid, params) {
                    params = params || {};
                    mailru.batcher.reqest('messages.getThread', {
                        uid: uid || mailru.session.vid || '',
                        offset: params.offset || 0,
                        limit: params.limit || 10
                    }, callback);
                },
                send: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    if (!params.uid) {
                        throw new Error('No recipient UID');
                    }
                    if (mailru.isApp) {
                        params.session_key = mailru.session.session_key;
                        params.appid = mailru.app_id;
                        mailru.intercom.wrp.request('showSendMessageDialog', prepareOptions(params));
                    } else {
                        mailru.utils.modal.open(getDialogUrl('send_message'), {
                            url: params,
                            type: 'modal'
                        });
                    }
                }
            },
            users: {
                requirePermissions: function (permission, secondParam) {
                    if (typeof permission === 'function') {
                        permission = secondParam;
                    }
                    mailru.common.users.requirePermission(permission);
                },
                requirePermission: function (permission, secondParam) {
                    if (typeof permission === 'function') {
                        permission = secondParam;
                    }
                    mailru.events.notify(mailru.common.events.permissionsChange, {status: 'closed'});
                },
                getInfo: function (callback, uids) {
                    if (typeof uids === 'string' || typeof uids === 'number') {
                        if (arguments.length > 2) {
                            uids = arguments.splice(3, arguments.length);
                        } else {
                            uids = [uids];
                        }
                    }
                    if (uids === undefined || uids.length === 0) {
                        uids = [mailru.session.vid];
                    }
                    mailru.batcher.reqest('users.getInfo', {
                        uids: uids.join(',')
                    }, callback);
                },
                getPermissions: function () {
                    return;
                },
                hasAppPermission: function (callback, ext_perm, uid) {
                    mailru.batcher.reqest('users.hasAppPermission', {
                        uid: uid || mailru.session.vid || '',
                        ext_perm: ext_perm
                    }, callback);
                },
                getBalance: function (callback, uid) {
                    mailru.batcher.reqest('users.getBalance', {
                        uid: uid || mailru.session.vid
                    }, callback);
                }
            },
            stream: {
                publish: function (params, secondParam) {
                    var tmpParams, i;
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    tmpParams = {posttitle: (params.title || ''), apptext: (params.text || ''), pic: (params.img_url || (params.imgURL || ''))};
                    tmpParams.id = 'stream-publish';

                    params.action_links = params.action_links || (params.actionLinks || false);
                    if (params.action_links) {
                        for (i = 1; i <= params.action_links.length; i += 1) {
                            tmpParams['link_' + i + '_text'] = params.action_links[i - 1].text;
                            tmpParams['link_' + i + '_href'] = params.action_links[i - 1].href;
                        }
                    }
                    if (mailru.isApp) {
                        tmpParams.session_key = mailru.session.session_key;
                        tmpParams.appid = mailru.app_id;
                        mailru.intercom.wrp.request('showStreamPublish', prepareOptions(tmpParams));
                    } else {
                        tmpParams.url = tmpParams;
                        tmpParams.type = 'modal';
                        mailru.utils.modal.open(getDialogUrl('stream_publish'), tmpParams);
                    }
                },
                post: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    mailru.common.stream.publish(params);
                },
                get: function (callback, params) {
                    params = params || {};
                    mailru.batcher.reqest('stream.get', {
                        offset: params.offset || 0,
                        limit: params.limit || 10,
                        filter_app: params.filter_app || ''
                    }, callback);
                },
                getByAuthor: function (callback, uid, params) {
                    params = params || {};
                    mailru.batcher.reqest('stream.getByAuthor', {
                        uid: uid || mailru.session.vid,
                        offset: params.offset || 0,
                        limit: params.limit || 10,
                        filter_app: params.filter_app || ''
                    }, callback);
                }
            },
            guestbook: {
                publish: function (params, secondParam) {
                    var tmpParams, i;
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    if (params.uid === undefined) {
                        params.uid = mailru.session.vid;
                    }
                    tmpParams = {url: {uid: params.uid.toString(), title: (params.title || ''), text: (params.text || ''), img: (params.img_url || (params.imgURL || ''))}, type: 'modal'};
                    tmpParams.id = 'guestbook-publish';

                    params.action_links = params.action_links || (params.actionLinks || false);
                    if (params.action_links) {
                        for (i = 1; i <= params.action_links.length; i += 1) {
                            try {
                                tmpParams.url['link_' + i + '_text'] = params.action_links[i - 1].text;
                                tmpParams.url['link_' + i + '_href'] = params.action_links[i - 1].href;
                            } catch (ignore) {
                            }
                        }
                    }
                    if (mailru.isApp) {
                        mailru.intercom.wrp.request('showGuestbookPublish', prepareOptions({
                            app_id: mailru.app_id,
                            text: tmpParams.url.text,
                            title: tmpParams.url.title,
                            img: tmpParams.url.img,
                            uid: tmpParams.url.uid,
                            link_1_text: tmpParams.url.link_1_text || '',
                            link_1_href: tmpParams.url.link_1_href || '',
                            link_2_text: tmpParams.url.link_2_text || '',
                            link_2_href: tmpParams.url.link_2_href || '',
                            session_key: mailru.session.session_key
                        }));
                    } else {
                        mailru.utils.modal.open(getDialogUrl('publish_guestbook'), tmpParams);
                    }
                },
                post: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    params.text = params.text || params.description;
                    if (params.description) {
                        delete params.description;
                    }
                    mailru.common.guestbook.publish(params);
                },
                get: function (callback, uid, params) {
                    params = params || {};
                    mailru.batcher.reqest('guestbook.get', {
                        uid: uid || mailru.session.vid || '',
                        offset: params.offset || 0,
                        limit: params.limit || 10
                    }, callback);
                }
            },
            photos: {
                getAlbums: function (callback, uid) {
                    mailru.batcher.reqest('photos.getAlbums', {
                        uid: uid || mailru.session.vid || ''
                    }, callback);
                },
                get: function (callback, aid, pids, offset, limit) {
                    mailru.batcher.reqest('photos.get', {
                        pids: pids || '',
                        aid: aid,
                        offset: offset || 0,
                        limit: limit || 0
                    }, callback);
                },
                createAlbum: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    if (params === undefined) {
                        params = {};
                    }
                    if (params.name === undefined) {
                        params.name = 'Без названия';
                    }
                    params.toSend = {url: {album_name: params.name}, type: 'modal'};
                    params = params.toSend;
                    params.id = "create-album";
                    if (mailru.isApp) {
                        mailru.intercom.wrp.request('showAlbumCreation', prepareOptions({
                            app_id: mailru.app_id,
                            album_name: params.url.album_name,
                            session_key: mailru.session.session_key
                        }));
                    } else {
                        mailru.utils.modal.open(getDialogUrl('create_album'), params);
                    }
                },
                upload: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }

                    params.img = params.img || params.url;
                    params.toSend = {url: {img: params.img, aid: params.aid, set_as_cover : params.set_as_cover || false, title: params.title || params.name || '', desc: params.description || params.desc || '', category: params.theme || params.category || '', tags: params.tags || ''}, type: 'modal'};
                    params = params.toSend;
                    params.id = "upload-photo";

                    if (mailru.isApp) {
                        mailru.intercom.wrp.request('showPhotoUpload', prepareOptions({
                            app_id: mailru.app_id,
                            img: params.url.img,
                            aid: params.url.aid,
                            title: params.url.title || '',
                            desc: params.url.desc || '',
                            category: params.url.category || '',
                            tags: params.url.tags || '',
                            set_as_cover: params.url.set_as_cover || '',
                            session_key: mailru.session.session_key
                        }));
                    } else {
                        mailru.utils.modal.open(getDialogUrl('upload_photo'), params);
                    }
                },
                uploadAvatar: function (params, secondParam) {

                    var options = {
                        app_id: mailru.app_id,
                        session_key: mailru.session.session_key
                    };

                    if (typeof params === 'function') {
                        params = secondParam;
                    }

                    if (params.url !== undefined) {
                        options.img_url = params.url;
                    } else {
                        options.pid = params.pid;
                    }

                    if (mailru.isApp) {
                        mailru.intercom.wrp.request('showSetAvatar', prepareOptions(options));
                    } else {
                        mailru.utils.modal.open(getDialogUrl('avatar_set'), {type: 'modal', url: options});
                    }
                }
            },
            audio: {
                search: function (callback, query, offset, limit) {
                    if (query === undefined) {
                        throw new Error('audio search failed:\nno QUERY');
                    }
                    mailru.batcher.reqest('audio.search', {
                        query: query,
                        offset: offset || 0,
                        limit: limit || 10
                    }, callback);
                },
                link: function (callback, mid) {
                    if (mid === undefined) {
                        throw new Error('get audio link failed:\nno MID');
                    }
                    mailru.batcher.reqest('audio.link', {
                        mid: mid
                    }, callback);
                },
                get: function (callback, uid, mid) {
                    mailru.batcher.reqest('audio.get', {
                        uid: uid || mailru.session.vid || '',
                        mid: mid || ''
                    }, callback);
                }
            },
            friends: {
                add: function (uid, secondParam) {
                    var params, session;
                    if (typeof uid === 'function') {
                        uid = secondParam;
                    }
                    params = {url: {uid: uid}, type: 'modal'};
                    if (!mailru.session) {
                        session = mailru.utils.parseGet(mailru.utils.getCookie(mailru.def.CONNECT_COOKIE));
                        params.session_key = session.session_key;
                    }
                    if (mailru.isApp) {
                        mailru.intercom.wrp.request('showAddFriend', prepareOptions({
                            app_id: mailru.app_id,
                            uid: uid,
                            session_key: mailru.session.session_key
                        }));
                    } else {
                        mailru.utils.modal.open(getDialogUrl('add_friend'), params);
                    }
                },
                getFiltered: function (callback, uid, offset) {
                    mailru.batcher.reqest('friends.get', {
                        uid: uid || mailru.session.vid || '',
                        offset: offset || 0
                    }, callback);
                },
                getExtended: function (callback, uid, offset) {
                    mailru.batcher.reqest('friends.get', {
                        uid2: uid || mailru.session.vid || '',
                        ext: 1,
                        offset: offset || 0
                    }, callback);
                },
                getAppUsers: function (callback, ext, uid, offset) {
                    mailru.batcher.reqest('friends.getAppUsers', {
                        uid: uid || mailru.session.vid || '',
                        ext: ext ? 1 : 0,
                        offset: offset || 0
                    }, callback);
                },
                getInvitationsCount: function (callback) {
                    mailru.batcher.reqest('friends.getInvitationsCount', {
                        uid: mailru.session.vid || ''
                    }, callback);
                }
            },
            payments: {
                showDialog: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    params.app_id = mailru.app_id;

                    if (mailru.isApp) {
                        mailru.intercom.wrp.request('showPaymentDialog', prepareOptions(params));
                    } else {
                        params.window_id = mailru.window_id;
                        params.mailiki_price *= 100;
                        params.url  = params;
                        params.session_key = mailru.session.session_key;
                        params.type = 'modal';
                        params.style = {
                            width: '675px'
                        };
                        if (!mailru.session) {
                            throw new Error('No user session');
                        }

                        mailru.connect.activePaymentWindow = mailru.utils.modal.open(getDialogUrl('payment_dialog'), params);
                    }
                }
            },
            gift : {
                send : function (gift_id, text, friend_id) {
                    if (gift_id === undefined) {
                        throw new Error('No gift id');
                    }

                    // if not array to array
                    if (Object.prototype.toString.call(friend_id) !== "[object Array]") {
                        friend_id = [friend_id];
                    }

                    var params = {};
                    params.app_id = mailru.app_id;

                    if (mailru.isApp) {
                        params.gift_id = gift_id;
                        params.text = text || '';
                        params.friend_id = friend_id.join(',');
                        mailru.intercom.wrp.request('showGiftSendDialog', prepareOptions(params));
                    } else {

                        params.url = {
                            "interface" : 'gift.send',
                            "gift_id"   : gift_id,
                            "text"        : text || '',
                            "friend_id" : friend_id.join(',')
                        };

                        params.type = 'modal';
                        params.style = {
                            width: '675px'
                        };

                        mailru.utils.modal.open(getDialogUrl('friends_select'), params);
                    }

                    // params.window_id = mailru.window_id;


                }
            },
            events: {
                permissionChanged: 'common.permissionChanged',
                permissionsChange: 'common.permissionChanged',
                friendsInvitation: 'common.friendsInvitation',
                message: {
                    send: 'common.sendMessage'
                },
                streamPublish: 'common.streamPublish',
                modalWindow: 'common.modalWindow',
                requireWidgetPermissions: 'common.requireWidgetPermissions',
                createAlbum: 'common.createAlbum',
                upload: 'common.upload',
                uploadAvatar: 'common.uploadAvatar',
                guestbookPublish: 'common.guestbookPublish',
                transportReady: 'common.transportReady',
                friends: {
                    add: 'common.friends.add'
                },
                gift : {
                    send: 'common.gift.send'
                },
                paymentDialogStatus: 'common.paymentDialogStatus'
            }
        };
        mailru.app = {
            init: function (private_key) {
                var session, sessionstr;
                mailru.isApp = true;

                if (!mailru.inited) {
                    api_init();
                }
                if (private_key) {
                    mailru.private_key = private_key;
                }
                sessionstr = (document.URL.match(/\?(.*)/) || [0, ''])[1];
                session = mailru.utils.parseGet(sessionstr);

                if (!session.app_id || !session.session_key) {
                    sessionstr = mailru.utils.getCookie(mailru.def.CONNECT_COOKIE) || '';
                    if (sessionstr === '') {
                        sessionstr = mailru.utils.parseGet(window.name).cookie;
                    }
                    session = mailru.utils.parseGet(sessionstr);
                }
                if (!session.app_id) {
                    throw new Error('API INIT FAILED:\nno APP ID');
                }
                if (!session.session_key) {
                    throw new Error('API INIT FAILED:\nno No SESSION KEY');
                }
                mailru.app_id = session.app_id;
                mailru.app.dispatchSession(session, sessionstr);
                mailru.utils.extend(mailru.app, mailru.common);
            },
            users: {
                requireInstallation: function (params) {
                    mailru.events.notify(mailru.app.events.applicationInstallation, {status: 'success'});
                },
                isAppUser: function (callback, uid) {
                    mailru.batcher.reqest('users.isAppUser', {
                        uid: uid || mailru.session.vid || ''
                    }, callback);
                },
                review: function () {
                    mailru.intercom.wrp.request('showReviewDialog', {app_id: mailru.app_id});
                },
                events: {
                    getNewCount: function (callback, uid) {
                        mailru.batcher.reqest('events.getNewCount', {
                            uid: uid || mailru.session.vid || ''
                        }, callback);
                    }
                }
            },
            widget: {
                set: function () {
                    mailru.events.notify(mailru.app.events.widget.set, {status: 'closed'});
                    return false;
                }
            },
            friends: {
                invite: function () {
                    var params = {
                            app_id: mailru.app_id,
                            method: "jsapi.popup",
                            session_key: mailru.session.session_key,
                            vid: mailru.session.vid,
                            template: "friends.invite"
                        },
                        env = getEnv();

                    /*jslint nomen: true */
                    if (env.branch !== "") {
                        params.__branch = env.branch;
                    }
                    /*jslint nomen: false */
                    mailru.intercom.wrp.request('showInviteFriendsDialog', mailru.utils.sign(params));
                },
                request: function (params, secondParam) {
                    params = params || {};
                    if (typeof params === 'function') {
                        params = secondParam || {};
                    }
                    if (!params.text || !params.image_url) {
                        throw new Error('Missing required params: ' + (params.text ? '' : 'text\n') + (params.image_url ? '' : 'image_url\n'));
                    }
                    if (params.friends instanceof Array) {
                        params.friends = params.friends.join(',');
                    }
                    mailru.intercom.wrp.request('showRequestFriendsDialog', {
                        app_id: mailru.app_id,
                        text: params.text,
                        image_url: params.image_url,
                        friends: params.friends || false,
                        hash: params.hash || false
                    });
//                    var data,
//                        env = mailru.loader._moduleEnv || { 'branch': '', 'isHttps': false, 'localHttps': false};
//
//                    if (typeof params == 'function') {
//                        params = arguments[1] || {};
//                    }
//
//                    if (params.text && params.image_url) {
//
//                        if (params.text.length > 100) {
//                            params.text = params.text.slice(0, 100);
//                        }
//
//                        if (params.image_url.length > 200) {
//                            params.image_url = "";
//                        }
//
//                    } else {
//                        throw new Error('Missing required params: ' + (params.text ? '' : 'text\n') + (params.image_url ? '' : 'image_url\n'));
//                        return false;
//                    }
//
//                    if (params.hash && params.hash.length > 16) {
//                        params.hash = "";
//                    }
//
//                    data = {
//                        app_id: mailru.app_id,
//                        method: "jsapi.popup",
//                        session_key: mailru.session.session_key,
//                        vid: mailru.session.vid,
//                        template: "friends.request",
//                        hash: params.hash,
//                        image_url: params.image_url,
//                        text: params.text
//                    };
//
//                    if (env.branch !== "") {
//                        data.__branch = env.branch;
//                    }
//
//                    mailru.intercom.wrp.request('showRequestFriendsDialog', mailru.utils.sign(data));
                }
            },
            payments: {
                showDialog: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    mailru.common.payments.showDialog.call(mailru, params);
                },
                openDialog: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    mailru.common.payments.showDialog.call(mailru, params);
                }
            },

            setLocation: function () {
                return;
            },
            getLocation: function () {
                return;
            },
            resizeWindow: function () {
                return;
            },
            scrollWindow: function () {
                return;
            },
            setTitle: function (params, secondParam) {
                if (typeof params === 'function') {
                    params = secondParam;
                }
                mailru.app.utils.setTitle(params);
            },
            utils: {
                getScrollY: function (params) {
                    "use strict";
                    mailru.intercom.wrp.request('scrollTo');
                },
                setScrollY: function (params, secondParam) {
                    "use strict";
                    if (typeof params === 'function') {
                        params.scroll = secondParam;
                    } else if (window.scroll !== undefined) {
                        params.scroll = window.scroll;
                    }
                    mailru.intercom.wrp.request('scrollTo', params);
                },
                setTitle: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    if (params !== null && params !== 'undefined') {
                        mailru.intercom.wrp.request('setTitle', {app_id: mailru.app_id, title:  params});
                    }
                },
                setHeight: function (params, secondParam) {
                    if (typeof params === 'function') {
                        params = secondParam;
                    }
                    if (params) {
                        mailru.intercom.wrp.request('setIframeHeight', {app_id: mailru.app_id, height:  params});
                    }
                },
                hash: {
                    write: function (params, secondParam) {
                        if (typeof params === 'function') {
                            params = secondParam;
                        }
                        if (params === undefined) {
                            return false;
                        }
                        mailru.intercom.wrp.request('writeHash', {hash: params});
                    },
                    read: function () {
                        var wn = mailru.utils.parseGet(window.name),
                            h = decodeURIComponent(wn.fast_hash);
                        if (h !== "undefined") {
                            mailru.app.utils.hash.fastHash = h;
                            delete wn.fast_hash;
                            window.name = mailru.utils.makeGet(wn);
                            mailru.app.utils.hash.initRead();
                        } else {
                            mailru.app.utils.hash.initRead();
                            mailru.intercom.wrp.request('readHash');
                        }
                    },
                    initRead: function () {
                        function processHash(d) {
                            var hash = '';
                            if (typeof d === 'string') {
                                hash = d;
                            } else {
                                hash = d.hash;
                            }

                            hash = mailru.utils.parseGet(hash);
                            mailru.events.notify('app.hash.read', hash);
                            mailru.events.notify('app.readHash', hash);
                        }

                        if (mailru.app.utils.hash.inited && !mailru.app.utils.hash.fastHash) {
                            return false;
                        }

                        if (mailru.app.utils.hash.fastHash) {
                            processHash(mailru.app.utils.hash.fastHash);
                            mailru.app.utils.hash.fastHash = false;
                        }
                        mailru.events.listen(mailru.app.events.appReadHash, function (d) {
                            processHash(d);
                        });
                        mailru.app.utils.hash.inited = true;

                    },
                    inited: false,
                    fastHash: false
                },
                scrollTo: function (scroll, secondParam) {
                    var params = {};

                    if (typeof scroll === 'function') {
                        params.scroll = secondParam;
                    } else if (scroll !== undefined) {
                        params.scroll = scroll;
                    }

                    mailru.intercom.wrp.request('scrollTo', params);
                }
            },
            /**
             * Application events namespace
             */
            events: {
                windowBlur: 'app.windowBlur',
                windowFocus: 'app.windowFocus',
                locationChange: 'app.locationChange',
                windowResize: 'app.windowResize',
                applicationInstallation: 'app.applicationInstallation',
                friendsInvitation: 'app.friendsInvitation',
                friendsRequest: 'app.friendsRequest',
                applicationSettingsStatus: 'app.settings',
                applicationReviewStatus: 'app.review',
                incomingPayment: 'app.incomingPayment',
                requireInstallation: 'app.requireInstallation',
                appReadHash: 'app.appReadHash',
                readHash: 'app.readHash',
                scrollTo: 'app.scrollTo',
                hash: {
                    read : 'app.hash.read'
                },
                like: 'app.like',
                widget: {
                    set: 'app.widget.set'
                },
                paymentDialogStatus: 'app.paymentDialogStatus'
            },

            getLoginStatus: function (callback) {
                mailru.utils.requestOverProxy({
                    resource: 'getLoginStatus',
                    app_id: mailru.app_id,
                    cbid: mailru.callbacks.add(function (session, sessionstr) {
                        mailru.app.dispatchSession(session, sessionstr);
                        if (callback) {
                            callback(session, sessionstr);
                        }
                    })
                });
            },

            /**
             * @private
             */
            dispatchSession: function (session, sessionstr) {
                if (!session.session_expire && session.exp) {
                    session.session_expire = session.exp;
                }

                if (!session.session_expire) {
                    session.session_expire = mailru.def.SESSION_REFRESH_EVERY;
                }

                mailru.session = session;
                mailru.app.prolongSession(session);
                var c = mailru.utils.parseGet(window.name);
                c.cookie = sessionstr;
                window.name = mailru.utils.makeGet(c);
                mailru.utils.setCookie({
                    name: mailru.def.CONNECT_COOKIE,
                    value: sessionstr
                });

            },

            /**
             * @private
             */
            clearSession: function () {
                mailru.session = false;
                window.clearTimeout(mailru.app.prolongSessionTmr);
            },
            /**
             * @private
             */
            prolongSessionTmr: null,

            /**
             * @private
             */
            prolongSession: function (session) {
                window.clearTimeout(mailru.app.prolongSessionTmr);
                mailru.app.prolongSessionTmr = window.setTimeout(function () {
                    mailru.app.getLoginStatus();
                }, mailru.def.SESSION_REFRESH_EVERY);
            }
        };
        mailru.connect = {
            /**
             * optimistically requests app.auto_install from proxy, doesn’t do anything with the result
             * @param  {string} app_id application id
             * @param  {function} callback the callback that will be called with session/sessionstr upon recieval
             */
            appAutoInstall: function (app_id, callback, session, sessionstr) {
                mailru.utils.requestOverProxy({
                    resource: 'app.auto_install',
                    app_id: app_id,
                    cbid: mailru.callbacks.add(function (data) {
                        // data[2] is an object with a list of fields similar to what getLoginStatus responds with
                        if (data.length > 1 && typeof data[2] !== 'string' && data[2].success !== undefined) {

                            // 0. get session information from the response and update current session object
                            session = {
                                app_id: session.app_id,
                                exp: data[2].exp,
                                ext_perm: 'notifications',
                                is_app_user: 1,
                                oid: data[2].vid,
                                session_key: data[2].session_key,
                                ss: data[2].ss,
                                state: '',
                                vid: data[2].vid,
                                sig: data[2].sig,
                                window_id: session.window_id
                            };

                            // then serialize
                            sessionstr = mailru.utils.makeGet(session);

                            // 1. persist new session information in the cookies
                            mailru.connect.dispatchSession(session, sessionstr);

                            // 2. passed in callback is called with the resulting session / sessionstr params
                            if (typeof callback === 'function') {
                                callback(session, sessionstr);
                            }

                        } else { // if required data was not obtained from autoInstall, just call the callback with current session/sessionstr data
                            if (typeof callback === 'function') {
                                callback(session, sessionstr);
                            }
                        }
                    })
                });
            },

            init: function (app_id, private_key, isGame) {
                if (!app_id) {
                    throw new Error('API INIT FAILED:\nno APP ID');
                }
                if (!private_key) {
                    throw new Error('API INIT FAILED:\nno PRIVATE KEY');
                }
                mailru.isGame = isGame || false;
                if (app_id) {
                    mailru.app_id = app_id;
                }
                mailru.partner_id = mailru.utils.getCookie(mailru.def.PARTNER_ID_COOKIE);
                if (!mailru.inited) {
                    api_init(1);
                }
                mailru.utils.extend(mailru.connect, mailru.common);
                if (private_key) {
                    mailru.private_key = private_key;
                }

                mailru.events.listen(mailru.connect.events.loginOAuth, mailru.connect.dispatchSession);
                mailru.events.listen(mailru.connect.events.logout, mailru.connect.clearSession);
                mailru.events.listen(mailru.connect.events.loginFail, mailru.connect.loginFail);

                //now call it anyways, it will call appAutoInstall if needed
                mailru.connect.getLoginStatus();

                function closeDialog(d) {
                    if (d !== undefined && d.wid && d.wid !== 'undefined' && d.wid !== 'opened') {
                        mailru.utils.modal.close(d.wid);
                    }
                }
                function closeDialog2(d) {
                    if (d !== undefined && d.wid && d.wid !== 'undefined' && d.status !== 'opened') {
                        mailru.utils.modal.close(d.wid);
                    }
                }
                mailru.events.listen(mailru.common.events.streamPublish, closeDialog);
                mailru.events.listen(mailru.common.events.guestbookPublish, closeDialog);
                mailru.events.listen(mailru.common.events.friends.add, closeDialog);
                mailru.events.listen(mailru.common.events.upload, closeDialog);
                mailru.events.listen(mailru.common.events.uploadAvatar, closeDialog);
                mailru.events.listen(mailru.common.events.permissionChanged, closeDialog);
                mailru.events.listen(mailru.common.events.createAlbum, closeDialog);
                mailru.events.listen(mailru.common.events.message.send, closeDialog);
                mailru.events.listen(mailru.common.events.paymentDialogStatus, closeDialog2);
                mailru.events.listen(mailru.common.events.gift.send, closeDialog2);
                mailru.events.listen(mailru.app.events.incomingPayment, function () {
                    setTimeout(function () {
                        mailru.utils.modal.close(mailru.connect.activePaymentWindow);
                    }, 3000);
                });
            },
            initButton: function () {
                function showLogin(e) {
                    mailru.connect.login();
                    return false;
                }
                var a = document.getElementsByTagName('a'), al = a.length, ai = 0, ca = null;
                for (0; ai < al; ai += 1) {
                    if (a[ai].className.indexOf('mrc__connectButton') !== -1) {
                        ca = a[ai];
                        ca.innerHTML = '';
                        ca.style.background = 'url(' + mailru.def.CONNECT_BUTTON_BG_URL + ') no-repeat';
                        ca.style.display = 'inline-block';
                        ca.style.width = '115px';
                        ca.style.height = '18px';
                        ca.href = '#r';
                        ca.onclick = showLogin;
                    }
                }
            },
            /**
             * Show Mail.ru Connect dialog. Fires mailru.connect.events.login event on success, pass session details
             * @return {undefined}
             */
            login: function (scope) {
                var popupParams, url, w;
                if (mailru.session && mailru.session.is_app_user) {
                    mailru.events.notify(mailru.connect.events.login, mailru.session, mailru.utils.getCookie(mailru.def.CONNECT_COOKIE));
                } else {
                    popupParams = {
                        app_id: mailru.app_id,
                        host: 'http://' + mailru.def.DOMAIN
                    };
                    if (mailru.intercomType === 'flash') {
                        popupParams.fcid = mailru.intercom.flash.params.fcid;
                    }

                    scope = scope || '';
                    try {
                        scope = scope.join().match(/\w*/g).join(' ');
                    } catch (e) {
                        scope = scope.match(/\w*/g).join(' ');
                    }

                    url = mailru.def.CONNECT_OAUTH + 'client_id=' + mailru.app_id + '&response_type=token&display=popup&redirect_uri=' + encodeURIComponent(mailru.def.PROXY_URL + 'app_id=' + mailru.app_id + '&login=1' + (popupParams.fcid ? '&fcid=' + popupParams.fcid : '') + (popupParams.host ? '&host=' + popupParams.host : '')) + '&' + mailru.utils.makeGet(popupParams) + '&' + mailru.utils.makeGet({scope: scope}) + (mailru.partner_id ? '&site_id=' + encodeURIComponent(mailru.partner_id) : '') + (mailru.isGame ? '&game=1' : '');

                    w = window.open(url, 'mrc_login', 'width=445, height=400, status=0, scrollbars=0, menubar=0, toolbar=0, resizable=1');
                    if (mailru.isOpera) {
                        window.onfocus = function () {
                            if (!mailru.session.login) {
                                window.onfocus = null;
                                mailru.events.notify(mailru.connect.events.loginFail);
                            }
                        };
                    } else {
                        //note that working popup blocker in mozilla/IE can be detected by checking for null
                        if (w !== undefined && w !== null) {
                            var tmr = setInterval(function () {
                                if (w.closed) {
                                    clearInterval(tmr);
                                }
                            }, 500);
                        } else {
                            if (!mailru.session.login) {
                                mailru.events.notify(mailru.connect.events.loginFail);
                            }
                        }
                    }
                }
            },

            /**
             * User logout. Fires mailru.connect.events.logout event on success
             * @return {undefined}
             */
            logout: function () {
                mailru.utils.apiOverJSONP(mailru.utils.sign({
                    cb: 'mailru.callbacks[' + mailru.callbacks.add(function (data) {
                        if (data.result) {
                            mailru.events.notify(mailru.connect.events.logout);
                        }
                    }) + ']',
                    app_id: mailru.app_id
                }), mailru.def.CONNECT_LOGOUT_URL);
            },

            loginFail: function () {
                return;
            },

            /**
             * Requests login status from server via proxy. Calls app.auto_install if application has connectPartner bit
             * @param {Function} callback (optional)                Accept session details
             * @return {undefined}
             */
            getLoginStatus: function (callback) {
                mailru.utils.requestOverProxy({
                    resource: 'getLoginStatus',
                    app_id: mailru.app_id,
                    cbid: mailru.callbacks.add(function (session, sessionstr) {

                        // parse getLoginStatus results to see if connectPartner bit is set, if so — call app.auto_install and modify
                        // the session data for the app to think is_app_user=1
                        var parsedResult = mailru.utils.parseGet(sessionstr);

                        // it's important that the auto_install is toggled only if there’s a callback
                        if (parsedResult.connectPartner !== undefined && parsedResult.connectPartner > 0 && callback !== undefined) {
                            //ask autoInstall to run and consequently call passed in callback when it's ready
                            // so in this case appAutoInstall will be responsible for calling the getLoginStatus callback
                            mailru.connect.appAutoInstall(mailru.app_id, callback, session, sessionstr);

                        // and if it was just a normal app without connectPartner=1, dispatch resulting session and fire the callback
                        } else {
                            // persist resulting session (maybe changed by the case defined above) in the cookie 
                            mailru.connect.dispatchSession(session, sessionstr);
                            if (typeof callback === 'function') {
                                callback(session, sessionstr);
                            }
                        }

                    })
                });
            },

            events: {
                login: 'connect.login',
                loginOAuth: 'connect.loginOAuth',
                logout: 'connect.logout',
                loginFail: 'connect.loginFail'
            },

            /**
             * @private
             */
            dispatchSession: function (session, sessionstr, is_app) {
                if (session.access_token) {
                    mailru.connect.getLoginStatus(function () {
                        mailru.events.notify(mailru.connect.events.login, mailru.session, mailru.utils.getCookie(mailru.def.CONNECT_COOKIE));
                    });
                    return false;
                }

                mailru.session = session;

                //if this is a full-screen game without our app_canvas, request proxy to initialise comet
                if (mailru.isGame && mailru.session.window_id && !mailru.cometInited && mailru.session && mailru.session.is_app_user) {
                    mailru.cometInited = true;
                    mailru.utils.requestOverProxy({
                        comet: 1,
                        app_id: mailru.app_id,
                        window_id: mailru.session.window_id
                    });
                }

                // session should be cleared in case the app is not authorised for this user
                // note: I couldn’t find cases where is_app is passed to dispatchSession, confirm if it's used anywhere at all
                if (session.is_app_user.toString() === '0' && !is_app) {
                    mailru.connect.clearSession();
                } else { // and if the app is authorised for the user, request further periodical session prologation
                    mailru.connect.prolongSession(session);
                }

                // persist current sessionstr (usually obtained from getLoginStatus) in the cookie for further use
                mailru.utils.setCookie({
                    name: mailru.def.CONNECT_COOKIE,
                    value: sessionstr
                });
            },

            /**
             * @private
             */
            clearSession: function () {
                mailru.session = false;
                window.clearTimeout(mailru.connect.prolongSessionTmr);
                mailru.utils.setCookie({
                    name: mailru.def.CONNECT_COOKIE,
                    expires: -1,
                    value: ''
                });
            },
            /**
             * @private
             */
            prolongSessionTmr: null,

            /**
             * requests getLoginStatus from the server to refresh the session every SESSION_REFRESH_EVERY milliseconds
             * note: session argument is not used at all, confirm that it can be deleted
             * @private
             */
            prolongSession: function (session) {
                window.clearTimeout(mailru.connect.prolongSessionTmr);
                mailru.connect.prolongSessionTmr = window.setTimeout(function () {
                    mailru.connect.getLoginStatus();
                }, mailru.def.SESSION_REFRESH_EVERY);
            }
        };
        mailru.plugin = {
            inited: false,
            elements: {},
            init: function () {
                if (!mailru.inited) {
                    api_init(1);
                }
                if (!mailru.plugin.inited) {
                    mailru.events.listen(mailru.plugin.events.closeLikeComment, function (result) {
                        if (result.share) {
                            mailru.utils.modal.close(mailru.plugin.like.buttonsWithComment[result.wid]);
                        } else {
                            mailru.utils.modal.close(result.wid);
                        }
                    });

                    mailru.events.listen(mailru.plugin.events.unliked, function (result) {
                        mailru.plugin.like.closeAllComments();
                    });
                    mailru.events.listen(mailru.plugin.events.liked, function (result) {
                        mailru.plugin.like.closeAllComments(function () {
                            if (!result.noComment) {
                                mailru.plugin.like.Comment(result);
                            }
                        });
                    });
                    mailru.events.listen(mailru.plugin.events.like.rlOK, function (result) {
                        mailru.plugin.like.closeAllComments(function () {
                            mailru.plugin.like.Comment(result);
                        });
                    });
                    mailru.events.listen(mailru.plugin.events.like.rl, function (result) {
                        mailru.plugin.like.rl(result);
                    });
                    mailru.events.listen(mailru.plugin.events.errorMessage, function (result) {
                        mailru.plugin.like.closeAllComments(function () {
                            mailru.plugin.like.errorMessage(result.wid, result.errorType, result.buttonType);
                        });
                    });
                    mailru.events.listen(mailru.plugin.events.like.comment, function (result) {
                        mailru.plugin.like.closeAllComments(function () {
                            mailru.plugin.like.Comment(result);
                        });

                    });
                    mailru.utils.addHandler(document.body, 'click', function (event) {
                        var trg, id;
                        event = event || window.event; //do we need this old IE crap?
                        trg = event.target || event.srcElement;

                        for (id in mailru.plugin.like.buttonsWithComment) {
                            if (mailru.plugin.like.buttonsWithComment.hasOwnProperty(id) && trg.id !== mailru.plugin.like.buttonsWithComment[id]) {
                                mailru.utils.modal.close(mailru.plugin.like.buttonsWithComment[id]);
                            }
                        }
                    });
                    mailru.events.listen(mailru.plugin.events.email.redirect, function (result) {
                        mailru.plugin.email.redirectTo(result.url);
                    });

                    mailru.plugin.inited = true;
                }
                if (mailru.isIE && mailru.isIE < 11) {
                    if (document.attachEvent) {
                        (function () {
                            try {
                                document.documentElement.doScroll("left");
                            } catch (e) {
                                setTimeout(mailru.plugin.init, 0);
                                return;
                            }
                            mailru.plugin.find();
                        }());
                    }
                    return false;
                // } else {
                }
                mailru.plugin.find();
            },
            find: function () {
                var a = document.getElementsByTagName('a'), al = a.length, ca = null, i;
                for (i = 0; i < al; i += 1) {
                    if (a[i] !== undefined && a[i].className.indexOf('mrc__plugin') !== -1 && !a[i].processed) {
                        ca = a[i];
                        ca.type = (ca.className.match(/^[mrc__Plugin_]\w*/gim))[0];
                        ca.type = (ca.type !== null ? ca.type.replace('mrc__plugin_', '') : null);
                        ca.params = false;
                        if (ca.getAttribute('data-mrc-config')) {
                            try {
                                ca.params = ca.getAttribute('data-mrc-config').length !== 0 ? eval('(' + ca.getAttribute('data-mrc-config').replace(new RegExp("\\n", "g"), '') + ')') : false;
                            } catch (e) {
                                ca.params = false;
                            }
                        }
                        if (!ca.params) {
                            try {
                                ca.params = ca.rel.length !== 0 ? eval('(' + ca.rel.replace(new RegExp("\\n", "g"), '') + ')') : {};
                            } catch (e) {
                                ca.params = {};
                            }
                        }
                        if (!ca.params.domain) {
                            ca.params.domain = document.domain;
                        }

                        if (ca.type !== null) {
                            mailru.plugin.insert(ca);
                        }
                    }
                }
            },
            insert: function (element) {
                element.insertOptions = {};
                var url = mailru.def.PLUGIN_URL + element.type + '?';
                switch (element.type) {
                case 'like_button':
                    mailru.plugin.like.Button(element);
                    url = mailru.def.LIKE.BUTTON_URL;
                    break;
                case 'uber_like_button':
                    mailru.plugin.like.Button(element);
                    element.params.cp = 1;
                    url = mailru.def.LIKE.UBER_BUTTON_URL;
                    break;
                case 'email_button':
                    url = mailru.def.EMAIL.BUTTON_URL;
                    break;
                case 'recommendations':
                    element.style.display = 'none';
                    return false;
                case 'groups_widget':
                    url = mailru.def.PLUGIN_URL + 'groups_widget?';
                    break;
                }
                var wid = 0;
                wid = mailru.utils.modal.open(url, {type: 'insertable', place: element, url:  element.params, insertOptions: element.insertOptions, wid: mailru.utils.uniqid()});
                element.processed = true;
                mailru.plugin.elements[wid] = element.params;
            },
            events: {
                liked: 'plugin.liked',
                unliked: 'plugin.unliked',
                likeCommented: 'plugin.likeCommented',
                closeLikeComment: 'plugin.closeComment',
                errorMessage: 'plugin.errorMessage',
                like: {
                    liked: 'plugin.like.liked',
                    unliked: 'plugin.like.unliked',
                    commented: 'plugin.like.Commented',
                    closeComment: 'plugin.like.closeComment',
                    errorMessage: 'plugin.like.errorMessage',
                    rl: 'plugin.like.rl',
                    rlOK: 'plugin.like.rlOK',
                    comment: 'plugin.like.comment'
                },
                email: {
                    data: 'plugin.email.data',
                    redirect: 'plugin.email.redirect'
                },
                group: {
                    subscribed: 'plugin.groups.subscribed'
                }
            },
            like: {
                buttonsWithComment: {},
                Button: function (element) {
                    var buttonID = mailru.utils.uniqid(),
                        params = mailru.utils.parseGet((element.getAttribute('href').match(/\?(.*)/) || [0, ''])[1]);
                    if (params.title) {
                        element.params.title = params.title;
                    }
                    if (params.desc) {
                        element.params.desc = params.desc;
                    }
                    if (params.description) {
                        element.params.desc = params.description;
                    }
                    if (params.image_url) {
                        element.params.imageurl = params.image_url;
                    }
                    if (params.imageurl) {
                        element.params.imageurl = params.imageurl;
                    }
                    if (params.share_url) {
                        element.params.url = params.share_url;
                    }
                    if (params.url) {
                        element.params.url = params.url;
                    }
                    if (!element.params.url || !element.params.url.length || (element.getAttribute('href').indexOf('share_url=') === -1 && element.getAttribute('href').indexOf('url=') === -1)) {
                        element.params.url = document.location.href;
                    } else {
                        if (element.params.url.indexOf('http://') === -1) {
                            element.params.url = 'http://' + element.params.url;
                        }
                        element.params.url = window.unescape(element.params.url);
                    }

                    if (params.swfurl) {
                        element.params.video = params.swfurl;
                    }
                    if (params.width) {
                        element.params.vwidth = params.width;
                    }
                    if (params.height) {
                        element.params.vheight = params.height;
                    }
                    if (params.screenshot) {
                        element.params.imageurl = params.screenshot;
                    }

                    element.params.buttonID = buttonID;
                    element.params.faces_count = 10;

                    element.params.sz = element.params.height = (element.params.sz || element.params.size) || 21;
                    element.params.st = (element.params.st || element.params.style) || 'oval';

                    if (element.params.tp || element.params.type) {
                        element.params.tp = element.params.tp || element.params.type;
                    }

                    if (params.share_remote) {
                        element.params.su = params.share_remote;
                    }

                    // if ((element.params.sz > 12 && element.params.sz < 70) && element.params.vt || element.params.vertical && !element.params.nc) {
                    if ((element.params.sz > 12 && element.params.sz < 70 && element.params.vt) || (element.params.vertical && !element.params.nc)) {
                        element.params.vt = 1;
                        element.params.height *= 3;
                    }

                    element.params.width = element.params.width || '100%';

                    element.insertOptions.wrap = true;
                    element.params.caption = element.innerHTML;
                    if (mailru.isIE) {
                        if (element.params.desc) {
                            element.params.desc = element.params.desc.substr(0, 200);
                        }
                        if (element.params.title) {
                            element.params.title = element.params.title.substr(0, 100);
                        }
                    }
                },
                Comment: function (result) {

                    if (result === undefined) {
                        return false;
                    }

                    var id = result.wid,
                        hid = result.history_id,
                        type = result.type,
                        ok_uid = result.OK_uid,
                        elementType = result.buttonType,
                        offset = result.offset || 0,
                        crosspost = result.crosspost || false,
                        checkCrosspost = result.checkCrosspost || false,
                        avatar = result.avatar || false,
                        buttonFrame = document.getElementById(id);


                    if (crosspost) {
                        return false;
                    }

                    if (!id || (!hid && (type === undefined || type !== 'ok')) || id === 'undefined' || (type === "ok" && ok_uid === undefined)) {
                        return false;
                    }
                    elementType = elementType || '';
                    type = type || '';
                    avatar = avatar || '';
                    var insertOptions = {
                        noreplace: true,
                        position: mailru.utils.window.getPosition(buttonFrame),
                        body: true
                    };

                    if (offset) {
                        insertOptions.position.left += +offset;
                    }

                    var style = {
                        position: 'absolute',
                        display: 'block',
                        zIndex: '1000',
                        overflow: 'auto',
                        margin: parseInt(buttonFrame.style.height, 10) + 'px 0 0'
                    };

                    var url = mailru.def.LIKE.COMMENT_URL + 'buttonID=' + id + '&';
                    if (elementType === 'uber-share') {
                        url += 'uber-share=1&';
                    }

                    if (buttonFrame.src.indexOf('&type=small') >= 0) {
                        url += 'small=1&';
                    }

                    if (buttonFrame.src.indexOf('&nt=1') >= 0) {
                        url += 'super-small=1&';
                    }

                    var data = {wid: mailru.plugin.like.buttonsWithComment[id], type: 'insertable', place: buttonFrame, insertOptions: insertOptions, url: {history_id: hid}, style: style};

                    if (checkCrosspost) {
                        url += 'checkCrosspost=1&';
                    }

                    mailru.plugin.like.buttonsWithComment[id] = mailru.utils.uniqid();
                    mailru.utils.modal.open(url, data);
                },
                closeAllComments: function (cb) {
                    var cid;
                    for (cid in mailru.plugin.like.buttonsWithComment) {
                        if (mailru.plugin.like.buttonsWithComment.hasOwnProperty(cid)) {
                            mailru.utils.modal.close(mailru.plugin.like.buttonsWithComment[cid]);
                        }
                    }
                    if (typeof cb === 'function') {
                        cb();
                    }
                },
                errorMessage: function (id, error, elementType) {
                    elementType = elementType || '';

                    var buttonFrame = document.getElementById(id);
                    var insertOptions = {
                        noreplace: true,
                        position: mailru.utils.window.getPosition(buttonFrame),
                        body: true
                    };

                    var style = {
                        position: 'absolute',
                        display: 'block',
                        zIndex: '1000',
                        overflow: 'auto',
                        margin: parseInt(buttonFrame.style.height, 10) + 'px 0 0'
                    };

                    var url = mailru.def.LIKE.COMMENT_URL;
                    if (elementType === 'uber-share') {
                        url += 'uber-share=1&';
                    }

                    mailru.plugin.like.buttonsWithComment[id] = mailru.utils.uniqid();
                    mailru.utils.modal.open(url, {wid: mailru.plugin.like.buttonsWithComment[id], type: 'insertable', place: buttonFrame, insertOptions: insertOptions, url: {error_type: error}, style: style});
                },
                rl: function (result) {
                    var id = result.wid || false, elementType = result.buttonType || '', buttonFrame, insertOptions, style, url, rl_url;
                    if (!id || id === 'undefined') {
                        return false;
                    }

                    buttonFrame = document.getElementById(id);
                    insertOptions = {
                        noreplace: true,
                        position: mailru.utils.window.getPosition(buttonFrame),
                        body: true
                    };

                    style = {
                        position: 'absolute',
                        display: 'block',
                        zIndex: '1000',
                        overflow: 'auto',
                        margin: parseInt(buttonFrame.style.height, 10) + 'px 0 0'
                    };
                    url = mailru.plugin.elements[id];
                    delete url.height;
                    delete url.app_id;
                    delete url.wid;
                    delete url.height;
                    delete url.width;
                    url.like_id = id;
                    url.buttonID = id;
                    url.rl = 1;

                    rl_url = mailru.def.LIKE.CAPTCHA_URL;
                    if (elementType === 'uber-share') {
                        rl_url += 'uber-share=1&';
                    }

                    mailru.plugin.like.buttonsWithComment[id] = mailru.utils.uniqid();
                    mailru.utils.modal.open(rl_url, {wid: mailru.plugin.like.buttonsWithComment[id], type: 'insertable', place: buttonFrame, insertOptions: insertOptions, url: url, style: style});
                }
            },

            email: {
                redirectTo: function (url) {
                    if (url) {
                        document.location = url;
                    }
                }
            }

        };

        // let the loader know that the api is ready to rock-n-roll
        mailru.loader.onready('api');

    }());

} // if (window.mailru.api === undefined) {
