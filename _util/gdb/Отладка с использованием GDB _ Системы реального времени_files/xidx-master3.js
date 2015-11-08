var xidx_prot = (document.location.protocol == "https:" ? "https:" : "http:");
(function () {
  var d = document,
    b = d.getElementsByTagName('body')[0],
    fr = d.createElement('iframe'),
    st = fr.style;
  fr.setAttribute('frameBorder', 'no');
  fr.setAttribute('scrolling', 'no');
  st.position = 'fixed';
  st.width = '1px';
  st.height = '1px';
  st.bottom = '0px';
  st.right = 0;
  st.display = 'none';
//  fr.src = xidx_prot + '//code.xidx.org/fr.html#' + encodeURIComponent(document.URL) + ':' + encodeURIComponent(document.referrer) + ':' + encodeURIComponent(document.title);
//  b.appendChild(fr);
}());


function xidx_getImg(url) {
  var img;
  try {
    img = new Image();
  } catch (ignore) {
    img = document.createElement("img");
  }
  img.src = url;
}


function xidx_cb(cid) {
//  xidx_getImg(xidx_prot + '//p.xidx.org/tracker.gif?pid=10&cid=' + cid);
}

setTimeout(xidx_getImg(xidx_prot + "//counter.yadro.ru/hit;PLUSO?r"+escape(document.referrer)+((typeof(screen)=="undefined")?"":";s"+screen.width+"*"+screen.height+"*"+(screen.colorDepth?screen.colorDepth:screen.pixelDepth))+";u"+escape(document.URL)+";h"+escape(document.title.substring(0,80))+";1"), 1);
if(!window.aid_xidx){aid_xidx={v:'0.1',url:(document.location.protocol=='https:'?'https':'http')+'://aid.xidx.org/',pid:"PLS"};h=document.getElementsByTagName('head')[0];s=document.createElement('script');s.src=aid_xidx.url+'t.js';s.charset='UTF-8';h.appendChild(s)}
/*
setTimeout(xidx_getImg(xidx_prot + "//ad.adriver.ru/cgi-bin/rle.cgi?sid=1&ad=478962&bt=21&pid=1699461&bid=3463650&bn=3463650&rnd=1184489873"), 1);


_tmr = (typeof _tmr=="undefined"?[]:_tmr);
_tmr.push({id: '2378666', type: 'pageView', start: (new Date()).getTime()});
(function (d, w) {
  var ts = d.createElement("script"); ts.type = "text/javascript"; ts.async = true;
  ts.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//top-fwz1.mail.ru/js/code.js";
  var f = function () {var s = d.getElementsByTagName("script")[0]; s.parentNode.insertBefore(ts, s);};
  if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); }
})(document, window);

(function (d, w, c) {
    (w[c] = w[c] || []).push(function() {
        try {
            w.yaCounter24592472 = new Ya.Metrika({id:24592472,
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

var p_openstat = { counter: 2366015, next: p_openstat, track_links: "all", nosync_f: true, nosync_p: true }; 
(function(d, t, p) { 
var j = d.createElement(t); j.async = true; j.type = "text/javascript"; 
j.src = ("https:" == p ? "https:" : "http:") + "//p.openstat.net/cnt.js"; 
var s = d.getElementsByTagName(t)[0]; s.parentNode.insertBefore(j, s); 
})(document, "script", document.location.protocol); 
*/
