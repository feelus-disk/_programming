search_str = "";
articles = new Array();

$(document).ready(function(){
	$('#all_articles').hide();
	$('#hide_all_articles').hide();
	//alert(Drupal.settings.basePath);
	  console.log("started download"); 
	  search_str = $('#search_word').val();
	  getAllResults(search_str);

    $('#search_word').keyup(function(){
			console.log(first);
  			$('#all_articles').html('').show('slow');
			  $('#hide_all_articles').show();
			  search_str = $('#search_word').val();
			  var flag = false;
			  var first = true;
			  for(var i=0;i<articles.length;i++) {
				  if (articles[i].innerHTML.toLowerCase().match((search_str.toLowerCase()))) {
					$('#all_articles').append(articles[i]);
					flag = true;
				  }
			  }
			if (!flag) $('#all_articles').html("<p>К сожалению ничего не нашлось..</p>");
			if (first) { $('#all_articles a:first-child').addClass('active'); }
			first=false;
	});

	$('#hide_all_articles').click(function(){
		$('#all_articles').hide('slow');
		$('#hide_all_articles').hide();
	});
});

function getAllResults(str) {
   $.ajax({
    url: Drupal.settings.basePath+'articles_ajax?str='+str,
    type: 'GET',
    dataType: "json", 
    success: function(data){
			for(var i=0;i<data.length;i++) {
               //console.log(data[i].title); 


				  var a = document.createElement('a');
				  a.innerHTML = data[i].title;
				  a.href = data[i].url;
				  articles.push(a);
			  
			} 

			
    },
    error:  function(xhr, str){
            console.log('Возникла ошибка: ' + xhr.responseCode);
    }
  }); 
  
}
