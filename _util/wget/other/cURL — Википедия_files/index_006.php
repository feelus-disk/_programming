//===========================================================================
// Выделить ссылки на страницы разрешения неоднозначностей классом CSS 'bkl-link',
// как в нормальном виде статьи, так и в предпросмотре
//===========================================================================
// v5

var bklCheck = {
	tpl : [
		'Неоднозначность',
                'Неоднозначность2'
	],

	className   : 'bkl-link',
	titleAppend : ' (страница разрешения неоднозначности)',

	queryUrlView      : mw.config.get('wgScriptPath') + '/api.php?action=query&format=json'
		+ '&prop=templates&pageids=' + mw.config.get('wgArticleId') + '&callback=bklCheck.viewResultArrived'
		+ '&generator=links&redirects&gpllimit=max&gplnamespace=0&tllimit=max&indexpageids'
		+ '&nocache=' + mw.config.get('wgCurRevisionId'), //Break client caching, when page has been edited
	queryUrlPreview   : mw.config.get('wgScriptPath') + '/api.php?action=query&format=json&prop=templates'
		+ '&tllimit=max&redirects&indexpageids',
	titles            : {},
	count             : 0,
	previewQueryCount : 0,

	execute : function () {
		if ( !window.bklEnableInAllNamespaces && !(/^(0|6|10|14|100|102)$/.test( mw.config.get('wgNamespaceNumber') )) ) return;
		//Use &tltemplates to reduce needed queries
		var tpls = [];
		for ( var t in bklCheck.tpl )
			tpls.push( encodeURIComponent( 'Шаблон:' + bklCheck.tpl[t] ) );
		bklCheck.queryUrlView += '&tltemplates=' + tpls.join( '|' );
		bklCheck.queryUrlPreview += '&tltemplates=' + tpls.join( '|' );
		if ( mw.config.get('wgAction') == 'submit' )	bklCheck.doPreviewQueries();
		else if ( mw.config.get('wgAction') == 'view' || mw.config.get('wgAction') == 'historysubmit' || mw.config.get('wgAction') == 'purge' )
			importScriptURI( bklCheck.queryUrlView );
		else {//"Show preview on first edit" enabled?
			var prev = document.getElementById( 'wikiPreview' );
			if ( prev && prev.firstChild ) importScriptURI( bklCheck.queryUrlView );
		}
		//Make sure that our style is put before other css so users can override it easily
		//var head = document.getElementsByTagName( 'head' )[0];
		//head.insertBefore( appendCSS( '.bkl-link {background-color: #FFDADA; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 2px}' ), head.firstChild );
		mw.util.addCSS('.bkl-link {background-color: #FFDADA; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 2px}');
	},

	storeTitles : function ( res ) {
		if ( !res || !res.query || !res.query.pageids ) return;
		var q = res.query;
		var redirects = {};
		for ( var i = 0; q.redirects && i < q.redirects.length; i++ ) {
			var r = q.redirects[i];
			if ( !redirects[r.to] ) redirects[r.to] = [];
			redirects[r.to].push( r.from );
		}
		for ( var i = 0; i < q.pageids.length; i++ ) {
			var page = q.pages[q.pageids[i]];
			if ( page.missing === '' || page.ns !== 0 || !page.templates ) continue;
			for ( var j = 0; j < page.templates.length; j++ ) {
				var tpl = page.templates[j].title;
				if ( !tpl ) continue;
				bklCheck.count++;
				bklCheck.titles[page.title] = tpl;
				if ( !redirects[page.title] ) break;
				for ( var k = 0; k < redirects[page.title].length; k++ )
					bklCheck.titles[redirects[page.title][k]] = tpl;
				break;
			}
		}
	},

	markLinks : function () {
		if ( !bklCheck.count ) return;
		var links = bklCheck.getLinks( 'wikiPreview' ) || bklCheck.getLinks( 'bodyContent' )
				|| bklCheck.getLinks( 'mw_contentholder' ) || bklCheck.getLinks( 'article' );
		if ( !links ) return;
		for ( var i = 0; i < links.length; i++ ) {
			// Do not mess with images and user-specified objects
			if ( /(image|skipitpls123)/.test( links[i].className) ) {
				continue;
			}

			var tpl = bklCheck.titles[links[i].title];
			if ( !tpl ) continue;
			links[i].innerHTML = '<span class="' + bklCheck.className + '" title="' + links[i].title
					+ bklCheck.titleAppend + '">' + links[i].innerHTML + '</span>';
		}
	},

	viewResultArrived : function ( res ) {
		bklCheck.storeTitles( res );
		if ( res && res['query-continue'] ) {
			var c = res['query-continue'];
			if ( c.templates ) {
				importScriptURI( bklCheck.queryUrlView + '&tlcontinue='
					+ encodeURIComponent( c.templates.tlcontinue ) );
			} else if ( c.links ) {
				bklCheck.queryUrlView = bklCheck.queryUrlView.replace( /&gplcontinue=.*|$/,
					'&gplcontinue=' + encodeURIComponent( c.links.gplcontinue ) );
				importScriptURI( bklCheck.queryUrlView );
			}
		} else bklCheck.markLinks();
	},

	PreviewQuery : function ( titles ) {
		bklCheck.previewQueryCount++;
		//We have to keep the titles in memory in case we get a query-continue
		this.data = 'titles=' + titles.join( '|' );		
		this.doQuery( bklCheck.queryUrlPreview );
	},

	doPreviewQueries : function () {
		var links = bklCheck.getLinks( 'wikiPreview' );
		if ( !links ) return;
		var titles=[]; var m;
		var unique = {};
		var rxEscape = function(s) {return s.replace( /([\/\.\*\+\?\|\(\)\[\]\{\}\\])/g, '\\$1' );};
		var siteRegex = new RegExp( rxEscape( mw.config.get('wgServer') ) + rxEscape( mw.config.get('wgArticlePath').replace( /\$1/, '' ) ) + '([^#]*)' );
		//We only care for main ns pages, so we can filter out the most common cases to save some requests
		var namespaceRegex = /^(MediaWiki|Special|Википедия|Инкубатор|Категория|Портал|Проект|Справка|Участник|Файл|Шаблон|Обсуждение|Обсуждение_(MediaWiki|Википедии|Инкубатора|категории|портала|проекта|справки|участника|файла|шаблона)):/i;
		for ( var i = 0; i < links.length; i++ ) {
			if ( !links[i].title || !( m = links[i].href.match( siteRegex ) )
				|| m[1].match( namespaceRegex ) || unique[m[1]] ) continue;
			unique[m[1]] = true; //Avoid requesting same title multiple times
			titles.push( m[1].replace( /_/g, '%20' ) ); //Avoid normalization of titles
			if ( titles.length < 50 ) continue;
			new bklCheck.PreviewQuery( titles );
			titles=[];
		}
		if ( titles.length ) new bklCheck.PreviewQuery( titles );
	},

	getLinks : function ( id ) {
		var el = document.getElementById( id );
		$( "a", $( "div.dablink, span.dablink" ) ).addClass( "skipitpls123" );
		$( "a", $( "#catlinks" ) ).addClass( "skipitpls123" );
		return el && el.getElementsByTagName( 'a' );
	}
};

bklCheck.PreviewQuery.prototype.doQuery = function ( url ) {
	var q = this;
	var req = sajax_init_object();
	if ( !req ) return;
	req.open( 'POST', url, true );
	req.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
	req.onreadystatechange = function () {
		if ( req.readyState == 4 && req.status == 200 )
			eval( 'q.resultArrived(' + req.responseText + ');' );
	};
	req.send( q.data );
	delete req;
};

bklCheck.PreviewQuery.prototype.resultArrived = function ( res ) {
	bklCheck.storeTitles( res );
	if ( res && res['query-continue'] && res['query-continue'].templates ) {
		this.doQuery( bklCheck.queryUrlPreview + '&tlcontinue='
			+ encodeURIComponent( res['query-continue'].templates.tlcontinue ) );
	} else bklCheck.previewQueryCount--;
	if ( !bklCheck.previewQueryCount ) bklCheck.markLinks();
};

if ( mw.config.get('wgNamespaceNumber') >= 0 &&
    mw.config.get('wgUserName')
) {
    $( bklCheck.execute );
}