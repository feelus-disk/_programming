$(document).ready(function () {
		$('#all_articles a').removeClass('active');
		$('#all_articles a:first-child').addClass('active');
		var artive_link_number = 0;
 		$(document).keydown(function (e) {
			if (e.keyCode == 40 || e.keyCode == 38) // запретить скролл
				return false
		});
        $(document).keyup(function (e) {
			
			//console.log(e.keyCode);     // dowm 40; uo 38
			if (e.keyCode == 40) { // down
				$('#search_word').blur();
				artive_link_number = (artive_link_number >= $('#all_articles a').length) ? 0 : artive_link_number+1;
				console.log(artive_link_number); 
				var i=0;
				$('#all_articles a').each(function(){
					$(this).removeClass('active');
					if (i == artive_link_number)
						$(this).addClass('active');
					i++;
				});
			} else 	if (e.keyCode == 38) { // up
				$('#search_word').blur();
				artive_link_number = (artive_link_number <= 0) ? $('#all_articles a').length : artive_link_number-1;
				console.log(artive_link_number); 
				var i=0;
				$('#all_articles a').each(function(){
					$(this).removeClass('active');
					if (i == artive_link_number)
						$(this).addClass('active');
					i++;
				});
			}

			if (e.keyCode == 13) { //enter
				console.log(artive_link_number);
				var i=0; 
				$('#all_articles a').each(function(){
					if (i == artive_link_number) {
						console.log($(this).attr('href')); 
						//alert($(this).attr('href'));
						window.location.href = $(this).attr('href');
					}
					i++;
				});
				
				//window.location.href
			} 
        });
});
