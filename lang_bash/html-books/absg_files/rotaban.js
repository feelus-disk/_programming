var _rotaban = {
    apiurl: 'http:\/\/' + (Math.random() < 0 ? 's1' : 's3') + '.rotaban.ru\/s\/',
    dz: [],
    dii: [],
    drop: function (a, b) {
        this.dii[b] = this.dii[b] || 0;
        var l = 'rotaban_' + b + (++this.dii[b] === 1 ? '' : '_' + this.dii[b]);
        document.write('<div id="' + l + '" class="rotaban_' + b + ' rotaban"></div>');
        this.idrop(l, a, b)
    },
    idrop: function (i, a, b) {
        this.dz[b] = this.dz[b] || [];
        this.dz[b].push(i);
        if (!document.getElementById('_rotaban_js_' + a)) {
            var c = document.createElement('script'),
                d = new Date();
            c.type = 'text/javascript';
            c.id = '_rotaban_js_' + a;
            c.src = this.apiurl + a + '.js?v=' + d.getTime();
            c.setAttribute('async', 'async');
            document.getElementsByTagName('head')[0].appendChild(c)
        }
        else
            if (this.jz)
                this.deploy()
    },
    exec: function () {
        this.callback = typeof (RBCallback) === 'function' ? RBCallback : function () { };
        for (var cl = function (cl) {
            for (var n = !!document.getElementsByClassName, ret = [], els = n ? document.getElementsByClassName(cl) : document.getElementsByTagName('*'), p = n ? false : new RegExp('(^|\\s)' + cl + '(\\s|$)'), i = 0; i < els.length; i++)
                if (!p || p.test(els[i].className))
                    ret.push(els[i]);
            return ret
        }, bs = cl('rbrocks'), id, pk, p = /rotaban_([a-f0-9]+)/i, i = 0; i < bs.length && (id = bs[i].getAttribute('id')) && (rid = id.split('_')[1]) && (pk = bs[i].getAttribute('rel') || ((pk = p.exec(bs[i].className)) ? pk[1] : '')) && (bs[i].className = 'rotaban_' + rid + ' rotaban'); i++)
            this.idrop(id, pk, rid)
    },
    deploy: function () {
        for (var zi = 0, wi, z, a, b, db; zi < this.jz.length && (z = this.jz[zi]) && (wi = 1); zi++)
            while (++wi < 10 && (db = this.dz[z.id]) && (a = db.pop()) && (b = document.getElementById(a)) && !b.innerHTML.replace(/(^(\s|&nbsp;)+)|((\s|&nbsp;)+$)/g, "").length)
                new this.zone(b, z, this)
    },
    zone: function (b, z, rb) {
        var zf = [], zs = z.filters, i, f = ['all'];
        for (i = 0; zs && i < f.length; i++)
            zf = zf.concat(typeof zs[f[i].toLowerCase()] == 'object' ? zs[f[i].toLowerCase()].ads : []);
        zf = !zf.length ? (zs.all || z) : { ads: zf };
        var c = (!zf || !zf.ads || !zf.ads.length) ? [] : rb.getads(zf, z.nads),
            e = c[0],
            t = '',
            o = '',
            a,
            css = function (x) {
                var el = document.createElement('style');
                el.type = 'text/css';
                el.styleSheet ? (el.styleSheet.cssText = x) : el.appendChild(document.createTextNode(x));
                document.getElementsByTagName('head')[0].appendChild(el)
            };

        css(rb.getCss(rb, z));

        if (c.length > 0) {
            var min = (z.nads < c.length ? z.nads : c.length);
            for (i = 0; i < min; i++) {
                a = rb.getads(c[i], 1)[0];
                o += rb.getObj(rb, z, a, i + 1);
                t += a.id + ';'
            }
        }

        if (((c.length == 0) || (c.length < z.nads)) && z.showadhere) {
            var NumAdHeres = (z.repeatadhere == false ? 1 : z.nads - c.length);
            for (i = 0; i < NumAdHeres; i++) {
                o += '<a href="http:\/\/www.rotaban.ru\/buy\/site\/?' + z.siteurl + '" title="' + z.buyadvertising + '" class="rb_adhere"';
                if (z.batype == 1) { /* показывает нашу картинку как предустановленный бэкграунд */
                    o += ' style="background-image: url(' + z.bapreurl + ');background-repeat: no-repeat;"';
                }
                o += ' target="_blank">';

                if (z.batype == 2) { /* показываем пользовательскую картинку вместо заглушки */
                    o += '<img src="' + z.baurl + '" alt="' + z.buyadvertising + '" width="' + z.width + '" height="' + z.height + '" border="0" />';
                }
                else
                    o += z.buyadvertising;

                o += '</a>';
            }
        }

        if (z.batype == 3 && c.length == 0) { /* выводим html код вместо заглушки */
            if (z.bacodeurl != '')
                o = '<iframe width="' + z.bawidth + '" height="' + z.baheight + '" src="' + z.bacodeurl + '?r=' + Math.random() +
                '" frameborder="0" hspace="0" vspace="0" marginheight="0" marginwidth="0" scrolling="no" allowtransparency="true" style="left:0;top:0;"></iframe>';
            else
                o = z.bacode;
        }
        else {
            if (z.batype == 4 && c.length > 0) { /* делаем невидимым пользовательский элемент */
                try {
                    var el = document.getElementById(z.baelement);
                    if (el == null)
                        o = 'Rotaban Script Error: Can\'t find element \'' + z.baelement + '\'.';
                    el.style.display = 'none';
                    el.style.visibility = 'hidden';
                }
                catch (err) { }
            }
        }

        b.innerHTML = o;
        _rotaban.rocks('imp', t, z.id)
    },
    getCss: function (rb, z) {
        var bs = z.bannerstyles,
            w = z.width,
            h = z.height,
            nw = w - 2,
            nh = h - 2,
            sc = '';

        sc += 'div.rotaban_' + z.id + '{width:' + (z.vertical == true ? w + 'px' : '100%') + ';display:' + (z.vertical == true ? 'inline-' : '') + 'block;}';
        sc += 'div.rotaban_' + z.id + ' a{width:' + w + 'px;}';
        sc += 'div.rotaban_' + z.id + ' a img{padding:0;}';
        sc += 'div.rotaban_' + z.id + ' a em{font-style:normal;}';

        if (z.batype == 1 || z.batype == 2) { /* показывает нашу картинку как предустановленный бэкграунд. Тут дублирование стиля для IE */
            sc += 'div.rotaban_' + z.id + ' a.rb_adhere{width:' + w + 'px;height:' + h + 'px;border:0px solid #999}';
            sc += 'div.rotaban_' + z.id + ' a.rb_adhere:hover{border:0px solid #999}';
            sc += 'div.rotaban_' + z.id + ' img.s{height:0;width:0;}';
        }

        for (i = 0; i < bs.length; i++)
            if (bs[i] != '')
                sc += 'html>body div.rotaban_' + z.id + ' ' + bs[i];

        if (z.vertical == false)
            sc += 'html>body div.rotaban_' + z.id + ' a{display:inline-block;position:relative;vertical-align:top;}';

        if (w < 100) {
            sc += 'div.rotaban_' + z.id + ' a em{display:block;text-indent:-9010px;}';
            sc += 'div.rotaban_' + z.id + ' a{height:' + h + 'px;line-height:0;}';
            sc += 'div.rotaban_' + z.id + ' a.rb_adhere{font-size:0;}';
        }

        sc += 'div.rotaban_' + z.id + ' a.rb_adhere{width:' + w + 'px;height:' + h + 'px;line-height:' + (h * 8) + '%;}';

        if (z.batype == 1 || z.batype == 2) { /* показывает нашу картинку как предустановленный бэкграунд */
            sc += 'div.rotaban_' + z.id + ' a.rb_adhere{width:' + w + 'px;height:' + h + 'px;border:0px solid #999}';
            sc += 'div.rotaban_' + z.id + ' a.rb_adhere:hover{border:0px solid #999} div.rotaban_' + z.id + ' img.s{height:0;width:0;}';
        }
        else {
            sc += 'div.rotaban_' + z.id + ' a.rb_adhere{width:' + nw + 'px;height:' + nh + 'px;border:1px solid #ccc;background:#e7e7e7;color:#444;}';
            sc += 'div.rotaban_' + z.id + ' a.rb_adhere:hover{border:1px solid #999;background:#ddd;color:#222;}';
            sc += 'div.rotaban_' + z.id + ' img.s{height:0;width:0;}';
        }

        return sc;
    },
    getObj: function (rb, z, a, j) {
        if (a.type == "code") {
            if (a.codeurl != '')
                return '<a ' + rb.link(a.id, z.id, a.link) + '><iframe width="' + z.width + '" height="' + z.height + '" src="' + a.codeurl + '?r=' + Math.random() +
                '" frameborder="0" hspace="0" vspace="0" marginheight="0" marginwidth="0" scrolling="no" allowtransparency="true" style="left:0;top:0;"></iframe></a>';
            else
                return '<a ' + rb.link(a.id, z.id, a.link) + '>' + a.code + '</a>';
        }
        return '<a ' + rb.link(a.id, z.id, a.link) + ' class="rb_ad' + j + ' ' + (j % 2 === 0 ? 'even' : 'odd') + '" title="' + a.alt + '" id="rb_' + a.id + '" target="_blank"><img src="' + a.img + '" width="' + z.width + '" height="' + z.height + '" alt="' + a.alt + '"/></a>'
    },
    getads: function (d, n) {
        var b = '', c, a = d.ads, tdiff = 0, ret = [], got = [], i;
        if (!a)
            return [d];
        if (a.length <= n || a.length === 1)
            return this.shuffle(a);
        for (i = 0; i < a.length; i++)
            b += new Array((a[i].per || (a[i].cap - a[i].current)) + 1).join(i + ',');
        b = b.substr(0, b.length - 1).split(',');
        while (ret.length < n && i++ < n * 100 && (c = a[b[Math.floor(Math.random() * b.length)]]))
            if (n === 1)
                return [c];
            else if (!got[c.id]) {
                got[c.id] = 1;
                ret.push(c)
            }
        return ret
    },
    shuffle: function (o) {
        for (var j, x, i = o.length; i; j = parseInt(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
        return o
    },
    interpret_json: function (a) {
        this.jz = typeof this.jz == 'object' ? this.jz.concat(a.zones) : a.zones;
        this.deploy()
    },
    rocks: function (t, b, z) {
        var u = this.gen('_rbu', 30),
            s = this.gen('_rbs', 1 / 2),
            img = new Image();
        img.src = this.tracker(t + '.gif', b, z, u, s, '')
    },
    link: function (b, z, l) {
        return 'href="' + l + '" onclick="_rotaban.rocks(\'click\', \'' + b + '\', \'' + z + '\');"'
    },
    tracker: function (t, b, z, u, s, additional) {
        return 'http:\/\/s1.rotaban.ru\/' + t + '?z=' + z + '&b=' + b + '&g=' + u + '&s=' + s + '&sw=' + screen.width + '&sh=' + screen.height + '&br=' + this.br() + '&r=' + Math.random() + additional
    },
    br: function () {
        var a = navigator.userAgent,
        p = navigator.platform,
        m = function (r, h) {
            for (var i = 0; i < h.length; i++)
                r = r.replace(h[i][0], h[i][1]);
            return r;
        },
        i = (a.match(/Opera|Navigator|Minefield|KHTML|Chrome/) ? m(a, [[/(Firefox|MSIE|KHTML,\slike\sGecko|Konqueror)/, ''], ['Chrome Safari', 'Chrome'], ['Minefield', 'Firefox']]) : a).toLowerCase();
        return [(/(camino|chrome|firefox|opera|msie|safari)/.exec(i) || ['', '?'])[1], parseFloat((/(camino|chrome|firefox|opera|msie|safari)(\/|\s)([a-z0-9\.\+]*?)(\;|dev|rel|\s|$)/.exec(i) || [0, 0, 0, 0])[3], 10) || 0, (/(win|mac|linux|iphone|blackberry|pike)/.exec(p.toLowerCase()) || ['?'])[0]];
    },
    gen: function (w, e) {
        var c = document.cookie, i = c.indexOf(w + '=');
        if (i >= 0)
            return c.substring(i + w.length + 1).split(';')[0];
        else {
            var d = new Date(), nd = +d;
            d.setTime(e * 3600000 + nd);
            document.cookie = w + '=' + (nd + Math.random().toString().substr(2, 7)) + '; expires=' + d.toGMTString() + '; path=/';
            return -1;
        }
    }
};
_rotaban_loadedme = 1;

if (typeof (_rotaban_loadme) === 'object') {
    for (var _bi = 0; _bi < _rotaban_loadme.length; _bi++) {
        _rotaban_loadme[_bi]();
        _rotaban_loadme[_bi] = function () { }
    }
}
if (document.addEventListener)
    document.addEventListener('DOMContentLoaded', function () { _rotaban.exec() }, false);
else
    if ((/msie/.test(navigator.userAgent.toLowerCase())) && window == top) {
        (function () {
            try {
                document.documentElement.doScroll('left')
            }
            catch (error) {
                setTimeout(arguments.callee, 0);
                return
            }
            _rotaban.exec()
        })();
        window.document.onreadystatechange = function () {
            if (window.document.readyState == 'complete') {
                window.document.onreadystatechange = null;
                _rotaban.exec()
            }
        }
    }
oldonload = window.onload;
window.onload = function () {
    _rotaban.exec();
    if (oldonload)
        oldonload()
};
_rotaban.exec();
var _acic = { 'dataProvider': 150 }; (function() { var aci = document.createElement('script'); aci.type = 'text/javascript'; aci.async = true; aci.src = '//www.acint.net/aci.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(aci, s); })();
