var Community = {

init: function() {
  cur.Rpc = new fastXDM.Client({
    onInit: function() {
      setTimeout(function () {
        Community.resizeWidget();
      }, 500);
    },
    authorised: function (args) {
      var href = location.href;
      if (href.indexOf('fieldText=') != -1) href = href.replace(/fieldText=.+?(&|$)/, 'fieldText=' + winToUtf(ge('commentFiled').getValue()) + '\1');
      else href = href + '&fieldText=' + winToUtf(ge('commentFiled').getValue());

      if (href.indexOf('autoLogin=1') != -1) href = href.replace('autoLogin=1', 'autoLogin=0');
      location.href = href;
      return;
    },
    unauthorised: function (args) {
      var href = location.href;
      if (href.indexOf('autoLogin=0') != -1) href = href.replace('autoLogin=0', 'autoLogin=1');
      else href = href + '&autoLogin=1';

      cur.Rpc.callMethod('auth');
      location.href = href;
      return;
    },
    mouseMove: function(screenY) {
      cur.mouseMove(screenY);
    },
    mouseUp: function() {
      cur.mouseUp();
    }
  }, {safe: true});

  cur.mainDiv = ge('main');
  Community.resizeWidget();
  if (window.wall) {
    wall.postTooltip = function() {};
  }

  setTimeout(function () {
    Community.resizeWidget();
  }, 0);

},

resizeWidget: function() {
  onBodyResize(true);
  if (!cur.mainDiv || !cur.Rpc) return;
  var size = getSize(cur.mainDiv)[1];
  cur.Rpc.callMethod('resize', size);
},

sendChangeState: function(state, oid, callback, isEvent) {
  if (state) {
    cur.Rpc.callMethod('publish', 'widgets.groups.joined');
  } else {
    cur.Rpc.callMethod('publish', 'widgets.groups.leaved');
  }
  var hiddenDomain = ge('hiddenDomain');
  if (hiddenDomain) {
    domain = hiddenDomain.value;
  } else {
    domain = '';
  }
  ajax.post('/widget_community.php', {
    act: 'a_change_state',
    state: state,
    oid: oid,
    hash: cur.hash,
    domain: domain,
    is_event: isEvent ? 1 : 0
  }, {
    onDone: function(result, str) {
      if (callback) {
        callback(result, str);
      }
    },
    onFail: function() {}
  });
},


changeGroupState: function(state, callback) {
  if (cur.isAdmin) {
    if (!confirm(cur.isAdminLang)) { return false; }
  }
  if (cur.noAuth) {
    Community.widgetAuth();
    window.gotSession = function(autorzied) {
      if (autorzied == -1) {
        setTimeout(function () {
          location.reload();
        }, 1000);
        location.href = location.href + '&1';
      }
      if (autorzied) {
        ajax.post('/widget_community.php', {act: 'a_get_info', oid: cur.oid}, {
          onDone: function(result) {
            if (result.hash) {
              cur.noAuth = false;
              cur.justAuth = true;
              cur.hash = result.hash;
              cur.can_subscribe = result.can_subscribe;
              if (result.subscribed) {
                addClass(cur.join_community, 'community_checked');
              } else {
                removeClass(cur.join_community, 'community_checked');
              }
              Community.changeGroupState(state, callback);
            }
          }
        });
      } else {
      }
    }
    return false;
  } else {
    if (!cur.justAuth && ge('community_anim_row')) {
      if (state) {
        animate(ge('community_anim_row'), {marginLeft: 0}, 200);
        ge('members_count').innerHTML = cur.count_in;
      } else {
        animate(ge('community_anim_row'), {marginLeft: -cur.mWidth}, 200);
        ge('members_count').innerHTML = cur.count_out;
      }
    }
    Community.sendChangeState(state, cur.oid);
    callback();
    return true;
  }
},

changeEventState: function(state, oid, btn) {
  if (cur.noAuth) {
    Community.widgetAuth();
    window.gotSession = function(autorzied) {
      cur.noAuth = false;
      ajax.post('/widget_community.php', {act: 'a_get_info', oid: cur.oid}, {
        onDone: function(result) {
          if (result.hash) {
            cur.hash = result.hash;
            cur.can_subscribe = result.can_subscribe;
            Community.changeEventState(state, oid, btn);
          }
        }
      });
    }
    return false;
  }
  if (state == -1) {
    cur.linkCont = btn.innerHTML;
    btn.innerHTML = '<img src="/images/upload.gif" />';
  } else {
    lockButton(btn);
  }
  Community.sendChangeState(state, cur.oid, function(html) {
    if (state == -1) {
      btn.innerHTML = cur.linkCont;
    } else {
      unlockButton(btn);
    }
    ge('community_event_join').innerHTML = html;
    Community.resizeWidget();
  }, 1);
},


widgetAuth: function() {
  var
    screenX = typeof window.screenX != 'undefined' ? window.screenX : window.screenLeft,
    screenY = typeof window.screenY != 'undefined' ? window.screenY : window.screenTop,
    outerWidth = typeof window.outerWidth != 'undefined' ? window.outerWidth : document.body.clientWidth,
    outerHeight = typeof window.outerHeight != 'undefined' ? window.outerHeight : (document.body.clientHeight - 22),
    features = 'width=655,height=479,left=' + parseInt(screenX + ((outerWidth - 655) / 2), 10) + ',top=' + parseInt(screenY + ((outerHeight - 479) / 2.5), 10);
    window.activePopup = window.open(location.protocol + '//oauth.vk.com/authorize?client_id=-1&redirect_uri=close.html&display=widget', 'vk_openapi', features);
    function checkWnd() {
      if (window.activePopup.closed) {
       window.gotSession(true);
      } else {
       setTimeout(checkWnd, 1000);
      }
    }
    checkWnd();
},

toggleStat: function(oid, width) {
  if (cur.statShown) {
    setStyle(ge('community_groups_main'), {height: 'auto'});
    hide('hide_stat');
    show('show_stat');
    show('community_content');
    hide('stat_info');
    setTimeout(Community.resizeWidget, 0);
  } else {
    cur.oldHeight = getSize('community_groups_main')[1];
    show('hide_stat');
    hide('show_stat');
    hide('community_content');
    show('stat_info');
    setTimeout(Community.resizeWidget, 0);
    setTimeout(Community.resizeWidget, 500);
    if (!cur.statLoaded) {
      setStyle(ge('community_groups_main'), {height: cur.oldHeight - 8});
      setStyle(ge('wcomments_progress'), {marginTop: cur.oldHeight / 2 - 40});
      ajax.post('/widget_community.php', {act: 'a_get_stat', width: width, oid: oid}, {
        onDone: function(text) {
          setStyle(ge('community_groups_main'), {height: 'auto'});
          cur.statLoaded = true;
          ge('stat_info').innerHTML = text;
          setTimeout(Community.resizeWidget, 0);
          setTimeout(Community.resizeWidget, 500);
        }
      });
    } else {
      setStyle(ge('community_groups_main'), {height: 'auto'});
    }
  }
  cur.statShown = !cur.statShown;
},

membersBox: function(oid) {
  cur.Rpc.callMethod('showBox', 'widget_community.php?act=members_box&oid='+oid, {height: 442, width: 498});
},

subscribeGroupState: function(state, oid) {
  ajax.post('/widget_community.php', {act: 'a_subscribe', state: state, oid: oid, hash: cur.hash}, {
    onDone: function(t) {

    },
    onFail: function() {
      return true;
    }
  });
  return true;
},

hideStat: function(oid, width) {
  hide('hide_stat');
  show('show_stat');
  show('community_content');
  hide('stat_info');
  setTimeout(Community.resizeWidget, 0);
},

subscribeSimple: function() {
  Community.changeGroupState(1, function() {
    hide('subscribe_button');
    show('unsubscribe_button');
    if (cur.canSwitch) {
      hide('community_friends');
      show('community_like');
    }
  });
},

unsubscribeSimple: function() {
  Community.changeGroupState(0, function() {
    show('subscribe_button');
    hide('unsubscribe_button');
    if (cur.canSwitch) {
      show('community_friends');
      hide('community_like');
    }
  });
},

headerOver: function(ev) {
  if (cur.nameOutTimeout) {
    clearTimeout(cur.nameOutTimeout);
  }
  if (cur.headTween) {
    return;
  }
  var obj = ge('wcommunity_name_cont');
  addClass(obj, 'wcommuinty_name_scrolling');
  var anim = ge('wcommunity_name_anim');
  var width = getSize(anim)[0] - getSize(obj)[0];
  if (width < 0) {
    return false;
  }
  var speed = width * 40;
  if (cur.headTimeout) {
    clearTimeout(cur.headTimeout);
  }
  cur.headTween = animate(anim, {marginLeft: -width}, {duration: speed, transition: Fx.Transitions.linear, onComplete:function() {
    cur.headTimeout = setTimeout(function() {
      cur.headTween = animate(anim, {marginLeft: 0}, {duration: speed, transition: Fx.Transitions.linear, onComplete: function() {
        cur.headTween = false;
        cur.headTimeout = setTimeout(Community.headerOver.pbind(ev), 1000);
      }});
    }, 1000);
}});

},

headerOut: function(ev) {
  var obj = ge('wcommunity_name_cont');
  if (cur.headTimeout) {
    clearTimeout(cur.headTimeout);
  }
  cur.nameOutTimeout = setTimeout(function() {
    var anim = ge('wcommunity_name_anim');
    cur.headTween = animate(anim, {marginLeft: 0}, 200, function() {
      removeClass(obj, 'wcommuinty_name_scrolling');
      cur.headTween = false;
    });
    if (cur.headTimeout) {
      clearTimeout(cur.headTimeout);
    }
  }, 50);
},

_eof: 1};try{stManager.done('api/widgets/al_community.js');}catch(e){}


