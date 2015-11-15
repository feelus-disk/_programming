hotlog_r = "" + Math.random() + "&amp;s=" + hotlog_counter_id + "&amp;im=" + hotlog_counter_type + "&amp;r=" +
    escape(document.referrer) + "&amp;pg=" + escape(window.location.href);

hotlog_r += "&amp;j=" + (navigator.javaEnabled() ? "Y":"N");

hotlog_r += "&amp;wh=" + screen.width + "x" + screen.height + "&amp;px=" +
    (((navigator.appName.substring(0,3)=="Mic")) ? screen.colorDepth:screen.pixelDepth);

hotlog_idata = "";
if (typeof hotlog_image_width !== 'undefined') {
    hotlog_idata += ' width="' + hotlog_image_width + '"';
}
if (typeof hotlog_image_height !== 'undefined') {
    hotlog_idata += ' height="' + hotlog_image_height + '"';
}

if (typeof hotlog_counter_extra === 'undefined') {
    hotlog_counter_extra = "cver=1"; 
}
else {
    hotlog_counter_extra = hotlog_counter_extra + "&amp;cver=1";
}
if(hotlog_counter_extra)
    hotlog_r += "&amp;" + hotlog_counter_extra;

hotlog_r+="&amp;js=1.3";

var hdiv = document.getElementById("hotlog_counter");

if(!hdiv) {
    document.write('<a href="http://click.hotlog.ru/?' + hotlog_counter_id + '" target="_blank"><img ' +
        'src="http://hit' + hotlog_hit + '.hotlog.ru/cgi-bin/hotlog/count?' + hotlog_r + 
        '" class="hotlog_counter" border="0" alt="HotLog" title="HotLog"' + hotlog_idata + '"><\/a>');
}
else {
    hdiv.innerHTML = '<a href="http://click.hotlog.ru/?' + hotlog_counter_id + '" target="_blank"><img ' +
        'src="http://hit' + hotlog_hit + '.hotlog.ru/cgi-bin/hotlog/count?' + hotlog_r + 
        '" class="hotlog_counter" border="0" alt="HotLog" title="HotLog"' + hotlog_idata + '"><\/a>';
}
