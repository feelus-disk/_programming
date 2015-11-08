<!--
var old_css = new Object();
function pr(what){
    pr_block(what, 'table', null);
    pr_block(what, 'iframe', null);
    pr_block(what, 'div', 'adv');
    pr_block(what, 'div', 'adv2');
    pr_block(what, 'div', 'adv3');
    pr_block(what, 'center', 'adv');
}

function pr_block(what, block, block_id){

    if (block_id != null) {
	var item = document.getElementById(block_id);
	if (item){
	    if (what == 'block'){
    		item.style.display = old_css[block];
	    } else {
		old_css[block] = item.style.display;
    		item.style.display=what;
	    }
	}
	return true;
    } else if (document.getElementsByTagName) { // IE5+/NS6
        var tables = document.getElementsByTagName(block);
    } else if (document.all && document.all.tags) { // IE4
        var tables = document.all.tags(block);
    }

    for (var i = 0; i < tables.length; i++){
	if (tables[i].id != "text"){
	    if (what == 'block'){
    		tables[i].style.display = old_css[block + i];
	    } else {
		old_css[block + i] = tables[i].style.display;
    		tables[i].style.display=what;
	    }
	}
    }
    if (what == "none") {
        setTimeout("pr('block')", 15000);
    }
}


//-->
