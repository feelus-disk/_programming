/*
 * Источник: http://pl.wikipedia.org/wiki/MediaWiki:Wikibugs.js
 * Адаптация под русский: [[User:Александр Сигачёв]], [[User:Putnik]], [[User:LEMeZza]]
 */

window.wb$bugsPage = 'Википедия:Сообщения об ошибках';
window.wb$badPages = [
	'Википедия:Сообщения об ошибках',
	'Заглавная страница'
];

function wb$link( page ) {
	'use strict';
	return window.wgArticlePath.replace( /\$1/, page.replace( / /g, '_' ) );
}

window.wb$i18n = {
	nsFile: 'Файл:',
	nsSpecial: 'Служебная:',
	nsCat: 'Категория:',
	btnFix: 'Исправить самостоятельно',
	btnReport: 'Сообщить об ошибке',
	btnCancel: 'Отмена',
	btnSend: 'Отправить',
	fldPage: 'Название страницы:',
	fldText: 'Текст сообщения:',
	fldTextInfo: 'Пожалуйста, опишите ошибку как можно точнее. При сообщении\
		о\u00A0фактической ошибке не забудьте указать источник, подтверждающий\
		вашу информацию.',
	fldCaptcha: 'Проверочный код:',
	fldSign: 'Подпись:',
	alertShort: 'Описание ошибки слишком коротко. Пожалуйста, расширьте его.',
	alertNoPage: 'Введите имя страницы.',
	alertCaptcha: 'В вашем тексте содержатся внешние ссылки. Пожалуйста,\
		введите код с изображения и отправьте сообщение ещё раз.',
	alertError: 'При отправке произошла ошибка. Попробуйте ещё раз.',
	msgSign: '\n\nАвтор сообщения:',
	newTopic: 'новая тема',
	htmlIpWarn: '<strong>Внимание.</strong> Ваш IP-адрес будет записан в журнал\
		изменений страницы.',
	htmlInfo: '<div style="float:right;width:200px;padding:4px 10px;\
		margin:2px 0px 0px 10px;font-size:90%;border:2px solid #a6170f;\
		border-radius:3px">\
		<p><strong>Не\u00A0сообщайте</strong> об\u00A0ошибках на\u00A0других\
			сайтах (например, <strong>«В\u00A0Контакте»</strong> или\
			<strong>«Одноклассники»</strong>), они будут проигнорированы.</p>\
		<p>Отсутствие статьи в\u00A0Википедии\u00A0— не\u00A0ошибка, вы можете оставить\
			<a href="' + wb$link( 'Википедия:К созданию' ) + '">запрос на её создание</a>.</p>\
		</div>\
		<p style="margin-top:0px">Если вы заметили ошибку в\u00A0Википедии,\
			пожалуйста, исправьте её самостоятельно, используемая на\u00A0этом\
			сайте технология <a href="' + wb$link( 'вики' ) + '">вики</a>\
			позволяет это сделать.\
			Не\u00A0смущайтесь, одно из\u00A0правил Википедии гласит:\
			«<a href="' + wb$link( 'Википедия:Правьте смело' ) + '">Правьте смело</a>»!\
			Если вы не\u00A0можете исправить ошибку самостоятельно, сообщите\
			о\u00A0ней с\u00A0помощью данной формы.</p><p><strong>Если ошибка\
			уже исправлена\u00A0— не\u00A0сообщайте о\u00A0ней.</strong></p>\
		<p>Не\u00A0оставляйте свой телефон и/или электронный адрес, ответ\
			на\u00A0сообщение будет дан только на\u00A0странице\
			с\u00A0сообщениями и нигде больше.</p>\
		<ul><li><a href="' + wb$link( window.wb$bugsPage ) + '">Текущий\
			список сообщений об ошибках.</a></li></ul>'
};

function wb$isValidPageName(name) {
	'use strict';
	if ( !name || name.substr( 0, name.indexOf( ':' ) + 1 ) === window.wb$i18n.nsSpecial ) {
		return false;
	}
	name = name.replace( /_/g, ' ' );
	for ( var i = 0; i < window.wb$badPages.length; i++ ) {
		if ( name === window.wb$badPages[i] ) {
			return false;
		}
	}

	return true;
}

