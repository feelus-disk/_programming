// document.domain = "mail.ru";
function getEnv(){
    var isHttps = location.protocol === 'https:',
        branchMatch = location.href.match(/__branch=([a-z0-9\-]*)/i),
        branch = (branchMatch && branchMatch.length > 0) ? branchMatch[1] : '';
    return { 'branch': branch, 'isHttps': isHttps};
}
function getMode(moduleEnv){

    //default mode is always http-live
    var mode = 'http-live';

    // if current protocol is HTTPS and the branch is set, all content will be served from alphas via https, 
    // branch parameter will be persisted in all consequent URLs
    if (moduleEnv.branch !== '' && moduleEnv.isHttps) {
        mode ='https-alpha';
    }
    // if current protocol is not https but branch is set, content will be served from alphas with branch 
    // via http, branch will be persisted in all consequent URLs
    else if (moduleEnv.branch !== '') {
        mode ='http-alpha';
    }
    // if current protocol is https and no branch is set, then it's a live site with 
    // https, all content should be served from live https
    else if (moduleEnv.isHttps) {
        mode ='https-live';
    }

    // if no conditions apply, it's just a live site served via http
    return mode;
}
function getConnectUrl(resource) {
    var env = getEnv(),
        modulePaths = {
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
    var env = getEnv(),
        modulePaths = {
            'https-alpha': 'https://' + env.branch + '.myalpha.imgsmail.ru',
            'http-alpha':  'http://'  + env.branch + '.myalpha.imgsmail.ru',
            'https-live':  'https://my1.imgsmail.ru',
            'http-live':   'http://my1.imgsmail.ru'
        },
        modulePath = modulePaths[getMode(env)];
    return modulePath;
}



var DEBUG = DEBUG || false;
var mailru = {
	isIE: /*@cc_on!@*/false,
	DEF: {
		FLASH_TRANSPORT_URL: getImgsHost() + '/r/my/app/flash_lc_debug3.swf',
        COOKIE: "mrc_share",
        DOMAIN: document.location.host
	},
	DOM: {
		ready: false
	}
}

jQuery.extend(mailru, {
	init: function(params){
		params = params || {};
        mailru.DEF.cls = params.cls;
		mailru.share.init(params);
		mailru.share.form = params.form || null;
		mailru.intercom.init();

	},

	intercomType: ( window.postMessage && !mailru.isIE)? 'event' : (((function(){var i,a,o,p,s="Shockwave",f="Flash",t=" 2.0",u=s+" "+f,v=s+f+".",rSW=RegExp("^"+u+" (\\d+)");if((o=navigator.plugins)&&(p=o[u]||o[u+t])&&(a=p.description.match(rSW)))return a[1];else if(!!(window.ActiveXObject))for(i=10;i>0;i--)try{if(!!(new ActiveXObject(v+v+i)))return i}catch(e){}return 0;})() < 10) ? 'hash' : 'flash'),
	intercom: {
		inited: false,
		init: function(){
			if(!mailru.intercom.inited){
				if(!mailru.intercom[mailru.intercomType])
					return false;
				mailru.intercom.wrp = mailru.intercom[mailru.intercomType];
				mailru.intercom.wrp.init();
			}
		},
		receiver: function(){},
		wrp: {
			init: function(){},
			request: function(){}
		},
		mothership: {
			_m: null,
			init: function(){
				for(var i = 0; i < parent.frames.length; i++){
					try {
						if(parent.frames[i] !== window && typeof parent.frames[i].mailru !== 'undefined' && typeof parent.frames[i].mailru.share !== 'undefined'){
							if(parent.frames[i].mailru.GET.button_id == mailru.GET.button_id){
								mailru.intercom.mothership._m = parent.frames[i];
							}
						}
					} catch(e) { }
				}

			},
			request: function(){}
		},
		flash: {
			transport: "",
			inited: false,
			params: {},
			sendOnReady: '',
			toSend: [],
			insertFlash: function(){
                if (mailru.intercom.flash.inserted) {
                    return;
                }
				var code = '' +
				'<object id="api-lcwrapper-client" name="api-lcwrapper-client" height="1" width="1" type="application/x-shockwave-flash">' +
				'<param value="always" name="allowScriptAccess"/>' +
				'<param value="' +
				mailru.DEF.FLASH_TRANSPORT_URL +
				'" name="movie"/>' +
				'<param value="' +
				mailru.intercom.flash.vars +
				'" name="FlashVars"/>' +
				'</object>';

				mailru.intercom.flash.transport = document.createElement('div');
				document.body.appendChild(mailru.intercom.flash.transport);
				mailru.intercom.flash.transport.id = 'flash-transport-container';
				mailru.intercom.flash.transport.innerHTML = code;
                mailru.intercom.flash.inserted = true;
			},
			init: function(data){
				mailru.intercom.flash.params.fcid = mailru.GET.fcid || mailru.GET.window_id;

				if (!mailru.intercom.flash.params.fcid)
					mailru.intercom.flash.params.fcid = mailru.utils.uniqid();
				mailru.intercom.flash.sendOnReady = data;

				mailru.intercom.flash.vars = mailru.utils.makeGet({
					CBReady: 'mailru.intercom.flash.ready',
					listenTo: '',
					connectTo: 'api',
					cid: mailru.intercom.flash.params.fcid,
					host: document.domain,
					role: 'client',
					noOpposite: 1
				});
				if (mailru.isIE && !mailru.DOM.ready) {
                    $(mailru.intercom.flash.insertFlash);
				}
				else {
					mailru.intercom.flash.insertFlash();
				}
			},
			request: function(params){
				if(!params && mailru.intercom.flash.toSend.length){
					params = mailru.intercom.flash.toSend.pop();
				}
				if(typeof params !== 'string')
					params = mailru.utils.makeGet(params);

				try {
					document.getElementById('api-lcwrapper-client').send(params);
					if(mailru.intercom.flash.toSend.length)
						setTimeout(arguments.callee, 10);
				}
				catch (e) {
					mailru.intercom.flash.toSend.push(params);
					setTimeout(arguments.callee, 10);
					return false;
				}
			},
			ready: function(){
				mailru.intercom.flash.transport = document.getElementById('api-lcwrapper-client');
				//mailru.intercom.flash.request(params);
			},
			onSendStatus: function(){
            }
		},
		event: {
			init: function(){},
			request: function(params){
				window.parent.postMessage(params, mailru.GET.host);
			}
		}
	},
	utils: {
		parseGet: function (str){
            str = str.split('?')[1] || str;
			var p = str.split('&'), r = {}, di;
			for(var i=p.length; i--; ){
				di = p[i].indexOf('=');
				r[p[i].substr(0, di)] = decodeURIComponent(p[i].substr(di+1));
			}
			return r;
		},
		makeGet: function(hash){
			var r = [];
			for(var k in hash){
				if(!hash.hasOwnProperty(k)) continue;
				r[r.length] = k+ '='+ encodeURIComponent(hash[k]);
			}
			return r.join('&');
		},
        setCookie: function(opt) {

            if (!opt || !opt.name)
                return false;

            opt.domain = opt.domain || mailru.DEF.DOMAIN;
            opt.path = opt.path || '/';

            document.cookie = opt.name + "=" + escape(opt.value) +
                ((opt.expires) ? "; expires=" + (new Date(opt.expires)).toUTCString() : "") +
                ((opt.path) ? "; path=" + opt.path : "") +
                ((opt.domain) ? "; domain=." + opt.domain : "") +
                ((opt.secure) ? "; secure" : "");
        },
        getCookie: function(name) {
            var value;
            if (value = document.cookie.match((new RegExp('(^|;\\s*)' + name + '=([^;]+)(;|$)'))))
                return unescape(value[2]);

            return undefined;
        },
		plu: function(number, one, three, five){
			if(number <= 20 && number >= 10 || number == 0)
				return five;

			number = number.toString();
			number = number[number.length - 1];

			if(number == 1)
				return one;

			if(number <= 4 && number > 1){
				return three;
			}
			if(number >= 5 || number == 0){
				return five;
			}
		},
		uniqid: function(){
			return Math.round(Math.random(+new Date() + Math.random())*10000000);
		},
		resize: function(params){
			var data = {};

			data.wid = mailru.GET.wid;
			params.width && (data.modalWindowWidth = params.width);
			params.height && (data.modalWindowHeight = params.height);
			mailru.intercom.wrp.request(mailru.utils.makeGet({
				event: 'common.modalWindow',
				result: mailru.utils.makeGet(data),
				relation: 'parent',
				rt: 1
			}));
		},
		resizeImage: function(avatar, MAX_WIDTH, MAX_HEIGHT){
			MAX_WIDTH = MAX_WIDTH || 45;
			MAX_HEIGHT = MAX_HEIGHT || 45;
			with (avatar) {
				if (width > MAX_WIDTH) {
					height = height / (width / MAX_WIDTH)
					width = MAX_WIDTH;
				}
				if (height > MAX_HEIGHT) {
					  width = width / (height / MAX_HEIGHT)
					height = MAX_HEIGHT;
				}
				style.display = 'inline';
			}
		},
		serialize: function(data){
			if(typeof $ == 'undefined')
				return '';

			var f = $(data).find(':input'),
				d = '';
			for(var i = 0; i < f.length; i++){
				i && (d += '&');
				d += f[i].name + '=' + encodeURIComponent($(f[i]).val());

			}
			return d;
		},

        queue: {
            _items: [],
            push: function(element){
                mailru.utils.queue._items.push(element);
            },
            pop: function(){
                if(mailru.utils.queue._items.length)
                    return mailru.utils.queue._items.pop();
                else
                    return false;
            }

        },

        undef: function(o){
            return typeof o === 'undefined';
        },

        notifyButtons: function(params){
            params = params || {};

            var fm = null;

            for(var i = 0; i < parent.frames.length; i++){
                try {
                    fm = parent.frames[i];
                    if(!mailru.utils.undef(fm.mailru) && !mailru.utils.undef(fm.mailru.share) && fm.mailru.share.uber){
                        fm = parent.frames[i].mailru;
                    } else {
                        continue;
                    }

                    if(fm.GET.wid == mailru.GET.wid){
                        if(params.self){
                            //self action
                            params.self(parent.frames[i])
                        }
                    } else {
                        if(params.not_self){
                            //self action
                            params.not_self(parent.frames[i])
                        }
                    }

                    if(fm.GET.wid == mailru.GET.buttonID){
                        if(params.parent){
                            //parent action
                            params.parent(parent.frames[i]);
                        }
                    } else {
                        if(params.not_parent){
                            //not_parent action
                            params.not_parent(parent.frames[i]);
                        }
                    }

                    if(fm.GET.url && mailru.GET.url){
                        if(fm.GET.url.toLowerCase() == mailru.GET.url.toLowerCase() && fm.GET.wid != mailru.GET.wid){
                            //same url action
                            params.same_url && (params.same_url(parent.frames[i]));
                        }
                    }


                    //another share button action
                    if(params.different){
                        params.different(parent.frames[i]);
                    }

                    if(params.all){
                        params.all(parent.frames[i])
                    };

                } catch(e) {}
            }

            params.after && (params.after());
        },

		addCounter: function(n, s){
            var d = $.Deferred();

            s = s || false;
            n = n || false;

            var nImg = false,
                sImg = false;

            s && (sImg = new Image());
            n && (nImg = new Image());


			s && (sImg.src='//my.mail.ru/grstat?name=' + s + '&connect=1');
            n && (nImg.src='//rs.mail.ru/d' + n + '.gif?'+Math.random());


            if(nImg.complete || sImg.complete){
                d.resolve();
            } else {
                s && (sImg.onload = d.resolve);
                n && (nImg.onload = d.resolve);
            }

            if(!n && !s){
                d.resolve();
            }

            return d.promise();
		}
	},
	login: {
		check: function(params){
			if(mailru.share[params.type].user)
				return true;
			else
				return false;

		},
		show: function(){}
	},
	share: {
        uber: true,
		current: null,
        retryAuth: function (params) {
            if (typeof params === 'string') {
                params = jQuery.parseJSON(params);
            }

            params = params[2] || '';
            var url = getConnectUrl('share') + 'jsonp=1';

            // var script = $('<script></script>').attr('src', params + scheme + '%3A%2F%2Fconnect.mail.ru%2Fshare%3Fjsonp%3D1');
            var script = $('<script></script>').attr('src', params + encodeURIComponent(url));

            $(document.body).append(script);
        },
		login: {
			check: function(params){
				return mailru.share[params.type].user;
			},
			show: function(params){
				switch(params.type){
					case "mm":
						window.open(getConnectUrl('login') +'noclear=1&PopupMode=1&connect=1&sharelike=1&uber-share=1', '_blank', 'width=540,height=360');
						mailru.utils.addCounter(525466, 'login_my');
						break;

					case "ok":
						window.open('http://www.odnoklassniki.ru/oauth/authorize?client_id=3812608&scope=&response_type=code&redirect_uri=http://connect.mail.ru/xdm.html');
						mailru.utils.addCounter(525467, 'login_ok');
						break;
				}
			},
			process: function(){
                mailru.utils.notifyButtons({
                    self: function(frame){
                        mailru.utils.setCookie({
                            name : mailru.DEF.COOKIE,
                            value : mailru.utils.makeGet({
                                auto_share : 1
                            })
                        });
                        document.location.reload();
                    },
                    not_self: function(frame){
                        frame.mailru.share.changeState(
                            {
                                type: "mm",
                                reload: true
                            }
                        );
                    }
                });
			}
		},
		sendToMothership: function(callback, params){
			var data = mailru.utils.serialize(mailru.share.form[0]);
			var tdata = mailru.utils.parseGet(data);

            tdata['comment'] = params.text || '';

			if(params.type == "ok"){
				tdata['ok_uid'] = mailru.share.ok.uid;
				tdata['ok_sig'] = mailru.share.ok.sig;
				if(params.checkCrosspost == 1){
                    tdata['checkCrosspost'] = 1;
				}
				delete tdata.unlike;
				data = mailru.utils.makeGet(tdata);
			}

			if(params.type == "mm"){
				if(!mailru.share.mm.shared){
					delete tdata.unlike;
					data = mailru.utils.makeGet(tdata);
				} else {
					tdata.unlike = 1;
					data = mailru.utils.makeGet(tdata);
				}
			}

			if(mailru.share.form)
			    $.ajax({
				    url: mailru.share.form[0].action,
				    type: 'POST',
				    dataType: 'json',
				    data: data,
				    complete: function(data){
                        if (data.responseText.indexOf('Auth') > -1) {
                            mailru.share._blockComment = false;
                            mailru.share.retryAuth(data.responseText);
                        } else {
						    mailru.share.preloader.hide(params)
                        }
				    },
				    success: callback,
                    error: function(){
                        mailru.share[params.type].processing = false;
                        mailru.share._blockComment = false;
                    },
                    abort: function(){
                        mailru.share.retryAuth();
                        mailru.share[params.type].processing = false;
                        mailru.share._blockComment = false;
                    }
                });
		},
		add: function(params, result){
			mailru.share[params.type].shared = true;
			mailru.share[params.type].count++;

            if(params.update){
                return false;
            }

			var data = {};
			if(params.type == "mm"){
				data = {wid: mailru.GET.wid, history_id: result.history_id, id: mailru.GET.wid, uber_share: true, type: params.type, buttonType: 'uber-share'};
                mailru.utils.addCounter(642289);
			}
			if(params.type == "ok"){
				data = {wid: mailru.GET.wid, OK_uid: mailru.share.ok.uid, id: mailru.GET.wid, uber_share: true, type: params.type, buttonType: 'uber-share', noComment: true};
                mailru.utils.addCounter(642290);
			}

            if(mailru.share.crosspost == 'done'){
                data.crosspost = 1;
                mailru.share.crosspost = mailru.share.checkCrosspost(params);
            }

            if(mailru.share.checkCrosspost(params)){
                data.checkCrosspost = 1;
            }

            if (!mailru.share.comment) {
                data.noComment = 1;
            }

			mailru.intercom.wrp.request(mailru.utils.makeGet({
				event: 'plugin.liked',
				result: mailru.utils.makeGet(data),
				relation: 'parent',
				rt: 1
			}));
		},
		remove: function(params){
			mailru.share[params.type].shared = false;
			mailru.share[params.type].count--;

            if(mailru.share[params.type].count < 0){
                mailru.share[params.type].count = 0;
            }

            mailru.share._blockComment = false;

            if(params.update){
                return false;
            }

			var data = {};
			if(params.type == "mm"){
				data = {wid: mailru.GET.wid, id: mailru.GET.buttonid, uber_share: true, type: params.type, buttonType: 'uber-share'};
			}
			if(params.type == "ok"){
				return false;
			}

			mailru.intercom.wrp.request(mailru.utils.makeGet({
				event: 'plugin.unliked',
				result: mailru.utils.makeGet(data),
				relation: 'parent',
				rt: 1
			}));
		},
		process: function(params){
			if(mailru.share[params.type].processing || mailru.share._blockComment)
				return false;

            mailru.share._blockComment = true;
            if(mailru.share.mm.noMy && params.type == "mm"){
                mailru.intercom.wrp.request(mailru.utils.makeGet({
                    event: 'plugin.errorMessage',
                    result: mailru.utils.makeGet({wid: mailru.GET.wid, errorType: "without_my_error", id: mailru.GET.buttonid, buttonType: 'uber-share'}),
                    relation: 'parent',
                    rt: 1
                }));
                return false;
            }

			mailru.share[params.type].processing = true;

			if(!mailru.share.login.check(params)){
				mailru.share[params.type].processing = false;
                // если логин не сложился, сбрасываем blockComment
                mailru.share._blockComment = false;
				mailru.share.login.show(params);
			}  else {
				switch(params.type){
					case "mm":
						mailru.share.preloader.show(params);
                        // если уже пошарено, убираем шару
						if(mailru.share[params.type].shared){
							mailru.share.sendToMothership(function(result){
								if(result.unlike_ok){
									mailru.share.remove(params);
                                    params.update = true;
									mailru.share.changeState(params);
								} else {
									mailru.share[params.type].processing = false;
								}

								if(result.error){
									mailru.share[params.type].processing = false;
									switch(result.error){
										case "limit error":
											mailru.share.error(params, result);
											break;

                                        case "cannot delete":
                                            mailru.share._blockComment = false;
                                            break;

                                    }
								}
							}, params);
						} else {
                            // если ещё не пошарено, шарим
							mailru.share.sendToMothership(function(result){
								if(result.history_id && result.history_id !== 'spam'){
									mailru.share.add(params, result);
                                    params.update = true;
									mailru.share.changeState(params);
									if (mailru.share.comment) {
                                        mailru.share.comment(params, result);
                                    } else {
                                        mailru.share._blockComment = false;
                                    }
								} else {
									mailru.share[params.type].processing = false;
								}

								if(result.error){

									mailru.share[params.type].processing = false;
									switch(result.error){
										case "limit error":
											mailru.share.error(params, result);
											break;

                                        case "need_login":
                                            mailru.share.login.show(params);
                                            break;
                                    }
								}

							}, params);
						}
					    break;

					case "ok":
						if(!mailru.share[params.type].shared){
							mailru.share.preloader.show(params);
							mailru.share.comment && mailru.share.comment(params);
						} else {
                            mailru.share._blockComment = false;
                        }
						break;

				}
			}
		},
		preloader: {
            _set: function(params){
                if(!mailru.share.preloader[params.type]){
					mailru.share.preloader[params.type] = {
						_p: $('#' + params.type + '-like-preloader'),
						_l: $('#' + params.type + '-like-logo')
					};
				}
            },
			show: function(params){
				mailru.share.preloader._set(params);

				$(mailru.share.preloader[params.type]._p).show();
				$(mailru.share.preloader[params.type]._l).hide();
			},
			hide: function(params){

                mailru.share.preloader._set(params);
                
				$(mailru.share.preloader[params.type]._p).hide();
				$(mailru.share.preloader[params.type]._l).show();
			}
		},
		error: function(params, result){
			mailru.intercom.wrp.request(mailru.utils.makeGet({
				event: 'plugin.like.rl',
				result: mailru.utils.makeGet({wid: mailru.GET.wid, id: mailru.GET.buttonid, uber_share: true, type: params.type, buttonType: 'uber-share'}),
				relation: 'parent',
				rt: 1
			}));
		},
        _blockComment: false,
		comment: function(params, result){
			var data = {};
			switch(params.type){
				case "mm":
					data = {wid: mailru.GET.wid, id: mailru.GET.buttonid, uber_share: true, type: params.type, buttonType: 'uber-share', offset: mailru.share.mm.button[0].offsetLeft}
					break;

				case "ok":
					data = {wid: mailru.GET.wid, id: mailru.GET.buttonid, uber_share: true, OK_uid: mailru.share.ok.uid, type: params.type, buttonType: 'uber-share', offset: mailru.share.ok.button[0].offsetLeft, avatar: mailru.share.ok.avatar};
					break;
			}

            if(mailru.share.checkCrosspost(params)){
                mailru.share.crosspost = "ready";
                data.checkCrosspost = 1;
            }

            mailru.intercom.wrp.request(mailru.utils.makeGet({
                event: 'plugin.like.comment',
                result: mailru.utils.makeGet(data),
                relation: 'parent',
                rt: 1
            }));
		},
		updateCounter: function(params){
			if(mailru.share.noCounter)
				return false;

            if(mailru.share[params.type].count > 0){
			    $(mailru.share[params.type].counter).find('span').text((mailru.share[params.type].count+'').replace(/(\d)(?=(\d\d\d)+([^\d]|$))/g, '$1 '));
            } else {
                $(mailru.share[params.type].counter).find('span').text('+1');
            }

		},
		changeState: function(params){
			if(params.reload){
                if(mailru.share[params.type].processing)
                    setTimeout(document.location.reload, 5000);
                else
				    document.location.reload();
				return true;
			}
            
			mailru.share.updateCounter(params);
			if(!mailru.share[params.type].shared){
				$(mailru.share[params.type].button).removeClass(mailru.DEF.cls.liked).removeClass(mailru.DEF.cls.liked + '-' + params.type).removeClass(params.type + '-' + mailru.DEF.cls.liked);
			}  else {
				$(mailru.share[params.type].button).addClass(mailru.DEF.cls.liked).addClass(mailru.DEF.cls.liked + '-' + params.type).addClass(params.type + '-' + mailru.DEF.cls.liked);
			}
			mailru.share[params.type].processing = false;
            mailru.share.preloader.hide(params);
            if(params.update){
                mailru.utils.notifyButtons({
                    same_url: (function(shared, params){
                        return function(frame){
                            params.update = true;
                            if(shared){
                                frame.mailru.share.add(params);
                            } else {
                                frame.mailru.share.remove(params);
                            }
                            params.update = false;
                            frame.mailru.share.changeState(params);
                        }
                    })(mailru.share[params.type].shared, params)
                });
                
            }
		},
        notify: function(params){
            if(mailru.share.crosspost && mailru.share.crosspost == "ready"){
                mailru.share.crosspost = "processing";
                mailru.share.doCrosspost(params);
            }

        },
        checkCrosspost: function(params){
            params = params || {};
            if(mailru.share.login.check({type: "ok"}) && mailru.share.login.check({type: "mm"}) && ((!mailru.share.mm.shared && params.type == "ok") || (!mailru.share.ok.shared && params.type == "mm"))  && (mailru.GET.cp || mailru.GET.crosspost)) {
                return true;
            } else {
                return false;
            }
        },
        doCrosspost: function(params){

            if(params.type == "ok"){
                params.type = "mm";
            } else {
                params.type = "ok";
                params.checkCrosspost = 1;
            }

            mailru.share.sendToMothership(function(result){
                if(!result.error && !result.rl){
                    mailru.share.crosspost = "done";
                    mailru.share.add(params, result);
                    params.update = true;
                    mailru.share.changeState(params);
                }
            }, params);
        },
		init: function(params){
			params = params || {};

			mailru.share.mm.button = $('#mm-like');
			mailru.share.mm.counter = $('#mm-share-counter');

			mailru.share.ok.button = $('#ok-like');
			mailru.share.ok.counter = $('#ok-share-counter');

			mailru.intercom.init();

			if(params.noComment){
				mailru.share.comment = false;
			}

            mailru.share.crosspost = mailru.share.checkCrosspost();

			if(params.noCounter){
				mailru.share.noCounter = true;
			    mailru.share.mm.counter.hide();
				mailru.share.ok.counter.hide();
			}

			if(params.noMy){
                mailru.share.mm.noMy = true;
				$(mailru.share.mm.button).click(function(){
					mailru.intercom.wrp.request(mailru.utils.makeGet({
						event: 'plugin.errorMessage',
						result: mailru.utils.makeGet({wid: mailru.GET.wid, errorType: "without_my_error", id: mailru.GET.buttonid, buttonType: 'uber-share'}),
						relation: 'parent',
						rt: 1
					}));
					return false;
				});
			} else {
                $(mailru.share.mm.button).click(function(){
                    mailru.share.current = "mm";
                    mailru.share.process({type: "mm"});
                    return false;
                });
            }

			$(mailru.share.ok.button).click(function(){
				mailru.share.current = "ok";
				mailru.share.process({type: "ok"});
				return false;
			});
		},
		mm: {
			init: function(params){
				mailru.share.mm.user = params.user;
				mailru.share.mm.shared = params.shared;
				mailru.share.mm.count = params.count;
				mailru.share.mm.inited = true;

				mailru.share.updateCounter({type: 'mm'});

				if(!mailru.share.mm.shared && mailru.share.mm.user && mailru.utils.parseGet(mailru.utils.getCookie(mailru.DEF.COOKIE) || '')['auto_share'] == 1){
					mailru.utils.setCookie({
                        name: mailru.DEF.COOKIE,
                        value: ''
                    })
                    mailru.share.process({type: "mm"});
				}
			},
			add: function(){},
			remove: function(){},

			inited: false,
			user: null,
			shared: null,
			button: null,
			counter: null,
			count: 0,
			processing: false,
			preloader: {
				_p: null,
				show: function(){

				},
				hide: function(){}
			}
		},
		ok: {
			init: function(params){
				if(typeof params === 'undefined')
					return false;

                mailru.share.ok.count = +params.count || 0;

				if(params.uid){
					mailru.share.ok.uid = params.uid;
				}
  
				if(params.status == "ok" || params.status == "shared"){
					mailru.share.ok.user = true;
					mailru.utils.addCounter(525464, 'shows_ok_cookie');
					if(mailru.share.mm.user){
						mailru.utils.addCounter(525465, 'shows_both_cookies');
					}
				} else {
					mailru.share.ok.user = false;
					if(mailru.share.mm.user){
						mailru.utils.addCounter(525463, 'shows_my_cookie');
					} else {
						mailru.utils.addCounter(525462, 'shows_wo_cookies');
					}
				}

                mailru.share.crosspost = mailru.share.checkCrosspost();

				if(params.sign){
					mailru.share.ok.sig = params.sign;
				}

				if(params.avatarURL){
					mailru.share.ok.avatar = params.avatarURL.replace('&amp;', '&');
				}

				if(params.status == "shared"){
					mailru.share.ok.shared = true;
					mailru.share.changeState({type: "ok"});
				}

				mailru.share.updateCounter({type: "ok"});
				mailru.share.ok.inited = true;
			},
			add: function(params){
				mailru.share.sendToMothership(function(result){
                        mailru.share.add(params, result);
                        params.update = true;
						mailru.share.changeState(params);
				}, params);
			},
			remove: function(){},

			inited: false,
			user: null,
			uid: null,
			sig: null,
			avatar: null,
			shared: null,
			button: null,
			counter: null,
			count: 0,
			processing: false,
			preloader: {
				_p: null,
				show: function(){},
				hide: function(){}
			},
			login: {
				after: function(params){
					mailru.share.ok.init(params);
					mailru.share.process({type: "ok"});
                    mailru.utils.notifyButtons({
                        not_self: function(frame){
                            frame.mailru.share.changeState(
                                {
                                    type: "ok",
                                    reload: true
                                }
                            );
                        }
                    });
				}
			},
			getInfo: function(){
				$(document.body).append($('<script src="http://www.odnoklassniki.ru/dk?st.cmd=shareData&ref=' + encodeURIComponent(mailru.utils.parseGet(document.URL)['url']) + '&cb=mailru.share.ok.login.after"></script>'));
			}
		}
	},
	avatar: {
		resize: function(avatar){
			var MAX_WIDTH = 45;
			  var MAX_HEIGHT = 45;
			  with (avatar) {
				if (width > MAX_WIDTH) {
				  height = height / (width / MAX_WIDTH)
				  width = MAX_WIDTH;
				}
				if (height > MAX_HEIGHT) {
				  width = width / (height / MAX_HEIGHT)
				  height = MAX_HEIGHT;
				}
				style.display = 'inline';
			  }
		}
	}
});

mailru.GET = mailru.utils.parseGet(document.URL);
//iefix
mailru.GET.buttonid = mailru.GET.buttonID;

if(mailru.GET.history_id || mailru.GET.ok_uid){
	mailru.share = {
        _type: null,
        counters: {
            noCP: false
        },
        close: function(params){
	        params = params || {};
            var shareCounterId = false;
	        if($(mailru.share.comment._c).hasClass('focused') && !params.force)
	            return false;
            if(mailru.GET.checkCrosspost ){

                if(!$("#crosspost").attr("checked") && !mailru.share.counters.noCP){
                    mailru.utils.addCounter('632319');
                    mailru.share.counters.noCP = 1;

                    switch(mailru.share._type){
                        case "mm":
                            shareCounterId = 642294;
                            break;

                        case "ok":
                            shareCounterId = 642296;
                            break;
                    }
                } else {
                    switch(mailru.share._type){
                        case "mm":
                            shareCounterId = 642292;
                            break;

                        case "ok":
                            shareCounterId = 642293;
                            break;
                    }
                }
            }

	        if(mailru.share._type == "ok" && !mailru.share.comment._processed){
				mailru.share.comment.process('close');
			}

            if(!mailru.share.comment._processed){
                mailru.share.notify({text: '', type: mailru.share._type, noClose: true, noShare: true});
            }

            mailru.utils.notifyButtons({
                self: function(){
                    mailru.share._blockComment = false;
                }
            });

            mailru.utils.addCounter(shareCounterId).done(function(){
                    mailru.intercom.wrp.request(mailru.utils.makeGet({
                        event: 'plugin.closeComment',
                        result: mailru.utils.makeGet({wid: mailru.GET.wid, buttonType: 'uber-share'}),
                        relation: 'parent',
                        rt: 1
                    }));
                }
            );
        },
        comment: {
            _c: null,
            _p: null,
	        _timeout: 10000,
	        _processed: false,
            _checkLength: function(){
                var commentLength = mailru.share.warn.length - $(mailru.share.comment._c).val().length;
                if(commentLength < 0){
                    $(mailru.share.comment._c).val($(mailru.share.comment._c).val().substr(0, mailru.share.warn.length));
                    commentLength = 0;
                }
                $('#counter').text(commentLength);
                
                $('#counter').show();

                if(commentLength <=  15){
                    $('#counter').addClass('warn');
                } else {
                    $('#counter').removeClass('warn');
                }


            },
            init: function(){
                mailru.share.comment._c = $('#comment');
                mailru.share.comment._p = $(mailru.share.comment._c).text();
                $(mailru.share.comment._c).focus(function(){
                    $('#counter').show();
                    if($(this).val() == mailru.share.comment._p){
                        $(this).val('');
                        $(this).addClass('focused');
                    }

                    clearTimeout(mailru.share._t);
                    mailru.share._t = null;
                });
                $(mailru.share.comment._c).blur(function(){
                    if($(this).val() == mailru.share.comment._p || $(this).val() == ''){
                        $(this).val(mailru.share.comment._p);
                        $(this).removeClass('focused');
                        $('#counter').hide();
                    }

                    mailru.share._t || (mailru.share._t = setTimeout(mailru.share.close, mailru.share.comment._timeout));
                });
                $(mailru.share.comment._c).keyup(mailru.share.comment._checkLength);
                mailru.share._t = setTimeout(mailru.share.close, mailru.share.comment._timeout);
                $('#close').click(function(){
					mailru.share.close({force: true});
	                return false;
                });
	            $('#add-comment').click(function(){
                    clearTimeout(mailru.share._t);
					mailru.share.comment.process();
		            return false;
                });

            },
            process: function(close){
                close = close || false;
                var text = false;



                if($(mailru.share.comment._c).val() !== '' && $(mailru.share.comment._c).val() !== mailru.share.comment._p){
                    text = $(mailru.share.comment._c).val();
                }

                if(mailru.share.warn && mailru.share.warn.length < $(mailru.share.comment._c).val().length && !close){
                    mailru.share.comment.error.show('legnth');
                    return false;
                }

	            if(text){
					if(mailru.share._type == "mm"){
						mailru.share.sendToMothership(function(){
                            mailru.share.notify({text: text, type: mailru.share._type, noClose: true});
                            mailru.share.comment.post();
                        });

					}
                }

                if(mailru.share._type == "ok")
                    mailru.share.notify({text: text || "", type: mailru.share._type});

            },
            post: function(){
	            mailru.share.comment._processed = true;
                mailru.share.close({force: true});
            },
            error: {
                _e: null,
                show: function(type){
                    mailru.share.comment.error._e = mailru.share.comment.error._e || $('#error');
                    type = type || '';
                    var t = '';
                    switch(type){
                        case "length":
                            t = "Слишком длинный комментарий";
                            break;
                    }
                    mailru.share.comment.error._e.text(t);
                    mailru.share.comment.error._e.show();
                },
                hide: function(){
                    mailru.share.comment.error._e.hide();
                }
            }
        },
        captcha: function(){},
        init: function(params){
            params = params || {};

            if(params.warn)
                mailru.share.warn = params.warn;
            
            if(mailru.GET.ok_uid){
                mailru.share._type = 'ok';
            }
            if(mailru.GET.history_id){
                mailru.share._type = 'mm';
            }
            if(!mailru.share._type){
                throw new Error("Can't get comment type");
                return false;
            }
            mailru.share.comment.init();
            $(mailru.share.form).submit(mailru.share.comment.process);
        },
        sendToMothership: function(callback, params){
	        callback = callback || function(){};
	        var data = mailru.utils.serialize(mailru.share.form[0]);

            if(mailru.share.form)
			    $.ajax({
				    url: mailru.share.form[0].action,
				    type: 'POST',
				    data: data,
				    success: callback,
                    error: function(){
                        mailru.share[params.type].processing = false;
                        mailru.share._blockComment = false;
                    },
                    abort: function(){
                        mailru.share[params.type].processing = false;
                        mailru.share._blockComment = false;
                    }
			    });
        },
        notify: function(params){
	        params = params || {};
            var shared = false,
                frame = null;

            mailru.utils.notifyButtons({
                parent: (function(comment, params){
                    return function(frame){
                        frame.mailru.share._blockComment = false;

                        if(comment.GET.checkCrosspost && $("#crosspost").attr("checked")){
                            frame.mailru.share.notify({type: comment.share._type, text: params.text});
                        }
                        if(!params.noShare){
                            if(!frame.mailru.share[mailru.share._type].shared){
                                if(comment.share._type == "ok"){
                                    frame.mailru.share.ok.add({type: "ok", text: params.text});
                                }
                            }
                        }
                    }
                })(mailru, params)
            });

	        mailru.share.comment._processed = true;
            if(!params.noClose)
                mailru.share.close({force: true});
        }
    };
}

if(mailru.GET.rl){
	mailru.share = {
		init: function(params){
            if(!params.form)
                return false;

            mailru.share.captcha._c = $('#captcha_answer');
            $(params.form).submit(function(){
                mailru.share.captcha.process();
                return false;
            });
			$('#process-captcha').click(function(){
                $(params.form).submit();
                return false;
            });
		},
        error: function(params){
            $('#captcha-error').show();
            $('.error').hide();
            switch(params){
                case "wrong" :
                    $('#wrong-captcha').show();
                    break;

                case "empty" :
                    $('#no-captcha').show();
                    break;
            }

            mailru.utils.resize({
               width: document.body.offsetWidth,
                height: document.body.offsetHeight + 15
            });
        },
		captcha: {
			_c: null,
			process: function(data){

                if($(mailru.share.captcha._c).val() == ''){
                    mailru.share.error('empty');
                    return false;
                }
				data = data || {};
				if(data.history_id) {
					mailru.share.captcha.notify(data);
                    return true;
				}
                if(data.error == "limit error"){
                    mailru.share.error('wrong');
					return false;
				}

                mailru.share.sendToMothership(mailru.share.captcha.process);
			},
			notify: function(data){
                data = data || false;
				var shareAdded = false;
                var frame = null;

                mailru.utils.notifyButtons({
                    parent: (function(data){
                        return function(frame){
                            frame.mailru.share._blockComment = false;

                            if(!frame.mailru.share.mm.shared && data){
								frame.mailru.share.add({type: "mm"}, data);
								frame.mailru.share.changeState({type: "mm", update: true});
                                frame.mailru.share.comment && frame.mailru.share.comment({type: "mm"}, data);
							} else {
								frame.mailru.share.changeState({reload: true, type: "mm"});
							}
                        }
                    })(data)

//                    ,after: function(){
//                        mailru.intercom.wrp.request(mailru.utils.makeGet({
//                            event: 'plugin.closeComment',
//                            result: mailru.utils.makeGet({wid: mailru.GET.wid, id: mailru.GET.buttonID, buttonType: 'uber-share'}),
//                            relation: 'parent',
//                            rt: 1
//                        }));
//                    }
                });
			}
		},
		sendToMothership: function(callback, params){
	        callback = callback || function(){};
	        var data = mailru.utils.serialize(mailru.share.form[0]);
	        if(mailru.share.form)
			    $.ajax({
				    url: mailru.share.form[0].action,
				    type: 'POST',
				    dataType: 'json',
				    data: data,
				    success: callback
			    });
        }
	}
}