window.gotSession = function(session_data) {
  //pass
}

var communityWall = {
  postTooltip: function(el, post, opts) {
    if (cur.viewAsBox) return;
    var poll = geByClass('poll', el);
    if (poll.length && cur.baseUrl) {
      el.href = cur.baseUrl + 'wall'+post;
    }
    return true;
  },
  showMore: function() {
    if (cur.wallLoaded) {
      return false;
    }
    if (cur.loadingMore) {
      cur.meedMore = true;
      return;
    }
    cur.loadingMore = true;
    hide('wall_more_text');
    show('wall_more_progress');
    var params = {
      act: 'load_more',
      offset: cur.offset,
      oid: cur.oid,
      wide: cur.wide,
      width: cur.width
    };
    if (cur.mode) {
      params.mode = 1;
    }
    ajax.post('/widget_community.php', params, {
      onDone: function(wallCont, count, limit) {
        cur.offset += limit;
        if (cur.offset >= count) {
          cur.wallLoaded = true;
          hide('wall_more_cont');
        }
        ge('page_wall_posts').appendChild(ce('div', {
          innerHTML: wallCont
        }));
        Community.resizeWidget();
        setTimeout(Community.resizeWidget, 500);
        show('wall_more_text');
        hide('wall_more_progress');
        cur.loadingMore = false;
        if (cur.meedMore) {
          cur.meedMore = false;
          setTimeout(function() {
            communityWall.showMore()
          }, 0);
        }
        if (cur.scrollbar) {
          cur.scrollbar.update();
        }
      },
      onFail: function() {
        return true;
      }
    })
  }
}