function wb$popWikibug() {
	'use strict';
	var i18n = window.wb$i18n;

	// Background
	var $nel = $( '<div id="wikibugs-globhidden">' );
	$nel.css( {
		'background': '#000',
		'filter': 'alpha(opacity=75)',
		'opacity': '0.75',
		'position': 'absolute',
		'left': '0',
		'top': '0',
		'z-index': '2000',
		'width': document.documentElement.scrollWidth + 'px',
		'height': document.documentElement.scrollHeight + 'px'
	} );
	$( 'body' ).append( $nel );

	// Scroll to top 
	window.scroll( 0, 150 );

	// Info popup
	var canEdit = false,
		$editA = $( '#ca-edit a' );
	if ( $editA.length ) {
		canEdit = true;
	}

	$nel = $( '<div id="wikibugs-info">' );
	$nel.css( {
		'font-size': '13px',
		'background': 'white',
		'padding': '21px 30px',
		'border': '1px solid #2f6fab',
		'border-radius': '3px',
		'position': 'absolute',
		'min-height': '300px',
		'width': '500px',
		'margin-left': '-250px',
		'top': '200px',
		'left': '50%',
		'z-index': '2002'
	} );
	var infoHTML = i18n.htmlInfo;
	if ( !window.wgUserName ) {
		infoHTML += '<p>' + i18n.htmlIpWarn + '</p>';
	}
	infoHTML += '<p style="margin-top:15px">\
		<input type="button" class="wikibugs-cancel mw-ui-button"\
			style="float:right;color:#555;border-color:#aaa"\
			value="' + i18n.btnCancel + '" />\
		' + ( canEdit ? '<input id="wikibugs-edit" type="button"\
			class="mw-ui-button mw-ui-primary" style="margin:0 5px 5px 0"\
			value="' + i18n.btnFix + '" />' : '' ) + '\
		<input id="wikibugs-report" type="button" class="mw-ui-button mw-ui-primary"\
			style="margin:0 0 5px" value="' + i18n.btnReport + '" />\
		</p>';
	$nel.html( infoHTML );
	$( 'body' ).append( $nel );

	// Go to report form
	$( '#wikibugs-report' ).on( 'click', function() {
		$( '#wikibugs-info' ).hide();
		$( '#wikibugs-form' ).show();
	} );

	// Go to edit page
	$( '#wikibugs-edit' ).on( 'click', function ( e ) {
		e.preventDefault();
		var $editA = $( '#ca-edit a' ),
			editHref = window.wgArticlePath.replace( /\$1/, window.wb$bugsPage );
		if ( $editA.length ) {
			editHref = $editA.attr( 'href' );
		}
		window.location.assign( editHref );
	} );

	// Popup with report form
	$nel = $( '<div id="wikibugs-form">' );
	$nel.css( {
		'display': 'none',
		'background': 'white',
		'padding': '15px 20px',
		'border': '1px solid #2f6fab',
		'border-radius': '3px',
		'position': 'absolute',
		'min-height': '300px',
		'width': '330px',
		'margin-left': '-165px',
		'top': '200px',
		'left': '50%',
		'z-index': '2001'
	} );
	$nel.html( '<form id="wikibugs-form" class="mw-ui-vform" style="width:330px">\
		<div>' + i18n.fldPage + '\
			<input id="wikibugs-page" type="text" class="mw-ui-input" />\
		</div>\
		<div>' + i18n.fldText + '\
			<textarea id="wikibugs-text" class="mw-ui-input"\
				style="width:100%;height:200px"\
				placeholder="' + i18n.fldTextInfo + '"></textarea>\
		</div>\
		<div id="wikibugs-captcha" style="display:none">' + i18n.fldCaptcha + '\
			<input id="wikibugs-captcha-id" type="hidden" />\
			<input id="wikibugs-captcha-word" type="text" class="mw-ui-input" />\
			<img src="" width="249" height="63" />\
		</div>\
		<div>' + i18n.fldSign + '\
			<input id="wikibugs-sign" type="text" class="mw-ui-input" />\
		</div>\
		<input type="button" class="wikibugs-cancel mw-ui-button"\
			style="float:right;width:100px;color:#555;border-color:#aaa"\
			value="' + i18n.btnCancel + '" />\
		<input id="wikibugs-submit" type="submit" class="mw-ui-button mw-ui-primary"\
			style="width:220px;margin-top:1px" value="' + i18n.btnSend + '" />\
		</form>' );
	$( 'body' ).append( $nel );

	// Send message
	$nel.on( 'submit', function ( e ) {
		e.preventDefault();

		var content = $( '#wikibugs-text' ).val();
		if ( content === '' || content.length < 20 || !content.match( ' ' ) ) {
			mw.notify( i18n.alertShort );
			$( '#wikibugs-text' ).focus();
			return;
		}

		var page = $( '#wikibugs-page' ).val()
				.replace( /^https?:\/\/ru\.wikipedia\.org\/wiki\/(.+)$/, '$1' )
				.replace( /_/g, ' ' );
		page = decodeURIComponent( page );

		var section;

		if ( page === window.wgPageName.replace( /_/g, ' ' ) &&
			wb$isValidPageName( window.wgPageName )
		) {
			if ( window.wgNamespaceNumber === 6 ) {
				section = '[[:' + i18n.nsFile + window.wgTitle + '|' + window.wgTitle + ']]';
				content = '[[' + i18n.nsFile + window.wgTitle +
						'|thumb|left|100px]]\n* ' + content + '\n{{clear}}';
			} else {
				var re = new RegExp( '^('+ i18n.nsCat + '|'+ i18n.nsFile + '|\\/)' );
				section = page.replace( re, ':$1' );
				section = '[[' + section + ']]';
			}
		} else {
			page = page
				.replace( /\[\[([^\[\]\|]+)\|[^\[\]\|]+\]\]/g, '$1' )
				.replace( /[\[\]\|]/g, '' )
				.replace( /^\s+/g, '' )
				.replace( /\s+$/g, '' );

			if ( !wb$isValidPageName( page ) ) {
				mw.notify( i18n.alertNoPage );
				if ( wb$isValidPageName( window.wgPageName ) ) {
					$( '#wikibugs-page' ).val( window.wgPageName );
				} else {
					$( '#wikibugs-page' )
						.val( '' )
						.focus();
				}
				return;
			}
			if ( page.indexOf( ':' ) > 0 ) {
				section = '[[:' + page + ']]';
			} else {
				section = '[[' + page + ']]';
			}
		}

		content += i18n.msgSign;
		if ( !window.wgUserName ) {
			content += ' ' + $( '#wikibugs-sign' ).val().trim();
		}
		content += ' ~~' + '~~';

		$( '#wikibugs-submit' ).prop( 'disabled', true );

		var data = {
			format: 'json',
			action: 'edit',
			title: window.wb$bugsPage,
			section: 'new',
			sectiontitle: section,
			summary: '/* ' + page + ' */ ' + i18n.newTopic,
			text: content.trim(),
			token: mw.user.tokens.values.editToken
		};
		var captchaId = $( '#wikibugs-captcha-id' ).val();
		if ( captchaId ) {
			data.captchaid = captchaId;
			data.captchaword = $( '#wikibugs-captcha-word' ).val().trim();
		}

		$.ajax( {
			url: '/w/api.php',
			type: 'POST',
			data: data,
			success: function ( xhr ) {
				if ( xhr && xhr.edit && xhr.edit.result === 'Success' ) {
					// Success
					var url = window.wgArticlePath
							.replace( /\$1/, window.wb$bugsPage )
							.replace( / /g, '_' );
					window.location.href = url + '#' + page;
				} else if ( xhr &&
					xhr.edit &&
					xhr.edit.captcha &&
					xhr.edit.captcha.type === 'image'
				) {
					// Captcha
					$( '#wikibugs-captcha img' ).attr( 'src', xhr.edit.captcha.url );
					$( '#wikibugs-captcha-id' ).val( xhr.edit.captcha.id );
					$( '#wikibugs-captcha-word' ).val( '' );
					$( '#wikibugs-captcha' ).show();
					$( '#wikibugs-submit' ).prop( 'disabled', false );
					mw.notify( i18n.alertCaptcha );
				} else {
					// Error
					$( '#wikibugs-submit' ).prop( 'disabled', false );
					mw.notify( i18n.alertError );
				}
			},
			error: function() {
				$( '#wikibugs-submit' ).prop( 'disabled', false );
				mw.notify( i18n.alertError );
			}
		} );
	} );

	// Cancel
	$( '.wikibugs-cancel' ).on( 'click', function ( e ) {
		e.preventDefault();
		$( '#wikibugs-info, #wikibugs-form, #wikibugs-globhidden' ).remove();
	} );

	$( '#wikibugs-page' ).val( window.wgPageName.replace( /_/g, ' ' ) );

	// Disable title changes for main namespace
	if ( wb$isValidPageName( window.wgPageName ) && !window.wgNamespaceNumber ) {
		$( '#wikibugs-page' )
			.prop( 'disabled', true )
			.css( 'background', '#eee' );
	}

	if ( window.wgUserName ) {
		$( '#wikibugs-sign' )
			.val( '~~' + '~~' )
			.prop( 'disabled', true )
			.css( 'background', '#eee' );
	}
}

$( function() {
	'use strict';
	$( '#n-bug_in_article a' ).click( function ( e ) {
		e.preventDefault();
		mw.loader.using( 'mediawiki.ui', wb$popWikibug );
	} );
} );