var addLink = function(list, label, site, page) {
    var url = '//';
    if (site == 'wikidata') {
        url += 'www.' + site;
    } else if (site == 'commons') {
        url += site + '.wikimedia';
    }
    url += '.org/wiki/' + mw.util.wikiUrlencode(page);
    $('<li>')
      .addClass('wb-otherproject-link wb-otherproject-' + site)
      .append(
          $('<a>').attr({
            href: url,
            title: label + ': ' + page
          }).text(label)
      )
      .appendTo(list);
};

var addRelatedSites = function() {
    if (mw.config.get('wgWikibaseItemId') === null ||
        mw.config.get('wgAction') !== 'view' ||
        mw.config.get('wgNamespaceNumber') % 2
    ) {
        return;
    }

    var p_lang = $('#p-lang');
    if (!p_lang.length) {
        return;
    }

    $.ajax({
        url: '//www.wikidata.org/w/api.php',
        data: {
            'format': 'json',
            'action': 'wbgetentities',
            'props': 'claims',
            'ids': mw.config.get('wgWikibaseItemId')
        },
        dataType: 'jsonp'
    }).done(function (data) {
        if (data.success) {
            for (var i in data.entities) {
                if (i == -1) {
                    return;
                }
                var p_rs = $('#p-wikibase-otherprojects'),
                    p_rs_list = p_rs.find('ul');
                if (!p_rs.length) {
                    p_rs = p_lang.clone().attr('id', 'p-wikibase-otherprojects');
                    p_rs_list = p_rs.find('ul').empty();
                    p_rs.find('div.after-portlet-lang').remove();
    
                    if (mw.user.options.get('skin') === 'vector') {
                        // Vector
                        p_rs.attr('aria-labelledby', 'p-wikibase-otherprojects-label');
                        p_rs_list.attr('id', 'p-wikibase-otherprojects-list');
                        p_rs.find('h3').attr('id', 'p-wikibase-otherprojects-label').text('В других проектах');
                        var p_lang_label = p_lang.find('h3');
                        if (p_lang_label.attr('tabindex')) {
                            var tabindex = parseInt(p_lang_label.attr('tabindex'), 10) + 1;
                            p_lang_label.attr('tabindex', tabindex);
                        }
                    } else {
                        // Monobook & Modern
                        p_rs.find('h3').text('В других проектах');
                        if (!p_rs.find('div.pBody').length) {
                            $('<div>')
                                .addClass('pBody')
                                .append('<ul>')
                                .appendTo(p_rs);
                            p_rs_list = p_rs.find('ul');
                        }
                    }
                }

                var claims = data.entities[i].claims;
                if (claims && claims.P373 && claims.P373[0] &&
                    claims.P373[0].mainsnak.datavalue
                ) {
                    var cat_name = claims.P373[0].mainsnak.datavalue.value;
                    p_rs_list.find('.wb-otherproject-commons').remove();
                    addLink(p_rs_list, 'Викисклад', 'commons', 'Category:' + cat_name);
                }

                var links = data.entities[i].sitelinks;
                addLink(p_rs_list, 'Викиданные', 'wikidata', mw.config.get('wgWikibaseItemId'));
                $('#t-wikibase').hide();

                if (p_rs_list.children().length) {
                    p_rs.insertBefore(p_lang);
                }
            }
        }
    });
};

$.when(
  $.ready,
  mw.loader.using('mediawiki.util')
).done(addRelatedSites);