function goAway(url) { return true; }

function showPhoto (photo, list) {
  var h = 607, w = 607;

  cur.Rpc.callMethod('showBox', 'al_photos.php?' + ajx2q({act: 'photo_box', photo: photo, wall_owner: photo.split('_')[0], widget: 1, list: list, widget_width: 654, widget: 1}), {height: window.outerHeight || screen.availHeight || 768, width: window.outerWidth || screen.availWidth || 1028});
  return false;
}

function mentionOver(el, opts) {
  return false;
}

function mentionClick(el, ev, opts) {
  return true;
}

function showWiki(likeInfo) {
  return true;
}

function showVideo(video, list) {
  cur.Rpc.callMethod('showBox', 'al_video.php?' + ajx2q({act: 'video_box', video: video, list: list, wall_owner: video.split('_')[0], widget_width: 654, widget: 1, module: cur.module || '_alcommunity'}), {height: window.outerHeight || screen.availHeight || 768, width: window.outerWidth || screen.availWidth || 1028});
  return false;
}

function showFriends(oid) {
  if (oid > 0) return true;
  cur.Rpc.callMethod('showBox', 'al_page.php?' + ajx2q({act: 'show_members_box', gid: -oid, tab: 'friends', widget: 1}), {height: 495, width: 432});
  return false;
}


