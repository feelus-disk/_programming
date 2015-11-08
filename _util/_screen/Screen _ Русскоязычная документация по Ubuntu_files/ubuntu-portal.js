/**
 * JavaScript код для ubuntu-portal
 *
 * @license    GPL 3 (http://www.gnu.org/licenses/gpl.html)
 * @author     Vadim Nevorotin <malamut@ubuntu.ru>
 */

// Функции управления формой поиска
function insch(f) {
	if (f.value=="Поиск...") f.value="";
}
function outsch(f) {
	if (f.value=="") f.value="Поиск...";
}

// Установка Cookie
function setCookie(name, value, exp_days, path, domain) {
	var expire=new Date();
	if (exp_days) {
		expire.setDate(expire.getDate() + exp_days);
	}
	var cookie = name + '=' + escape(value) +
			( exp_days ? '; expires=' + expire.toUTCString() : '' ) +
			( path ? '; path=' + path : '' ) +
			( domain ? '; domain=' + domain : '' );
	document.cookie = cookie;
}

// Функция переключения нижней панели (jQuery)
function toggleBottomPanel(event) {
	if (jQuery('#__control').hasClass('pinned-up')) {
		jQuery('#__control_toggle').find('img').attr('src', 'http://s.ubuntu.ru/img/remmina-pin-up.png');
		jQuery('#__control_toggle').find('img').attr('alt', 'Закрепить панель');
		jQuery('#__control_toggle').children('a').attr('title', 'Закрепить панель');
		setCookie('doku_bottompanel_state', 'pinned-down', 5000, '/', 'ubuntu.ru');
	}
	else {
		jQuery('#__control_toggle').find('img').attr('src', 'http://s.ubuntu.ru/img/remmina-pin-down.png');
		jQuery('#__control_toggle').find('img').attr('alt', 'Открепить панель');
		jQuery('#__control_toggle').children('a').attr('title', 'Открепить панель');
		setCookie('doku_bottompanel_state', 'pinned-up', 5000, '/', 'ubuntu.ru');
	}
	jQuery('#__control').toggleClass('pinned-up pinned-down');
	event.preventDefault();
}

// Нам нужна jQuery
if (window.jQuery) {
	// Ок, добавляем всё, что надо, в DOM
	jQuery( function() {
		// Переключение нижней панели Doku
		jQuery('#__control_toggle').children('a').click(toggleBottomPanel);
		// Подсказка в форме поиска DokuWiki
		jQuery('#qsearch__in').blur( function() {
			if (jQuery(this).val() == "") {
				jQuery(this).val("Поиск по ресурсу...");
			}
		});
		jQuery('#qsearch__in').focus( function() {
			if (jQuery(this).val() == "Поиск по ресурсу...") {
				jQuery(this).val("");
			}
		});
		jQuery('#qsearch__in').blur();
	});
}
