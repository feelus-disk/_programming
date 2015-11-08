/*
 * Convenience functions to search from different locations 
 */

/*
 * Invoke this function in the advanced search form's submit.
 * Determines the selected documentation set and invokes search 
 * function to search that documentation set. 
 */

function submitDocSearch() {
  var scope = "";
  var selElem = document.getElementById("docsets");
  for(i = 0; i < selElem.options.length; i++) {
    if(selElem.options[i].selected == true) {
        scope = selElem.options[i].value;
        break;
    }
  }
  search(scope);
}

/* Search function for landing page. 
 * search main or archive zip file depending on user selection
 */
 
function submitSearch() {
   search("/javase");
 }
 
/* Search Java Tutorials. Invoke from tutorial search page */
function submitTutorialSearch() {
    search("/javase/tutorial");
}

/* Search specs  */
 
function submit7SpecSearch() {
   search("/javase/7/specs");
 }

/*
 * Core search function 
 */

function search(scope) {
	var sform = document.getElementById("searchForm");
	var srchelem = document.getElementById("searchField");
	var srchelemreal = document.getElementById("keywordreal");
	var srchval = srchelem.value;
	if (srchval.length == 0) {
	  return false;
	}
	var searchUrl = "url:" + scope;
	srchelemreal.value = srchval + " " + searchUrl;
	sform.action = "https://search.oracle.com/search/search";
	sform.method = "get";
	sform.target = "_top";
	sform.submit();
}