// Tiny Scrollbars start (from al_community.js)
(function(w) {
w.Scrollbar = function (obj, options) {
  this.obj = obj = ge(obj);
  this.options = options || {};

  setTimeout((function() {
    if (!obj) return;
    setStyle(obj, {
      overflow: 'hidden'
    });

    var size = getSize(obj);
    if (size[0] < 100 && options.width) {
      size[0] = options.width - 2;
    }
    this.scrollHeight = size[1];

    this.scrollbar = ce('div', {
      className: 'scrollbar_cont'
    });
    setStyle(this.scrollbar, {
      right: '1px',
      left: 'auto',
      height: size[1] + 'px'
    });

    this.inner = ce('div', {
      className: 'scrollbar_inner'
    });
    this.scrollbar.appendChild(this.inner);

    if (options.shadows) {
      this.topShadowDiv = ce('div', {
        className: 'scrollbar_top'
      });
      this.bottomShadowDiv = ce('div', {
        className: 'scrollbar_bottom',
        width: size[0]+'px'
      });
      this.bottomShadowDiv.style.width = this.topShadowDiv.style.width = size[0]+'px';
      obj.parentNode.insertBefore(this.topShadowDiv, obj);
      obj.parentNode.insertBefore(this.bottomShadowDiv, obj.nextSibling);
    }

    obj.parentNode.insertBefore(this.scrollbar, obj);

    this.mouseMove = this._mouseMove.bind(this);
    this.mouseUp = this._mouseUp.bind(this);

    var self = this;

    function down(event) {
      if (self.moveY) return;

      addEvent(w.document, 'mousemove', self.mouseMove);
      addEvent(w.document, 'mouseup', self.mouseUp);


      self.moveY = event.screenY - (parseInt(self.inner.style.marginTop) || 0);

      w.document.body.style.cursor = 'pointer';
      addClass(self.inner, 'scrollbar_hovered');
      if (options.startDrag) {
        options.startDrag();
      }
      self.isDown = true;
      return cancelEvent(event);
    }
    this.mouseDown = down;


    function keydown(event) {
      var key = event.keyCode;
      switch (key) {
        case 40:  self.obj.scrollTop += 20; break;
        case 38:  self.obj.scrollTop -= 20; break;
        case 34:  self.obj.scrollTop += self.scrollHeight; break;
        case 33:  self.obj.scrollTop -= self.scrollHeight; break;
        default: return true;
      }
      self.update(true);
      return cancelEvent(event);
    }

    addEvent(obj, 'mousewheel', this.wheel.bind(this));
    addEvent(w, 'DOMMouseScroll', this.wheel.bind(this));

    addEvent(this.scrollbar, 'mouseover', this.contOver.bind(this));
    addEvent(this.scrollbar, 'mouseout', this.contOut.bind(this));
    addEvent(this.scrollbar, 'mousedown', this.contDown.bind(this));

    if (browser.safari_mobile) {
      addEvent(obj, 'touchstart', function(event) {
        cur.touchY  = event.touches[0].pageY;
        //return cancelEvent(event);
      });
      addEvent(obj, 'touchmove', function(event) {
        var touchY = event.touches[0].pageY;
        cur.touchDiff = cur.touchY - touchY;
        obj.scrollTop += cur.touchDiff;
        cur.touchY = touchY;

        if (obj.scrollTop > 0 && self.shown !== false) {
          self.update(true);
          return cancelEvent(event);
        }
      });
      addEvent(obj, 'touchend', function() {
        cur.animateInt = setInterval(function() {
          cur.touchDiff = cur.touchDiff * 0.9;
          if (cur.touchDiff < 1 && cur.touchDiff > -1) {
            clearInterval(cur.animateInt);
          } else {
            obj.scrollTop += cur.touchDiff;
            self.update(true);
          }
        }, 0);
      })
    }

    addEvent(this.inner, 'mousedown', down);
    addEvent(w, 'keydown', keydown);

    if (this.contHeight() <= this.scrollHeight) {
      hide(this.bottomShadowDiv);
    } else {
      this.bottomShadow = true;
    }
    this.inited = true;
    this.update(true);
  }).bind(this), 0);
}

Scrollbar.prototype.contOver = function() {
  this.isOut = false;
  addClass(this.scrollbar, 'scrollbar_c_overed');
}
Scrollbar.prototype.contOut = function() {
  this.isOut = true;
  if (this.isDown) return;
  removeClass(this.scrollbar, 'scrollbar_c_overed');
}
Scrollbar.prototype.contDown = function(ev) {
  var y = ev.offsetY - this.innerHeight / 2 + 5;// - this.innerHeight;
  var scrH = this.scrollHeight - this.innerHeight;

  var newScroll = Math.floor((this.contHeight() - this.scrollHeight) * Math.min(1, y / scrH));
  this.obj.scrollTop = newScroll;
  this.update(true);
  this.mouseDown(ev);
}

w.Scrollbar.prototype._mouseMove = function(event) {
  this.obj.scrollTop = Math.floor((this.contHeight() - this.scrollHeight) * Math.min(1, (event.screenY - this.moveY) / (this.scrollHeight - 26)));
  this.update(true);
  return false;
}

w.Scrollbar.prototype._mouseUp = function(event) {
  this.moveY = false;
  this.isDown = false;
  if (this.isOut) {
    this.contOut();
  }
  removeEvent(w.document, 'mousemove', this.mouseMove);
  removeEvent(w.document, 'mouseup', this.mouseUp);
  w.document.body.style.cursor = 'default';
  removeClass(this.inner, 'scrollbar_hovered');
  if (this.options.stopDrag) {
    this.options.stopDrag();
  }
  return false;
}

w.Scrollbar.prototype.wheel = function(event) {
  if (!event) event = window.event;
  var delta = 0;
  if (event.wheelDeltaY || event.wheelDelta) {
    delta = (event.wheelDeltaY || event.wheelDelta) / 2;
  } else if (event.detail) {
    delta = -event.detail * 10
  }
  var stWas = this.obj.scrollTop;
  this.obj.scrollTop -= delta;
  if (stWas != this.obj.scrollTop && this.shown !== false) {
    this.update(true);
    return false;
  }
}

w.Scrollbar.prototype.contHeight = function() {
  if (this.contHashCash) {
    return this.contHashCash;
  }
  var nodes = this.obj.childNodes;
  var height = 0;
  var i = nodes.length;
  while (i--) {
    height += nodes[i].offsetHeight || 0;
  }
  this.contHashCash = height;
  return height;
}

w.Scrollbar.prototype.update = function(noChange, updateScroll) {
  if (!this.inited) {
    return;
  }
  if (!noChange) {
    this.contHashCash = false;
    if (this.moveY) {
      return true;
    }
  }
  if (updateScroll) {
    var size = getSize(this.obj);
    this.scrollHeight = size[1];
  }

  var height = this.contHeight();
  if (height <= this.scrollHeight) {
    hide(this.inner);
    this.shown = false;
    return;
  } else if (!this.shown) {
    show(this.inner);
    this.shown = true;
  }
  var progress = Math.min(1, this.obj.scrollTop / (height - this.scrollHeight));
  if (progress > 0 != this.topShadow && this.topShadowDiv) {
    (this.topShadow ? hide : show)(this.topShadowDiv);
    this.topShadow = !this.topShadow;
  }
  if (progress < 1 != this.bottomShadow && this.bottomShadowDiv) {
    (this.bottomShadow ? hide : show)(this.bottomShadowDiv);
    this.bottomShadow = !this.bottomShadow;
  }
  this.innerHeight = Math.max(40, Math.floor(this.scrollHeight * this.scrollHeight / height));
  this.inner.style.height = this.innerHeight + 'px';
  if (height - this.obj.scrollTop < this.scrollHeight * 2) {
    this.options.more();
  }
  this.inner.style.marginTop = Math.floor((this.scrollHeight - this.innerHeight - 4) * progress + 2) + 'px';
  // console.log(this.scrollHeight, height, progress);
}
})(window);
// Tiny Scrollbars end

/* Inline video from common.js */
window._videoLastInlined = false;
function showInlineVideo(videoId, listId, options, ev, thumb) {
  if (checkEvent(ev)) return true;

  if (window.mvcur && mvcur.mvShown) {
    return showVideo(videoId, listId, options, ev);
  }

  options = options || {};
  options.params = options.params || {act: 'show_inline', video: videoId, list: listId, autoplay: (options.autoplay) ? 1 : 0, module: options.module || cur.module || '_acm'};
  var h = thumb.clientHeight,
    w = thumb.clientWidth,
    btn = geByClass1('video_play_inline', thumb, 'div');

  if (!trim(options.params.module) && window.nav) {
    extend(options.params, { _nol: JSON.stringify(nav.objLoc) });
  }

  extend(options.params, {width: w, height: h});
  options.onDone = function (title, html, js, opts) {
    revertLastInlineVideo();
    hide(thumb);
    var videoWrap = ce('div', {id: 'page_video_inline_wrap' + videoId, className: 'page_video_inline_wrap', innerHTML: html}, {width: w, height: h}),
      videoBg = ge('video_background' + videoId);
    _videoLastInlined = [videoWrap, thumb]
    thumb.parentNode.appendChild(videoWrap);
    videoBg && setStyle(geByTag1('img', videoBg), {width: w, height: h});
    try {
      eval('(function () {' + js + '})();');
    } catch (e) {
      debugLog('video inline error', e.message, e.stack, e, js);
    }
    var _n = window.Notifier, _a = window.audioPlayer;
    if (_n) setTimeout(function() { _n.lcSend('video_start'); }, 0);
    if (_a && _a.player && !_a.player.paused()) {
      _a.pauseTrack();
      _a.pausedByVideo = 1;
    }
  };
  options.showProgress = function () {
    addClass(btn, 'video_play_inline_loading');
  };
  options.hideProgress = function () {
    removeClass(btn, 'video_play_inline_loading');
  };
  ajax.post('al_video.php', options.params, options);
  return false;
}

function revertLastInlineVideo() {
  if (!window._videoLastInlined) {
    return;
  }
  re(_videoLastInlined[0]);
  show(_videoLastInlined[1]);
  _videoLastInlined = false;
}

