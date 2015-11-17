/* ###########################################################################

GLOBAL ASSETS RELEASE v6.0.2

BUILD DATE: 20100224

########################################################################### */

/*
reglib version 1.1
Copyright 2008
Released under MIT license
http://code.google.com/p/reglib/
*/

// you can rename window.reg to whatever you want
window.reg = (function(){

var reg = {};

// this adds reg's dom helper functions and event functions to the
// global namespace. don't call this method if you want to keep your
// global namespace clean. alternatively you can individually import
// certain sections, this is just a convenient way to do them all.
reg.importAll = function() {
	var errStrings = [];
	try { reg.importSelectorAPI(); }
	catch (err) { errStrings.push(err.message); }
	try { reg.importHelperFunctions(); }
	catch (err) { errStrings.push(err.message); }
	try { reg.importEventFunctions(); }
	catch (err) { errStrings.push(err.message); }
	if (errStrings.length > 0) { if (console && console.log) { console.log(errStrings.join("\n")); } }
};
function globalError(name) {
	return "reglib tried to add \""+name+"\" to global namespace but \""+name+"\" already existed.";
}
if (window.Node && Node.prototype && !Node.prototype.contains) {
	Node.prototype.contains = function (arg) {
		try{return !!(this.compareDocumentPosition(arg) & 16);}
		catch(ex){return false;}
	}
}

// #############################################################################
// #### SELECTORS ##############################################################
// #############################################################################

/*
A CSS-like selector API focusing on matching not traversal:
- new reg.Selector(selectorString)
- new reg.Selector(selectorString).matches(someElement)

For example:
var sel = new reg.Selector('div#foo > ul.bar > li');
var item = document.getElementById('myListItem');
if (sel.matches(item)) { ... }
*/

// precompiled patterns
var expressions = {
	leadSpace:  new RegExp("^\\s+"),
	tagName:    new RegExp("^([a-z_][a-z0-9_-]*)","i"),
	wildCard:   new RegExp("^\\*([^=]|$)"),
	className:  new RegExp("^(\\.([a-z0-9_-]+))","i"),
	id:         new RegExp("^(#([a-z0-9_-]+))","i"),
	att:        new RegExp("^(@([a-z0-9_-]+))","i"),
	matchType:  new RegExp("(^\\^=)|(^\\$=)|(^\\*=)|(^~=)|(^\\|=)|(^=)"),
	spaceQuote: new RegExp("^\\s+['\"]")
};

// constructor
reg.Selector=function(selString) {
	var exp = expressions;
	this.items = []; // for each comma-separated selector, this array has an item
	var itms = []; // this will be added to this.items
	var count = 0;
	var origSel = selString;
	while (selString.length>0) {
		if (count > 100) { throw new Error("failed parsing '"+origSel+"' stuck at '"+selString+"'"); }
		// get rid of any leading spaces
		var leadSpaceChopped = false;
		if (exp.leadSpace.test(selString)) {
			selString=selString.replace(exp.leadSpace,'');
			leadSpaceChopped = true;
		}

		// find tag name
		var tagNameMatch = exp.tagName.exec(selString);
		if (tagNameMatch) {
			if (itms.length > 0 && itms[itms.length-1].name=='tag') { itms.push({name:'descendant'}); }
			itms.push({name:'tag',tagName:tagNameMatch[1].toLowerCase()});
			selString=selString.substring(tagNameMatch[1].length);
			tagNameMatch=null;
			continue;
		}
		// explicit wildcard selector
		if (exp.wildCard.test(selString)) {
			if (itms.length > 0 && itms[itms.length-1].name=='tag') { itms.push({name:'descendant'}); }
			itms.push({name:'tag',tagName:'*'});
			selString = selString.substring(1);
			continue;
		}
		var classMatch = exp.className.exec(selString);
		var idMatch = exp.id.exec(selString);
		var attMatch = exp.att.exec(selString);
		if (classMatch || idMatch || attMatch) {
			// declare descendant if necessary
			if (leadSpaceChopped && itms.length>0 && itms[itms.length-1].name=='tag') { itms.push({name:'descendant'}); }
			// create a tag wildcard * if necessary
			if (itms.length==0 || itms[itms.length-1].name!='tag') { itms.push({name:'tag',tagName:'*'}); }
			var lastTag = itms[itms.length-1];
			// find class name, like .entry
			if (classMatch) {
				if (!lastTag.classNames) {
					lastTag.classNames = [classMatch[2]];
				} else {
					lastTag.classNames.push(classMatch[2]);
				}
				selString=selString.substring(classMatch[1].length);
				classMatch=null;
				continue;
			}
			// find id, like #content
			if (idMatch) {
				lastTag.id=idMatch[2];
				selString=selString.substring(idMatch[1].length);
				idMatch=null;
				continue;
			}
			// find attribute selector, like @src
			if (attMatch) {
				if (!lastTag.attributes) {
					lastTag.attributes = [{name:attMatch[2]}];
				} else {
					lastTag.attributes.push({name:attMatch[2]});
				}
				selString=selString.substring(attMatch[1].length);
				attMatch=null;
				continue;
			}
		}
		// find attribute value specifier
		var mTypeMatch=exp.matchType.exec(selString);
		if (mTypeMatch) {
			// this will determine how the matching is done
			// (lastTag should still be hanging around)
			if(lastTag && lastTag.attributes && !lastTag.attributes[lastTag.attributes.length-1].value){

				var lastAttribute = lastTag.attributes[lastTag.attributes.length-1];
				lastAttribute.matchType = mTypeMatch[0];

				selString=selString.substring(lastAttribute.matchType.length);
				if(selString.charAt(0)!='"'&&selString.charAt(0)!="'"){
					if(exp.spaceQuote.test(selString)){selString=selString.replace(exp.leadSpace,'');}
					else{throw new Error(origSel+" is invalid, single or double quotes required around attribute values");}
				}
				// it is enclosed in quotes, end is closing quote
				var q=selString.charAt(0);
				var lastQInd=selString.indexOf(q,1);
				if(lastQInd==-1){throw new Error(origSel+" is invalid, missing closing quote");}
				while(selString.charAt(lastQInd-1)=='\\'){
					lastQInd=selString.indexOf(q,lastQInd+1);
					if(lastQInd==-1){throw new Error(origSel+" is invalid, missing closing quote");}
				}
				lastAttribute.value=selString.substring(1,lastQInd);
				if      ('~=' == lastAttribute.matchType) { lastAttribute.valuePatt = new RegExp("(^|\\s)"+lastAttribute.value+"($|\\s)"); }
				else if ('|=' == lastAttribute.matchType) { lastAttribute.valuePatt = new RegExp("^"+lastAttribute.value+"($|\\-)"); }
				selString=selString.substring(lastAttribute.value.length+2);// +2 for the quotes
				continue;
			} else {
				throw new Error(origSel+" is invalid, "+mTypeMatch[0]+" appeared without preceding attribute identifier");
			}
			mTypeMatch=null;
		}
		// find child selector
		if (selString.charAt(0) == '>') {
			itms.push({name:'child'});
			selString=selString.substring(1);
			continue;
		}
		// find next sibling selector
		if (selString.charAt(0) == '+') {
			itms.push({name:'nextSib'});
			selString=selString.substring(1);
			continue;
		}
		// find after sibling selector
		if (selString.charAt(0) == '~') {
			itms.push({name:'followingSib'});
			selString=selString.substring(1);
			continue;
		}
		// find the comma separator
		if (selString.charAt(0) == ',') {
			this.items.push(itms);
			itms = [];
			selString = selString.substring(1);
			continue;
		}
		count++;
	}
	this.items.push(itms);
	this.selectorString=origSel;
	// do some structural validation
	for (var a=0;a<this.items.length;a++){
		var itms = this.items[a];
		if (itms.length==0) { throw new Error("illegal structure: '"+origSel+"' contains an empty set"); }
		if (itms[0].name!='tag') { throw new Error("illegal structure: '"+origSel+"' contains a dangling relation"); }
		if (itms[itms.length-1].name!='tag') { throw new Error("illegal structure: '"+origSel+"' contains a dangling relation"); }
		for(var b=1;b<itms.length;b++){
			if(itms[b].name!='tag'&&itms[b-1].name!='tag'){ throw new Error("illegal structure: '"+origSel+"' contains doubled up relations"); }
		}
	}
}

// returns string suitable for querySelector() and querySelectorAll()
function toQuerySelectorString(sel) {
	if (!sel.qss) {
		var itemStrings = [];
		for (var i=0; i<sel.items.length; i++) {
			var result = '';
			var item = sel.items[i];
			for (var j=0; j<item.length; j++) {
				var des = item[j];
				if (des.name=='tag') {
					result += des.tagName;
					if (des.classNames) { result += "." + des.classNames.join("."); }
					if (des.id) { result += '#' + des.id; }
					if (des.targeted) {  result += ':target'; }
					if (des.attributes) {

						for (var k=0; k<des.attributes.length; k++) {
							result += '[' + des.attributes[k].name;
							if (des.attributes[k].matchType) {
								result += des.attributes[k].matchType;
								result += '"'+des.attributes[k].value.replace(/"/,'\\"')+'"';
							}
							result += ']';
						}

					}
				} else if (des.name=='descendant') {
					result += ' ';
					continue;
				} else if (des.name=='child') {
					result += ' > ';
					continue;
				} else if (des.name=='followingSib') {
					result += ' ~ ';
					continue;
				} else if (des.name=='nextSib') {
					result += ' + ';
					continue;
				}
			}
			itemStrings.push(result);
		}
		sel.qss = itemStrings.join(', ');
	}
	return sel.qss;
}

// match against an element
reg.Selector.prototype.matches = function(el) {
	if (!el) { throw new Error('no element provided'); }
	if (el.nodeType != 1) { throw new Error(this.selectorString+' cannot be evaluated against element of type '+el.nodeType); }
	commas:for (var a=0;a<this.items.length;a++) { // for each comma-separated selector
		var tempEl = el;
		var itms = this.items[a];
		for (var b=itms.length-1; b>=0; b--) { // loop backwards through the items
			var itm = itms[b];
			if (itm.name == 'tag') {
				if (!matchIt(tempEl, itm)) {
					// these relational selectors require more extensive searching
					if (tempEl && b < itms.length-1 && itms[b+1].name=='descendant') { tempEl=tempEl.parentNode; b++; continue; }
					else if (tempEl && b < itms.length-1 && itms[b+1].name=='followingSib') { tempEl=tempEl.previousSibling; b++; continue; }
					else { continue commas; } // fail this one
				}
			}
			else if (itm.name == 'nextSib') { tempEl = previousElement(tempEl); }
			else if (itm.name == 'followingSib') { tempEl = previousElement(tempEl); }
			else if (itm.name == 'child') { tempEl = tempEl.parentNode; }
			else if (itm.name == 'descendant') { tempEl = tempEl.parentNode; }
		}
		return true;
	}
	return false;
};

// subroutine for matches() above
function matchIt(el, itm) {
	// try to falsify as soon as possible
	if (!el) { return false; }
	if (el.nodeName.toLowerCase()!=itm.tagName && itm.tagName!='*') { return false; }
	if (itm.classNames) {
		 for (var i=0; i<itm.classNames.length; i++) {
			if (!hasClassName(el, itm.classNames[i])) {
				return false;
			}
		}
	}
	if (itm.id && el.id != itm.id) { return false; }
	if (itm.attributes) {
		for (var i=0; i<itm.attributes.length; i++) {
			var itmAtt = itm.attributes[i];
			if (typeof el.hasAttribute != 'undefined') {
				if (!el.hasAttribute(itmAtt.name)) { return false; }
				var att = el.getAttribute(itmAtt.name);
			}else{
				if(el.nodeType!=1) {return false;}
				var att = el.getAttribute(itmAtt.name,2);//ie6/7 returns fully resolved href but ,2 fixes that
				if(itmAtt.name=='class'){att=el.className;}//todo:remove this line
				else if(itmAtt.name=='for'){att=el.htmlFor;}//todo:and this one
				if(!att){return false;}
			}
			if (itmAtt.value) {
				if (itmAtt.matchType=='^='){
					if (att.indexOf(itmAtt.value)!=0){return false;}
				} else if (itmAtt.matchType=='*='){
					if (att.indexOf(itmAtt.value)==-1){return false;}
				} else if (itmAtt.matchType=='$='){
					var indOf = att.indexOf(itmAtt.value);
					if (indOf===-1||indOf!=att.length-itmAtt.value.length){return false;}
				} else if (itmAtt.matchType=='='){
					if (att!=itmAtt.value){return false;}
				} else if ('|='==itmAtt.matchType || '~='==itmAtt.matchType){
					if (!itmAtt.valuePatt.test(att)){return false;}
				}else{
					if(!itmAtt.matchType){throw new Error("illegal structure, parsed selector cannot have null or empty attribute match type");}
					else{throw new Error("illegal structure, parsed selector cannot have '"+itm.matchType+"' as an attribute match type");}
				}
			}
		}
	}
	return true;
}

// gets the tag names that the selector represents
function getTagNames(sel) {
	var hash = {}; // this avoids dupes
	for (var a=0;a<sel.items.length;a++){
		hash[sel.items[a][sel.items[a].length-1].tagName]=null;
	}
	var result = [];
	for (var tag in hash){if(hash.hasOwnProperty(tag)){result.push(tag);}}
	return result;
}

reg.importSelectorAPI = function() {
	if (window.Selector) { throw new Error(globalError("Selector")); }
	window.Selector = reg.Selector;
};

// #############################################################################
// #### DOM HELPERS ############################################################
// #############################################################################

/*
A bunch of DOM convenience methods (alias names in braces):

CLASSNAMES
- reg.addClassName(el, cName)..............................{acn}
- reg.getElementsByClassName(cNames[, ctxNode[, tagName]]).{gebcn}
- reg.hasClassName(el, cName)..............................{hcn}
- reg.matchClassName(el, regexp)...........................{mcn}
- reg.removeClassName(el, cName)...........................{rcn}
- reg.switchClassName(el, cName1, cName2)..................{scn}
- reg.toggleClassName(el, cName)...........................{tcn}

SELECTORS
- reg.elementMatchesSelector(el, selString)................{matches}
- reg.getElementsBySelector(selString[, ctxNode])..........{gebs}

OTHER
- reg.elementText(el)......................................{elemText}
- reg.getElementById().....................................{gebi}
- reg.getElementsByTagName(tagName[, ctxNode]).............{gebtn}
- reg.getParent(el, selString)
- reg.innerWrap(el, wrapperEl)
- reg.insertAfter(insertMe, afterThis)
- reg.newElement(tagName[, attObj[, contents]])............{elem}
- reg.nextElement(el)......................................{nextElem}
- reg.outerWrap(el, wrapperEl)
- reg.previousElement(el)..................................{prevElem}
*/

var clPatts={};// cache compiled classname regexps
var cSels={};// cache compiled selectors

// TEST FOR CLASS NAME
function hasClassName(element, cName) {
	if (!clPatts[cName]) { clPatts[cName] = new RegExp("(^|\\s)"+cName+"($|\\s)"); }
	return element.className && clPatts[cName].test(element.className);
}

// ADD CLASS NAME
function addClassName(element, cName) {
	if (!hasClassName(element, cName)) {
		element.className += ' ' + cName;
	}
}

// REMOVE CLASS NAME
function removeClassName(element, cName) {
	if (!clPatts[cName]) { clPatts[cName] = new RegExp("(^|\\s+)"+cName+"($|\\s+)"); }
	element.className = element.className.replace(clPatts[cName], ' ');
}

// TOGGLE CLASS NAME
function toggleClassName(element, cName) {
	if (hasClassName(element, cName)) { removeClassName(element, cName); }
	else { addClassName(element, cName); }
}

// SWITCH CLASS NAME A->B, B->A
function switchClassName(element, cName1, cName2) {
	if (cName1 == cName2) { throw new Error("cName1 and cName2 both equal "+cName1); }
	var has1 = hasClassName(element, cName1);
	var has2 = hasClassName(element, cName2);
	if (has1 && has2) { removeClassName(element, cName2); }
	else if (!has1 && !has2) { addClassName(element, cName1); }
	else if (has1) { removeClassName(element, cName1); addClassName(element, cName2); }
	else { removeClassName(element, cName2); addClassName(element, cName1); }
}

// TEST FOR CLASS NAME BY REGEXP
function matchClassName(element, pattern){
	var cNames = element.className.split(' ');
	for (var a=0; a<cNames.length; a++){
		var matches = cNames[a].match(pattern);
		if (matches) { return matches; }
	}
	return null;
}

// TEST AGAINST SELECTOR
function elementMatchesSelector(element, selString){
	if(!cSels[selString]){cSels[selString]=new reg.Selector(selString);}
	return cSels[selString].matches(element);
}

// FIND PREVIOUS ELEMENT
function previousElement(el) {
	var prev = el.previousSibling;
	while(prev && prev.nodeType!=1){prev=prev.previousSibling;}
	return prev;
}

// FIND NEXT ELEMENT
function nextElement(el) {
	var next = el.nextSibling;
	while(next && next.nodeType!=1){next=next.nextSibling;}
	return next;
}

// ADD INNER WRAPPER
function innerWrap(el, wrapperEl) {
	var nodes = el.childNodes;
	while (nodes.length > 0) {
		var myNode = nodes[0];
		el.removeChild(myNode);
		wrapperEl.appendChild(myNode);
	}
	el.appendChild(wrapperEl);
}

// ADD OUTER WRAPPER
function outerWrap(el, wrapperEl) {
	el.parentNode.insertBefore(wrapperEl, el);
	el.parentNode.removeChild(el);
	wrapperEl.appendChild(el);
}

// GET PARENT
function getParent(el, selString) {
	var parsedSel = new reg.Selector(selString);
	while (el.parentNode) {
		el = el.parentNode;
		if (el.nodeType==1 && parsedSel.matches(el)) { return el; }
	}
	return null;
}

// INSERT AFTER
function insertAfter(insertMe, afterThis){
	var beforeThis = afterThis.nextSibling;
	var parent = afterThis.parentNode;
	if (beforeThis) { parent.insertBefore(insertMe, beforeThis); }
	else { parent.appendChild(insertMe); }
}

// SHORTCUT FOR BUILDING ELEMENTS
function newElement(name, atts, content) {
	// name: e.g. 'div', 'div.foo', 'div#bar', 'div.foo#bar', 'div#bar.foo'
	// atts: (optional) e.g. {'href':'page.html','target':'_blank'}
	// content: (optional) either a string, or an element, or an arry of strings or elements
	if (name.indexOf('.') + name.indexOf('#') > -2) {
		var className = (name.indexOf('.') > -1) ? name.replace(/^.*\.([^\.#]*).*$/,"$1") : "";
		var id = (name.indexOf('#') > -1) ? name.replace(/^.*#([^\.#]*).*$/,"$1") : "";
		name = name.replace(/^([^\.#]*).*$/,'$1');
	}
	var e = document.createElement(name);
	if (className) { e.className = className; }
	if (id) { e.id = id; }
	if (atts) {
		for (var key in atts) {
			// setAttribute() has shaky support, try direct methods first
			if (!atts.hasOwnProperty(key)) { continue; }
			if (key == 'class') { e.className = e.className ? e.className += ' ' + atts[key] : atts[key]; }
			else if (key == 'for') { e.htmlFor = atts[key]; }
			else if (key.indexOf('on') == 0) { e[key] = atts[key]; }
			else {
				e.setAttribute(key, atts[key]);
			}
		}
	}
	if (content) {
		if (!(content instanceof Array)) {
			content = [content];
		}
		for (var a=0; a<content.length; a++) {
			if (content[a].nodeType !== undefined) {
				e.appendChild(content[a]);
			}else{
				e.appendChild(document.createTextNode(content[a]));
			}
		}
	}
	if (name.toLowerCase() == 'img' && !e.alt) { e.alt = ''; }
	return e;
}

// GRAB JUST THE TEXTUAL DATA OF AN ELEMENT
function elementText(el) {
	// <a id="foo" href="page.html">click <b>here</b></a>
	// elementText(document.getElementById('foo')) == "click here"
	// warning: recurses through *all* descendants of el
	if(!el){return '';}
	var chlds = el.childNodes;
	var result = '';
	if (reg.matches(el,'img@alt,area@alt')) { result += el.alt; }
	else if (reg.matches(el,'input')) { result += el.value; }
	else {
		for (var a=0; a<chlds.length; a++) {
			if (3 == chlds[a].nodeType) {
				result += chlds[a].data;
			} else if (1 == chlds[a].nodeType) {
				result += elementText(chlds[a]);
			}
		}
	}
	return result;
}

// GET ELEMENT BY ID
function getElementById(id) { return document.getElementById(id); }

// GET ELEMENTS BY TAG NAME
function getElementsByTagName(tag, contextNode) {
	if(!contextNode){contextNode=document;}
	return contextNode.getElementsByTagName(tag);
}

// GET ELEMENTS BY SELECTOR
var classTest = /^\s*([a-z0-9_-]+)?\.([a-z0-9_-]+)\s*$/i;
var idTest = /^\s*([a-z0-9_-]+)?\#([a-z0-9_-]+)\s*$/i;
function getElementsBySelector(selString, contextNode) {
	contextNode = contextNode || window.document.documentElement;
	var result = [];
	var cMat, iMat;
	if (cMat = selString.match(classTest)) {
		var cl = cMat[2];
		var tg = cMat[1];
		result = reg.gebcn(cl, contextNode, tg);
	} else if (iMat = selString.match(idTest)) {
		var id = iMat[2];
		var tg = iMat[1];
		var el = reg.gebi(id);
		if (el && contextNode.contains(el) && reg.matches(el, selString)) { result[0] = el; }
	} else {
		if (!cSels[selString]) { cSels[selString] = new reg.Selector(selString); }
		var sel = cSels[selString];
		if (contextNode.querySelectorAll) {
			var qlist = contextNode.querySelectorAll(toQuerySelectorString(sel));
			for (var i=0; i<qlist.length; i++) {
				result[result.length] = qlist[i];
			}
		} else {
			var tagNames = getTagNames(sel);
			for (var a=0; a<tagNames.length; a++) {
				var els = getElementsByTagName(tagNames[a], contextNode);
				for (var b=0, el; el=els[b++];) {
					if (el.nodeType!=1) { continue; }
					if (sel.matches(el)) { result.push(el); }
				}
			}
		}
	}
	return result;
}

// GET ELEMENTS BY CLASS NAME
function getElementsByClassName(classNames, contextNode, tag) {
	contextNode = (contextNode) ? contextNode : document;
	tag = (tag) ? tag.toLowerCase() : '*';
	var results = [];
	if (document.getElementsByClassName) {
		// traverse natively
		var liveList = contextNode.getElementsByClassName(classNames);
		if (tag != '*') {
			for (var i=0; i<liveList.length; i++) {
				var el = liveList[i];
				if (tag == el.nodeName.toLowerCase()) {
					results.push(el);
				}
			}
		} else {
			for (var i=0; i<liveList.length; i++) { results.push(liveList[i]); }
		}
	} else {
		classNames = classNames.split(/\s+/);
		if (document.evaluate) {
			// traverse w/ xpath
			var xpath = ".//"+tag;
			var len = classNames.length;
			for(var i=0; i<len; i++) {
				xpath += "[contains(concat(' ', @class, ' '), ' " + classNames[i] + " ')]";
			}
			var xpathResult = document.evaluate(xpath, contextNode, null, XPathResult.ORDERED_NODE_ITERATOR_TYPE, xpathResult);
			var el;
			while (el = xpathResult.iterateNext()) {
				results.push(el);
			}
		} else {
			// traverse w/ dom
			var els = (tag=='*'&&contextNode.all) ? contextNode.all : getElementsByTagName(tag,contextNode);
			elements:for (var i=0,el;el=els[i++];) {
				for (var j=0; j<classNames.length; j++) {
					if (!hasClassName(el, classNames[j])) { continue elements; }
				}
				results.push(el);
			}
		}
	}
	return results;
}

var helpers = {
	hasClassName:           hasClassName,
	addClassName:           addClassName,
	removeClassName:        removeClassName,
	toggleClassName:        toggleClassName,
	switchClassName:        switchClassName,
	matchClassName:         matchClassName,
	elementMatchesSelector: elementMatchesSelector,
	previousElement:        previousElement,
	nextElement:            nextElement,
	innerWrap:              innerWrap,
	outerWrap:              outerWrap,
	getParent:              getParent,
	insertAfter:            insertAfter,
	newElement:             newElement,
	elementText:            elementText,
	getElementById:         getElementById,
	getElementsByTagName:   getElementsByTagName,
	getElementsBySelector:  getElementsBySelector,
	getElementsByClassName: getElementsByClassName
};

// aliases
helpers.hcn      = helpers.hasClassName;
helpers.acn      = helpers.addClassName;
helpers.rcn      = helpers.removeClassName;
helpers.tcn      = helpers.toggleClassName;
helpers.scn      = helpers.switchClassName;
helpers.mcn      = helpers.matchClassName;
helpers.matches  = helpers.elementMatchesSelector;
helpers.prevElem = helpers.previousElement;
helpers.nextElem = helpers.nextElement;
helpers.elem     = helpers.newElement;
helpers.elemText = helpers.elementText;
helpers.gebi     = helpers.getElementById;
helpers.gebtn    = helpers.getElementsByTagName;
helpers.gebs     = helpers.getElementsBySelector;
helpers.gebcn    = helpers.getElementsByClassName;

// add it globally
reg.importHelperFunctions = function() {
	var errStrings = [];
	for (var func in helpers) {
		if(!helpers.hasOwnProperty(func)) { continue; }
		if (window[func]) { errStrings.push(globalError(func)); }
		else { window[func] = helpers[func]; }
	}
	if (errStrings.length > 0) { throw new Error(errStrings.join("\n")); }
};

// add it to reg
for (var func in helpers) {
	if(!helpers.hasOwnProperty(func)) { continue; }
	if (reg[func]) { throw new Error("Already exists under reg: "+func); }
	else { reg[func] = helpers[func]; }
}

// #############################################################################
// #### X-BROWSER EVENTS #######################################################
// #############################################################################

/*
Event attachment and detachment:
*/

// get the element on which the event occurred
function getTarget(e) {
 	if (!e) { e = window.event; }
 	if (e.target) { var targ = e.target; }
 	else if (e.srcElement) { var targ = e.srcElement; }
	else if (e.toElement) { var targ = e.toElement; }
 	if (targ.nodeType == 3) { targ = targ.parentNode; } // safari hack
 	return targ;
}

// get the element on which the event occurred
function getRelatedTarget(e) {
	if (!e) { e = window.event; }
	var rTarg = e.relatedTarget;
	if (!rTarg) {
		if ('mouseover'==e.type) { rTarg = e.fromElement; }
		if ('mouseout'==e.type) { rTarg = e.toElement; }
	}
	return rTarg;
}

// cancel default action
function cancelDefault(e) {
	if (typeof e.preventDefault != 'undefined') { e.preventDefault(); return; }
	e.returnValue=false;
}

// cancel bubble
function cancelBubble(e) {
	if (typeof e.stopPropagation != 'undefined') { e.stopPropagation(); return; }
	e.cancelBubble=true;
}

// event registry
var memEvents = {};
var aMemInd = 0;
function rememberEvent(elmt,evt,handle,cptr,cleanable){
	var memInd = aMemInd++;
	memEvents[memInd+""] = {
		element:   elmt,
		event:     evt,
		handler:   handle,
		capture:   !!cptr,
		cleanable: !!cleanable
	};
	return memInd;
}

// event remover
function removeEvent(memInd) {
	var key = memInd+"";
	var eo = memEvents[key];
	if (eo) {
		var el=eo.element;
		if(el.removeEventListener) {
			el.removeEventListener(eo.event, eo.handler, eo.capture);
			delete memEvents[key];
			return true;
		} else if(el.detachEvent) {
			el.detachEvent('on'+eo.event, eo.handler);
			delete memEvents[key];
			return true;
		}
	}
	return false;
}

// if "all" is true, it nukes all events
// otherwise only those created with "cleanable" flag
function cleanup(all){
	for (var key in memEvents) {
		if (!memEvents.hasOwnProperty(key)) { continue; }
		if (all || (memEvents[key].cleanable && !document.documentElement.contains(memEvents[key].element))) {
			removeEvent(key);
			//console.log("cleaning up event: "+key);
		}
	}
}

//periodically clean up all cleanable events
window.setInterval(function(){
	cleanup(false);
},10000);

// generic event adder, plus memory leak prevention
// returns an int mem that you can use to later remove that event removeEvent(mem)
// cptr defaults false
function addEvent(elmt,evt,handler,cptr,cleanable) {
	if(elmt.addEventListener){
		elmt.addEventListener(evt,handler,cptr);
		return rememberEvent(elmt,evt,handler,cptr,cleanable);
	}else if(elmt.attachEvent){
		var actualHandler = function(){handler.call(elmt,window.event);};
		elmt.attachEvent("on"+evt,actualHandler);
		return rememberEvent(elmt,evt,actualHandler,cptr,cleanable);
	}
}

// try to reduce memory leaks in ie
addEvent(window,'unload',function(){cleanup(true)});

var events = {
	getTarget:        getTarget,
	getRelatedTarget: getRelatedTarget,
	cancelDefault:    cancelDefault,
	addEvent:         addEvent,
	removeEvent:      removeEvent,
	cancelBubble:     cancelBubble
};

reg.importEventFunctions = function() {
	var errStrings = [];
	for (var func in events) {
		if(!events.hasOwnProperty(func)) { continue; }
		if (window[func]) { errStrings.push(globalError(func)); }
		else { window[func] = events[func]; }
	}
	if (errStrings.length > 0) { throw new Error(errStrings.join("\n")); }
};

for (var func in events) {
	if(!events.hasOwnProperty(func)) { continue; }
	if (reg[func]) { throw new Error("Already exists under reg: "+func); }
	else { reg[func] = events[func]; }
}

// #############################################################################
// #### ON(DOM)LOAD ACTIONS ####################################################
// #############################################################################

/*
Add actions to run onload:
- reg.preSetup(func)
- reg.setup(selString, func, firstTimeOnly)
- reg.postSetup(func)

!!! WARNING !!!
On browsers *without* native querySelector() support
reg.setup makes page load time O(MN)
where M is the number of calls to reg.setup()
and N is the number of elements on the page
*/

// these contain lists of things to do
var preSetupQueue=[];
var setupQueue=[];
var setupQueueByTag={};
var postSetupQueue=[];

// traverse and act onload
reg.setup=function(selector, setup, firstTimeOnly){
	firstTimeOnly=!!firstTimeOnly;
	var sqt=setupQueueByTag;
	var parsedSel = new reg.Selector(selector);
	var tagNames=getTagNames(parsedSel);
	var regObj={
		selector:parsedSel,
		setup:setup,
		ran:false,
		firstTimeOnly:firstTimeOnly
	};
	setupQueue.push(regObj);
	for(var a=0;a<tagNames.length;a++){
		var tagName = tagNames[a];
		if(!sqt[tagName]){sqt[tagName]=[regObj];}
		else{sqt[tagName].push(regObj);}
	}
};
// do this before setup
reg.preSetup=function(fn){preSetupQueue.push(fn);};
// do this after setup
reg.postSetup=function(fn){postSetupQueue.push(fn);};

// (re)run setup functions
var runSetupFunctions = reg.rerun = function(el, noClobber){
	function runIt(el, regObj){
		regObj.setup.call(el);
		regObj.ran=true;
	}
	var start = new Date().getTime();
	if (typeof el.clobberable != 'undefined' && el.clobberable && noClobber) { return; }
	var doc=(el)?el:document;
	var sqt=setupQueueByTag;
	var sqtIsEmpty=true;
	for (var tagName in sqt) {
		if(!sqt.hasOwnProperty(tagName)) { continue; }
		sqtIsEmpty = false;
		break;
	}

	if (el.querySelector) {

		//####################################
		//querySelector() branch

		var qSelResults = [];
		for (var i=0; i<setupQueue.length; i++) {
			var regObj = setupQueue[i];
			if (regObj.firstTimeOnly) {
				if (regObj.ran) { continue; }
				try {
					var elmt = el.querySelector(toQuerySelectorString(regObj.selector));
					if (elmt) { qSelResults.push({el:elmt,regObj:regObj}); }
				} catch (ex) {
					console.log("querySelector('"+toQuerySelectorString(regObj.selector)+"') threw "+ex);
					continue;
				}
			} else {
				try {
					var elmts = el.querySelectorAll(toQuerySelectorString(regObj.selector));
					for (var j=0; j<elmts.length; j++) {
						qSelResults.push({el:elmts[j],regObj:regObj});
					}
				} catch (ex) {
					console.log("querySelectorAll('"+toQuerySelectorString(regObj.selector)+"') threw "+ex);
					continue;
				}
			}
		}
		for (var i=0; i<qSelResults.length; i++) {
			runIt(qSelResults[i].el, qSelResults[i].regObj);
		}
	} else if (!sqtIsEmpty) {

		//####################################
		//old branch

		var elsList=getElementsByTagName('*',doc);

		//dump live list to static list
		for (var i=elsList.length-1, els=[]; i>=0; i--) {
			els[i] = elsList[i];
		}

		var qSelResults = [];

		// crawl the dom
		for(var a=0,elmt;elmt=els[a++];){
			if (elmt.nodeType!=1){continue;}//for ie7
			var lcNodeName=elmt.nodeName.toLowerCase();
			var regObjArrayAll=sqt['*'];
			var regObjArrayTag=sqt[lcNodeName];

			// any wildcards?
			if(regObjArrayAll){
				for(var b=0;b<regObjArrayAll.length;b++){
					var regObj=regObjArrayAll[b];
					if(regObj.firstTimeOnly && regObj.ran){continue;}
					var matches = regObj.selector.matches(elmt);
					if(matches){
						qSelResults.push({el:elmt,regObj:regObj});
						regObj.ran = true;
					}
				}
			}

			// any items match this specific tag?
			if(regObjArrayTag){
				for(var b=0;b<regObjArrayTag.length;b++){
					var regObj=regObjArrayTag[b];
					if(regObj.firstTimeOnly && regObj.ran){continue;}
					var matches = regObj.selector.matches(elmt);
					if(matches){
						qSelResults.push({el:elmt,regObj:regObj});
						regObj.ran = true;
					}
				}
			}
		}
		for (var i=0; i<qSelResults.length; i++) {
			runIt(qSelResults[i].el, qSelResults[i].regObj);
		}

	}
	el.clobberable = true;
	var runtime = new Date().getTime() - start;
	if(!reg.setupTime){ reg.setupTime=runtime; }
	reg.lastSetupTime=runtime;
}

var ie6 = navigator.appVersion.indexOf('MSIE 6.0') != -1;
if (!ie6) {
	addClassName(document.documentElement, 'regloading');
}
var loadFuncRan = false;
function loadFunc(e) {
	if (!loadFuncRan) {
		loadFuncRan = true;
		for(var a=0;a<preSetupQueue.length;a++){
			preSetupQueue[a]();
		}
		runSetupFunctions(document, true);
		for(var a=0;a<postSetupQueue.length;a++){
			postSetupQueue[a]();
		}
		if (!ie6) {
			// unfortunately this causes hangs and laborious redraws in ie6
			removeClassName(document.documentElement, 'regloading');
			addClassName(document.documentElement, 'regloaded');
		}
	}
}

// contents of loadFunc only execute once, this sidesteps user agent sniffing
addEvent(window, 'load', loadFunc);
addEvent(window, 'DOMContentLoaded', loadFunc);

// #############################################################################
// #### EVENT DELEGATION #######################################################
// #############################################################################

/*
The main purpose of reglib is event delegation:
- reg.click(selString, handler, depth)
- reg.hover(selString, overHandler, outHandler, depth)
- reg.focus(selString, focusHandler, blurHandler, depth)
- reg.key(selString, downHandler, pressHandler, upHandler, depth)
- reg.submit(selString, handler, depth)
- reg.reset(selString, handler, depth)
- reg.change(selString, handler, depth)
- reg.select(selString, handler, depth)

delegated events are active before page load, and remain
active throughout arbitrary rewrites of the DOM.
*/

// these contain the event handling functions
var clickHandlers = {};
var mDownHandlers = {};
var mUpHandlers = {};
var dblClickHandlers = {};
var mOverHandlers = {};
var mOutHandlers = {};
var focusHandlers = {};
var blurHandlers = {};
var keyDownHandlers = {};
var keyPressHandlers = {};
var keyUpHandlers = {};
var submitHandlers = {};
var resetHandlers = {};
var changeHandlers = {};
var selectHandlers = {};

// returns first arg that's a number
function getDepth(fargs){
	var result = null;
	for (var i=2; i<fargs.length; i++) {
		if (!isNaN(parseInt(fargs[i]))) {
			result = fargs[i];
			break;
		}
	}
	if(result===null){result=-1;}
	if(result<-1){throw new Error("bad arg for depth, must be -1 or higher");}
	return result;
}

// add a handler function
function pushFunc(selStr, handlerFunc, depth, handlers, hoverFlag) {
	if(!handlerFunc || typeof handlerFunc != "function"){return;}
	var parsedSel = new reg.Selector(selStr);
	if(!handlers[selStr]) {handlers[selStr]=[];}
	var selHandler = {
		selector:parsedSel,
		handle:handlerFunc,
		depth:depth,
		hoverFlag:hoverFlag
	};
	handlers[selStr].push(selHandler);
}

reg.click=function(selStr, clickFunc, downFunc, upFunc, doubleFunc){
	var depth = getDepth(arguments);
	pushFunc(selStr, clickFunc,  depth, clickHandlers,    false);
	pushFunc(selStr, downFunc,   depth, mDownHandlers,    false);
	pushFunc(selStr, upFunc,     depth, mUpHandlers,      false);
	pushFunc(selStr, doubleFunc, depth, dblClickHandlers, false);
};
reg.hover=function(selStr, overFunc, outFunc){
	var depth = getDepth(arguments);
	pushFunc(selStr, overFunc, depth, mOverHandlers, true);
	pushFunc(selStr, outFunc,  depth, mOutHandlers,  true);
};
reg.focus=function(selStr, focusFunc, blurFunc){
	var depth = getDepth(arguments);
	pushFunc(selStr, focusFunc, depth, focusHandlers, false);
	pushFunc(selStr, blurFunc,  depth, blurHandlers,  false);
};
reg.key=function(selStr, downFunc, pressFunc, upFunc){
	var depth = getDepth(arguments);
	pushFunc(selStr, downFunc,  depth, keyDownHandlers,  false);
	pushFunc(selStr, pressFunc, depth, keyPressHandlers, false);
	pushFunc(selStr, upFunc,    depth, keyUpHandlers,    false);
};
reg.submit=function(selStr, func) {
	var depth = getDepth(arguments);
	pushFunc(selStr, func, depth, submitHandlers, false);
};
reg.reset=function(selStr, func) {
	var depth = getDepth(arguments);
	pushFunc(selStr, func, depth, resetHandlers, false);
};
reg.change=function(selStr, func) {
	var depth = getDepth(arguments);
	pushFunc(selStr, func, depth, changeHandlers, false);
};
reg.select=function(selStr, func) {
	var depth = getDepth(arguments);
	pushFunc(selStr, func, depth, selectHandlers, false);
};

// workaround for IE's lack of support for bubbling on form events
// set delegation directly on the element in question by co-opting
// the focus event which is guaranteed to happen first
if (document.all && !window.opera) {
	function ieSubmitDelegate(e) {
		delegate(submitHandlers,e);
		cancelBubble(e);
	}
	function ieResetDelegate(e) {
		delegate(resetHandlers,e);
		cancelBubble(e);
	}
	function ieChangeDelegate(e) {
		delegate(changeHandlers,e);
		cancelBubble(e);
	}
	function ieSelectDelegate(e) {
		delegate(selectHandlers,e);
		cancelBubble(e);
	}
	reg.focus('form',function(){
		removeEvent(this._submit_prep);
		this._submit_prep=addEvent(this,'submit',ieSubmitDelegate,false,true);
		removeEvent(this._reset_prep);
		this._reset_prep=addEvent(this,'reset',ieResetDelegate,false,true);
	},function(){
		removeEvent(this._submit_prep);
		removeEvent(this._reset_prep);
	});
	reg.focus('select,input,textarea',function(){
		removeEvent(this._change_prep);
		this._change_prep=addEvent(this,'change',ieChangeDelegate,false,true);
	},function(){
		removeEvent(this._change_prep);
	});
	reg.focus('input,textarea',function(){
		removeEvent(this._select_prep);
		this._select_prep=addEvent(this,'select',ieSelectDelegate,false,true);
	},function(){
		removeEvent(this._select_prep);
	});
}

// the delegator
function delegate(selectionHandlers, event) {
	if (selectionHandlers) {
		var execList = [];
		var targ = getTarget(event);
		for (var sel in selectionHandlers) {
			if(!selectionHandlers.hasOwnProperty(sel)) { continue; }
			for(var a=0; a<selectionHandlers[sel].length; a++) {
				var selHandler=selectionHandlers[sel][a];
				var depth = (selHandler.depth==-1) ? 100 : selHandler.depth;
				var el = targ;
				for (var b=-1; b<depth && el && el.nodeType == 1; b++, el=el.parentNode) {
					if (selHandler.selector.matches(el)) {
						// replicate mouse enter/leave
						if (selHandler.hoverFlag) {
							var relTarg = getRelatedTarget(event);
							if (relTarg && (el.contains(relTarg) || el == relTarg)) {
								break;
							}
						}
						execList.push({"handle":selHandler.handle,"element":el});
						break;
					}
				}
			}
		}
		for (var i=0; i<execList.length; i++) {
			var exec = execList[i];
			var retVal=exec.handle.call(exec.element,event);
			// if they return false from the handler, cancel default
			if(retVal!==undefined && !retVal) {
				cancelDefault(event);
			}
		}
	}
}

if(typeof document.onactivate == 'object'){
	var focusEventType = 'activate';
	var blurEventType = 'deactivate';
}else{
	var focusEventType = 'focus';
	var blurEventType = 'blur';
}

// attach the events
var docEl = document.documentElement;
addEvent(docEl,'click',        function(e){delegate(clickHandlers,   e);});
addEvent(docEl,'mousedown',    function(e){delegate(mDownHandlers,   e);});
addEvent(docEl,'mouseup',      function(e){delegate(mUpHandlers,     e);});
addEvent(docEl,'dblclick',     function(e){delegate(dblClickHandlers,e);});
addEvent(docEl,'keydown',      function(e){delegate(keyDownHandlers, e);});
addEvent(docEl,'keypress',     function(e){delegate(keyPressHandlers,e);});
addEvent(docEl,'keyup',        function(e){delegate(keyUpHandlers,   e);});
addEvent(docEl,focusEventType, function(e){delegate(focusHandlers,   e);},true);
addEvent(docEl,blurEventType,  function(e){delegate(blurHandlers,    e);},true);
addEvent(docEl,'mouseover',    function(e){delegate(mOverHandlers,   e);});
addEvent(docEl,'mouseout',     function(e){delegate(mOutHandlers,    e);});
addEvent(docEl,'submit',       function(e){delegate(submitHandlers,  e);});
addEvent(docEl,'reset',        function(e){delegate(resetHandlers,   e);});
addEvent(docEl,'change',       function(e){delegate(changeHandlers,  e);});
addEvent(docEl,'select',       function(e){delegate(selectHandlers,  e);});

// #############################################################################
// #### CONSOLE.LOG BACKUP #####################################################
// #############################################################################

/*
For backwards compatibility.
Allows console.log() to be called in old clients without errors.
in which case console.contents() fetches logged messages.
*/

var logMessages = [];
var log = function(str) { logMessages.push(str); };
var contents = function() { return logMessages.join("\n")+"\n"; };
if (!window.console) { window.console = { log : log, contents : contents }; }
else {
	if (!window.console.log) {
		window.console.log = log;
		if (!window.console.contents) { window.console.contents = contents; }
	}
}

// #############################################################################
// #### AND... DONE. ###########################################################
// #############################################################################

addClassName(docEl, 'regenabled');
return reg;

})();



// ARRAY COMPATIBILITY FUNCTIONS FOR JavaScript 1.6

(function(){

	var ap = Array.prototype;

	/**
	// create a new array with some items filtered out
	foo = [1,2,3,4,5];
	bar = foo.filter(function(x){return x%2==0;});
	// bar now equals [2,4]
	*/
	if (!ap.filter) {
		ap.filter = function(fun) {
			var len = this.length >>> 0;
			if (typeof fun != "function") { throw new TypeError(); }
			var res = new Array();
			var thisp = arguments[1];
			for (var i=0; i<len; i++) {
				if (i in this) {
					var val = this[i]; // in case fun mutates this
					if (fun.call(thisp, val, i, this)) { res.push(val); }
				}
			}
			return res;
		};
	}

	/**
	// runs a function against each item in array
	foo = ['potatoes','celery']
	foo.forEach(function(x){console.log("I like "+x);});
	// prints:
	// I like potatoes
	// I like celery
	*/
	if (!ap.forEach) {
		ap.forEach = function(fun) {
			var len = this.length >>> 0;
			if (typeof fun != "function") { throw new TypeError(); }
			var thisp = arguments[1];
			for (var i=0; i<len; i++) {
				if (i in this) { fun.call(thisp, this[i], i, this); }
			}
		};
	}

	/**
	// does the given function return true for every item in the array?
	foo = [4,8,6,1]
	function isEven(x){return x%2==0;}
	allEven = foo.every(isEven);
	// allEven is false
	*/
	if (!ap.every) {
		ap.every = function(fun) {
			var len = this.length >>> 0;
			if (typeof fun != "function") { throw new TypeError(); }
			var thisp = arguments[1];
			for (var i=0; i<len; i++) {
				if (i in this && !fun.call(thisp, this[i], i, this)) { return false; }
			}
			return true;
		};
	}

	/**
	// create a new array based on this array
	foo = [1,2,3];
	bar = foo.map(function(x){return x+"";});
	// bar now equals ["1","2","3"]
	*/
	if (!ap.map) {
		ap.map = function(fun) {
			var len = this.length >>> 0;
			if (typeof fun != "function") { throw new TypeError(); }
			var res = new Array(len);
			var thisp = arguments[1];
			for (var i=0; i<len; i++) {
				if (i in this) { res[i] = fun.call(thisp, this[i], i, this); }
			}
			return res;
	  	};
	}

	/**
	// does the given function return true for at least one item in the array?
	foo = [4,8,6,1]
	function isOdd(x){return x%2==1;}
	someOdd = foo.some(isOdd);
	// someOdd is true
	*/
	if (!ap.some) {
		ap.some = function(fun) {
			var i = 0, len = this.length >>> 0;
			if (typeof fun != "function") { throw new TypeError(); }
			var thisp = arguments[1];
			for (; i<len; i++) {
				if (i in this && fun.call(thisp, this[i], i, this)) { return true; }
			}
			return false;
		};
	}

})();


reg.importAll();//this adds things like addClassName() to global namespace

// BROWSER SNIFF
var is = new ottosniff();
function ottosniff(){
	var ua = navigator.userAgent.toLowerCase();
	var b = navigator.appName;
	if (b=="Netscape") this.b = "ns";
	else this.b = b;
	this.version = navigator.appVersion;
	this.v = parseInt(this.version);
	this.gecko = /\bgecko\/(20\d\d)(\d\d)(\d\d)/.test(ua);
	this.ns = (this.b=="ns" && this.v>=5);
	this.op = (ua.indexOf('opera')>-1);
	this.safari = (ua.indexOf('safari')>-1);
	this.safariAll = (ua.indexOf('safari')>-1);
	this.op7 = (this.op && this.v>=7 && this.v<8);
	this.op78 = (this.op && this.v>=7 || this.op && this.v>=8);
	this.ie5 = (this.version.indexOf('MSIE 5')>-1);
	this.ie6 = (this.version.indexOf('MSIE 6')>-1);
	this.ie7 = (this.version.indexOf('MSIE 7')>-1);
	this.ie8 = (this.version.indexOf('MSIE 8')>-1);
	this.ie56 = (this.ie5||this.ie6);
	this.ie567 = (this.ie5||this.ie6||this.ie7);
	this.ie = (this.ie5||this.ie6||this.ie7||this.ie8);
	this.iewin = (this.ie56 && ua.indexOf('windows')>-1 || this.ie7 && ua.indexOf('windows')>-1);
	this.iemac = (this.ie56 && ua.indexOf('mac')>-1);
	this.moz = (ua.indexOf('mozilla')>-1);
	this.ff = (ua.indexOf('firefox')>-1);
	this.moz13 = (ua.indexOf('mozilla')>-1 && ua.indexOf('1.3')>-1);
	this.oldmoz = (ua.indexOf('sunos')>-1 || this.moz13 && !this.ff || this.moz && ua.indexOf('1.4')>-1 && !this.ff || this.moz && ua.indexOf('1.5')>-1 && !this.ff || this.moz && ua.indexOf('1.6')>-1 && !this.ff);
	this.anymoz = this.gecko;
	this.ns6 = (ua.indexOf('netscape6')>-1);
	this.geckoAtOrAbove=function(vString){
		var gVer = (this.gecko) ? ua.substring(ua.indexOf("; rv:")+5, ua.indexOf(") gecko")) : '';
		var t=gVer.split(".");
		var v=vString.split(".");
		while(t.length<v.length){t.push("0");}
		while(v.length<t.length){v.push("0");}
		for(var i=0;i<v.length;i++){
			var ti=parseInt(t[i]),vi=parseInt(v[i]);
			if(ti==vi){continue;}
			else return (ti>vi);
		}
		return true;
	}
}



// RTL SNIFF
var rtl = (document.documentElement.lang.indexOf('he') > -1 && document.documentElement.lang.indexOf('IL'))? true : false;
if(rtl){
	addClassName(document.documentElement, 'rtl');
}

// ADD BROWSER CLASS TO HTML TAG
if(is.op){var bclass = "browserOpera";}
else if(is.safariAll){var bclass = "browserSafari";}
else if(is.ie56){var bclass = "browserExplorer56 browserExplorer";}
else if(is.ie7){var bclass = "browserExplorer7 browserExplorer";}
else if(is.iemac){var bclass = "browserExplorerMac";}
else if(is.oldmoz){var bclass = "browserOldMoz";}
else {var bclass = "";}
if(is.gecko){bclass += " gecko";}
if(is.safari||is.geckoAtOrAbove("1.9")){bclass += " radius";}else{bclass += " noradius";}
bclass += " jsenabled";
addClassName(document.documentElement, bclass);

// SHUTOFF
// 2014-12-22
// All variables in shutoff except for global: false => true

if(typeof shutoff=='undefined'){var shutoff={global:false,share:true,pop:true,misc:true};}

// GLOBAL SHUTOFF
if(!shutoff.global){
	reg.setup("div.a1r2 span.toolbarlinks > a,div.a1r2 span.siteid > a",sniffA1);
	reg.setup("div#a5 a",sniffA5);
	reg.focus("input#searchfield,input.searchfield",function(){addClassName(this, 'sfieldfocused');},function(){removeClassName(this, 'sfieldfocused');});
	reg.focus("div#a5 > ul li.hasmenu",function(){addClassName(this,'a5show');gebtn('div',this)[0].style.top=((gebtn('div',this)[0].offsetHeight * -1)) + 4 +'px';},function(){removeClassName(this,'a5show');});
	reg.hover("div#a5 > ul li.hasmenu",function(){addClassName(this,'a5show');gebtn('div',this)[0].style.top=((gebtn('div',this)[0].offsetHeight * -1)) + 4 +'px';},function(){removeClassName(this,'a5show');});
	reg.hover("div.a5menu",function(){addClassName(this.parentNode,'a5show')},function(){removeClassName(this,'a5show');});
	reg.setup("td.navlinks > div",sniffA2);
	reg.hover("ul#mtopics",function(){
		if(!a2['ent']){
			reg.setup("ul#mtopics > li",sniffA2);
			reg.rerun(this);
		}
	});
	reg.focus("ul#mtopics",function(){
		if(!a2['ent']){
			reg.setup("ul#mtopics > li",sniffA2);
			reg.rerun(this);
		}
	});
	if(is.ie56){
		reg.hover("ul#mtopics > li",function(){addClassName(this, 'a2mshow');},function(){removeClassName(this, 'a2mshow');});
		reg.hover("td.navlinks",function(){addClassName(this, 'a2mshow');},function(){removeClassName(this, 'a2mshow');}, 5);
	}

	//  do goto set up for a2v8 if misc is set to false
	if(shutoff.misc){
		reg.preSetup(function(){
			var a2v8 = gebi('a2v8');
			if (!a2v8) { return; }
			reg.setup("select.goto, select.showDiv",sniffGoto);
			reg.setup("ul.goto, ul.showDiv",sniffGotoUL);
		});
	}
}

// POPUP SHUTOFF
if(!shutoff.pop){
	reg.click('.k5, .media-popin',k5Click);
	reg.click('.k5close',k5Close);
	reg.click('.k5softclose',k5SoftClose);
	reg.key('html',function(e){if(27==e.keyCode){k5Close();}});
	reg.setup("@class*='k2ajax-'",sniffK2ajax);
	reg.setup("@class*='k2over', @class*='k2focus', @class*='k2cl', @class*='k2show', @class*='k2hide'",sniffK2);
	reg.setup(".modal-launch",sniffModal);
}

// BLUR OUT
reg.focus("body",blurOut);
var blurIt=[];
function blurOut(ev){
	var obj = this;
	t = getTarget(ev);
	var b = blurIt;
	blurIt=[];
	for(var i=0; i<b.length; i++){
		if(!hasParent(t,b[i][0])){
			if(b[i][1] == 'hidden'){
				b[i][0].style.visibility='hidden';
			}else if(b[i][1]){
				removeClassName(b[i][0],b[i][1]);
			}else{
				b[i][0].style.display='none';
			}
		}else{
		 	blurIt.push(b[i]);
		}
	}
}

// POP UP
reg.click('a.popup, area.popup, a.media-launch',bubblePop);
function bubblePop(e){
	var link = this;
	if (hasClassName(link, 'media-launch') && !matchClassName(link, '[0-9]+x[0-9]+')){
		addClassName(link,'662x652');
	}
	var popW = '820';
	var popH = '600';
	var param = ['no',0,0,0,0,0,0,'',''];
	var popUrl = link.href;
	if (link.target) { var popTarget = link.target; }
	else { var popTarget = "newpopup"; }
	var cls = link.className.split(' ');
	for (var v=0;v<cls.length;v++){
		if (cls[v].search('[0-9]+x[0-9]+') > -1){
			var f = cls[v].split('x');
			popW = f[0];
			popH = f[1];
		}else if(cls[v].indexOf("name-") == 0){
			var f = cls[v].split('name-');
			popTarget = f[1];
		}else if(cls[v] == "scrolling"){
			var param = ['yes',1,0,0,0,0,0];
		}else if(cls[v] == "full"){
			var param = ['yes',1,1,1,1,1,1];
		}else if(cls[v].indexOf("yes_") == 0 || cls[v].indexOf("no_") == 0){
			var f = cls[v].split('_');
			f[1] = "f"+f[1];
			var param = f[1].split('');
			param[0] = f[0];
		}
		if(link.className.indexOf("centerpop") > 1){
			param[7] = screen.availHeight/2 - popH/2;
			param[8] = screen.availWidth/2 - popW/2;
		}
	}
	openPopup(popUrl,popTarget,popW,popH,param[0],param[1],param[2],param[3],param[4],param[5],param[6],param[7],param[8]);
	cancelDefault(e);
}
function openPopup(url,name,width,height,resizable,scrollbars,menubar,toolbar,location,directories,status,top,left) {
	var tl = (top && left) ? ',top=' + top +',left=' + left : '';
	var popup = window.open(url, name, 'width=' + width + ',height=' + height + ',resizable=' + resizable + ',scrollbars=' + scrollbars	+ ',menubar=' + menubar + ',toolbar=' + toolbar + ',location=' + location + ',directories=' + directories + ',status=' + status+tl);
	popup.focus();
}

// AUTOCLEAR
reg.focus("input.autoclear,input#searchfield,input.searchfield",autoclearFocus,autoclearBlur);
function autoclearFocus(){
	if(this.value == this.defaultValue) {
		this.value = '';
		addClassName(this, 'autocleared');
	}
}
function autoclearBlur(){
	if(this.value=='') {
		this.value = this.defaultValue;
		removeClassName(this, 'autocleared');
	}
}

// DISABLE SEACH IF NO SEARCH STRING
reg.submit("div.a2search form",function(e){
	i = gebs("input.searchfield,input#searchfield",this);
	if (i[0].value == '' || i[0].value == i[0].defaultValue){
		i[0].value = '';
		cancelDefault(e);
	}
});

// A1
var a1 = [];
a1['x'] = 1;
function sniffA1(){
	var link = this;
	oldA1Content(); // LEGACY
	var a1w  = ['<div class="a1menux1"></div>\n<div class="a1menuw2"><div class="a1menuw1">\n','</div><div class="a1menux2"></div></div>'];
	if(!a1['ent']){
		for (key in a1) {
			var d = elem('div');
			d.innerHTML = key;
			a1[d.innerHTML] = a1[key];
		}
		a1['ent'] = true;
	}
	var linkText = link.innerHTML.normalize();
	var a1id = "a1menu"+a1['x'];
	a1['x']++;
	if (hasClassName(link, 'language-select')){
		link.relativePos = true;
		var d = elem('div.a1menu');
		addClassName(link, 'k2over-languageselector y3 x-10');
		d.id = 'languageselector';
		d.style.width = "170px"
		d.innerHTML = a1w[0]+'<h5></h5><div></div>'+a1w[1];
 		link.parentNode.insertBefore(d,link.nextSibling);
		sniffK2.call(link);
 		sniffSiteSelector(link.parentNode);
	}else if(a1[linkText]){
		link.relativePos = true;
		var d = elem('div.a1menu');
		addClassName(link, 'karrow');
		addClassName(link, 'k2over-'+a1id+' y3 x-6');
		if (hasClassName(link, "a1cart")){
			link.innerHTML = '<span class="carticon small">'+link.innerHTML+'</span>';
			link.style.paddingLeft = "0px";
		}
		if(a1[linkText].indexOf('a1-2col') > -1){
			var wc = 'a1Large';
		}else if(a1[linkText].indexOf('<p>') > -1){
			var wc = 'a1Medium';
		}else{
			var wc = 'a1Small';
		}
		d.id = a1id;
		addClassName(d,wc);
		d.innerHTML = a1w[0]+a1[linkText]+a1w[1];
		link.parentNode.insertBefore(d,link.nextSibling);
		sniffK2.call(link);
	}
}

// A1 LEGACY
var a1hrefs = [];
var a1menus = [];
function oldA1Content(){
	var k;
	for (k in a1hrefs){
		a1[a1hrefs[k][0]] = a1menus[k][1];
	}
	a1hrefs = a1menus = [];
}

// A2
var a2 = [];
function sniffA2(){
	var fobj = this;
	var sall=(typeof ltxt=='undefined')?seeall:ltxt.seeall;
	if(navmenu['1.0']) oldA2Content(); // LEGACY
 	if(gebi('ip1')) oldA2TableFix(); // LEGACY
	if(!a2['ent']){
		for (key in a2) {
			var d = elem('div');
			d.innerHTML = key;
			a2[d.innerHTML.strip()] = a2[key];
		}
		a2['ent'] = true;
	}
	var firstA = gebtn('a',fobj)[0];
	var n = firstA.innerHTML.normalize();
	if(a2[n]){
		var h = firstA.href;
		addEvent(firstA, 'focus', function(){
			if(this.parentNode.nodeName.toLowerCase() == 'li'){
				addClassName(this.parentNode, 'a2mshow');
				blurIt.push([this.parentNode,'a2mshow']);
			}else{
				addClassName(this.parentNode.parentNode, 'a2mshow');
				blurIt.push([this.parentNode.parentNode,'a2mshow']);
			}
		});
		var d = elem('div.a2m',{});
		d.style.marginLeft = (rtl)?'-'+(204 - fobj.offsetWidth)+'px':'-20px';
		var u = elem('ul',{});
		var a = elem('a',{'href':h});
		a.innerHTML = sall+' &#187;';
		var l =  elem('li',{});
		if (h.indexOf('#') < 0 && h.split('#')[1] != '' && a2[n].indexOf('<!-- no see all -->') < 0) {
			l.appendChild(a);
		}
		u.innerHTML = a2[n];
		u.appendChild(l);
		d.appendChild(u);
		fobj.appendChild(d);
		addClassName(gebtn('li',fobj)[0], 'firstchild');
	}else if(fobj.nodeName.toLowerCase() == 'li'){
		addClassName(fobj, 'a2nomenu');
	}else{
		addClassName(fobj.parentNode, 'a2nomenu');
	}
}

// A2 LEGACY
var navmenu = [];
var oldmenu = [];
function popfly(){}
function closefly(){}
function prepmenus(){}
function printmenus(){}
function oldA2Content(){
	var x = 1;
	while(x < 10){
		if(navmenu[x+'.0'] && !a2[navmenu[x+'.0'].split('|')[0]]){
			var xx = 1;
			var li = '';
			while(navmenu[x+'.'+xx]){
				li += '<li><a href="'+navmenu[x+'.'+xx].split('|')[1]+'">'+navmenu[x+'.'+xx].split('|')[0]+'</a></li>\n';
				xx++;
			}
			a2[navmenu[x+'.0'].split('|')[0]] = li;
		}
		if(oldmenu[x+'.0'] && !a2[oldmenu[x+'.0'].split('|')[0]]){
			var xx = 1;
			var li = '';
			while(oldmenu[x+'.'+xx]){
				li += '<li><a href="'+oldmenu[x+'.'+xx].split('|')[1]+'">'+oldmenu[x+'.'+xx].split('|')[0]+'</a></li>\n';
				xx++;
			}
			a2[oldmenu[x+'.0'].split('|')[0]] = li;
		}
		x++;
	}
	navmenu = oldmenu = [];
}
function oldA2TableFix(){
	var x = 1;
	while (gebi('ip'+x)){
		var td = gebi('ip'+x).parentNode;
		td.parentNode.removeChild(td);
		x++;
	}
}

// A5
var a5 = [];
function sniffA5(){
	var a5w  = ['<div class="a5menuw2"><div class="a5menuw1">\n','</div></div><div class="a5menux2"></div>'];
	if(!a5['ent']){
		for (key in a5) {
			var d = elem('div');
			d.innerHTML = key;
			a5[d.innerHTML] = a5[key];
		}
		a5['ent'] = true;
	}
	var linkText = this.innerHTML.normalize();
	if(a5[linkText]){
		var d = elem('div.a5menu');
		d.innerHTML = a5w[0]+a5[linkText]+a5w[1];
		addClassName(this.parentNode, 'hasmenu');
		this.parentNode.insertBefore(d,this.nextSibling);
	}
}

// K2
ked = [];
function sniffK2(shownow){
	var fobj = this;
	var pdoc = document;
	fobj.prp = [0,0,0,"","",""];
	fobj.className = fobj.className.replace(/(k2over) +/,"$1-");
	fobj.className = fobj.className.replace(/(k2click) +/,"$1-");
	fobj.className = fobj.className.replace(/(k2focus) +/,"$1-");
	fobj.className = fobj.className.replace(/(k2close) +/,"$1-");

	var cls = fobj.className.split(' ');

	if(fobj.className.indexOf("k2ajaxload") > -1 && fobj.href && gebtn('div',document.body)[0] ){
		for (var v=0;v<cls.length;v++){
			if (cls[v].indexOf("k2over") > -1 || cls[v].indexOf("k2click") > -1 || cls[v].indexOf("k2focus") > -1){
				var k2id = cls[v].split('-');
				if (!k2id[2]){
					k2id[2] = k2id[1];
				}
			}
		}
		var link = document.createElement('a');
		link.className = 'loadUrl';
		link.href = fobj.href+'#'+k2id[2];
		if(!gebi(k2id[2])){
			var div = document.createElement('div');
			div.className = 'g32auto';
			div.id = k2id[2];
			div.appendChild(link);
			gebtn('div',document.body)[0].appendChild(div);
		}
	}


	for (var v=0;v<cls.length;v++){
		if (cls[v].indexOf("k2over") > -1 || cls[v].indexOf("k2click") > -1 || cls[v].indexOf("k2focus") > -1){
			var p_objs = fobj.aob = cls[v].split('-');
			if (!p_objs[2]){
				fobj.aob[2] = p_objs[2] = p_objs[1];
				fobj.aob[1] = fobj;
			}
			kpop = gebi(p_objs[2]);
			kpop.kp_objs = p_objs[2];
			kpop.kp_trig = p_objs[1];
		}else if (cls[v].indexOf("k2close") > -1){
			fobj.aob = cls[v].split('-');
		}else if (cls[v].indexOf("x") == 0){
			fobj.prp[0] = (cls[v].substring(1) * 1) + fobj.prp[0];
		}else if (cls[v].indexOf("y") == 0){
			fobj.prp[1] = (cls[v].substring(1) * 1) + fobj.prp[1];
		}else if (cls[v].indexOf("z") == 0){
			fobj.prp[2] = (cls[v].substring(1) * 1);
		}else if (cls[v].indexOf("pAbsolute") == 0){
			fobj.prp[3] = (cls[v].substring(1));
		}else if (cls[v].indexOf("vBottom") == 0 || cls[v].indexOf("vTop") == 0 || cls[v].indexOf("vMiddle") == 0 || cls[v].indexOf("vAlignTopBottom") == 0){
			fobj.prp[4] = cls[v];
		}else if (cls[v].indexOf("hRight") == 0 || cls[v].indexOf("hMiddleRight") == 0 || cls[v].indexOf("hLeft") == 0 || cls[v].indexOf("hMiddleLeft") == 0 || cls[v].indexOf("hMiddle") == 0 || cls[v].indexOf("hAlignRight") == 0){
			fobj.prp[5] = cls[v];
		}
	}
	if (fobj.aob[0].indexOf("k2over") > -1){
		addEvent(fobj,"mouseover",function(){
			showK2(this.aob[2],this.aob[1],this.prp[0],this.prp[1],this.prp[2],this.prp[3],this.prp[4],this.prp[5]);
		});
		if (!hasClassName(fobj, "mOverOff")){
			addEvent(kpop,"mouseover",function(){
				showK2(this.kp_objs);
			});
		}
		addEvent(kpop,"mouseout",function(){
			hideK2(this.kp_objs);
		});
		addEvent(fobj,"mouseout",function(){
			hideK2(this.aob[2]);
		});
		addEvent(fobj,"focus",function(){
			showK2(this.aob[2],this.aob[1],this.prp[0],this.prp[1],this.prp[2],this.prp[3],this.prp[4],this.prp[5]);
			blurIt.push([gebi(this.aob[2]),'hidden']);
		});

		if(shownow){
			showK2(fobj.aob[2],fobj.aob[1],fobj.prp[0],fobj.prp[1],fobj.prp[2],fobj.prp[3],fobj.prp[4],fobj.prp[5]);
			return false;
		}
	}else if (fobj.aob[0] == "k2click"){
		addEvent(fobj,"click",function(e){
			showK2(this.aob[2],this.aob[1],this.prp[0],this.prp[1],this.prp[2],this.prp[3],this.prp[4],this.prp[5]);
			addK2(this.aob[2],this.aob[1],this.prp[0],this.prp[1],this.prp[2],this.prp[3],this.prp[4],this.prp[5]);
			cancelDefault(e);
			return false;
		});
		if(shownow){
			showK2(fobj.aob[2],fobj.aob[1],fobj.prp[0],fobj.prp[1],fobj.prp[2],fobj.prp[3],fobj.prp[4],fobj.prp[5]);
			addK2(fobj.aob[2],fobj.aob[1],fobj.prp[0],fobj.prp[1],fobj.prp[2],fobj.prp[3],fobj.prp[4],fobj.prp[5]);
			return false;
		}
	}else if (fobj.aob[0] == "k2focus"){
		addEvent(fobj,"focus",function(){
			showK2(this.aob[2],this.aob[1],this.prp[0],this.prp[1],this.prp[2],this.prp[3],this.prp[4],this.prp[5]);
			addK2(this.aob[2],this.aob[1],this.prp[0],this.prp[1],this.prp[2],this.prp[3],this.prp[4],this.prp[5]);
		});
		addEvent(fobj,"blur",function(){
			hideK2(this.aob[2],1);
		});
	}else if (fobj.aob[0] == "k2close"){
		addEvent(fobj,"click",function(e){
			hideK2(this.aob[1],1);
			cancelDefault(e);
		});
	}
	fobj.className = fobj.className.replace(/(k2over)-|(k2focus)-|(k2cl...)-/,"$1 ");
}
function showK2(popupID,callerID,Xoffset,Yoffset,Zindex,posy,btmup,ort,etype){
	var popupObj = gebi(popupID);
	if (!popupObj){
		var popupObj = popupID;
	}
	if (callerID){
		var ptop = plft = 0;
		var callerObj = gebi(callerID);
		if (!callerObj){
			var callerObj = callerID;
		}

		if (ort == "hLeft"){
			plft = plft - popupObj.offsetWidth;
		}else if (ort == "hMiddleLeft"){
			plft = plft - popupObj.offsetWidth;
			plft = plft + parseInt(callerObj.offsetWidth / 2);
		}else if (ort == "hMiddle"){
			plft = parseInt(callerObj.offsetWidth / 2);
			plft = plft - parseInt(popupObj.offsetWidth / 2);
		}else if (ort == "hMiddleRight"){
			plft = parseInt(callerObj.offsetWidth / 2);
		}else if (ort == "hRight"){
			plft = callerObj.offsetWidth;
		}else if (ort == "hAlignRight"){
			plft = plft + callerObj.offsetWidth - popupObj.offsetWidth;
		}

		if (btmup == "vTop"){
			ptop = ptop - popupObj.offsetHeight;
		}else if (btmup == "vMiddle"){
			ptop = ptop + parseInt(callerObj.offsetHeight / 2);
			ptop = ptop - parseInt(popupObj.offsetHeight / 2);
		}else if (btmup == "vBottom"){
			ptop = ptop + callerObj.offsetHeight;
		}else if (btmup == "vAlignBottom"){
			ptop = ptop + callerObj.offsetHeight - popupObj.offsetHeight;
		}else if (btmup == "vAlignTopBottom"){
			var scrolltop = 0;
			if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
				scrolltop = document.body.scrollTop;
			}else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop)){
				scrolltop = document.documentElement.scrollTop;
			}
			var winheight = 0;
			if( typeof( window.innerWidth ) == 'number' ) {
				winheight = window.innerHeight;
			} else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
				winheight = document.documentElement.clientHeight;
			}
			var alignbottom = callerObj.offsetHeight - popupObj.offsetHeight;
		}
		if (is.safari && posy == "Absolute"){
			if (posy != "Absolute"){
				callerObj.style.position = "relative";
			}
			getXY(callerObj.offsetParent);
		}else{
			getXY(callerObj);
		}

		ptop = ptop + callerObj.Y;
		plft = plft + callerObj.X;
		if (btmup == "vAlignTopBottom" && ptop > scrolltop + (winheight/2)){
			ptop = ptop + alignbottom;
			Yoffset = Yoffset * -1;
		}
		plft = plft + Xoffset;
		ptop = ptop + Yoffset;
		popupObj.style.top=ptop+'px';
		popupObj.style.left=plft+'px';
	}
	if (Zindex){
		popupObj.style.zIndex = Zindex;
	}
	popupObj.style.visibility = "visible";
}
function hideK2(popupID,popcls,fader){
	var popupObj = gebi(popupID);
	if (!popupObj){
		var popupObj = popupID;
	}
	popupObj.style.visibility = "hidden";
	if (popcls){
		ked[popupID] = "";
	}
}
function addK2(p0,p1,p2,p3,p4,p5,p6,p7){
	ked[p0] = [p0,p1,p2,p3,p4,p5,p6,p7];
}
addEvent(window, 'resize', function(){
	var kdp;
	for (kdp in ked){
		if (ked[kdp][0]){
			showK2(ked[kdp][0],ked[kdp][1],ked[kdp][2],ked[kdp][3],ked[kdp][4],ked[kdp][5],ked[kdp][6],ked[kdp][7]);
		}
	}
});

// SETUP -> K2 W/ AJAX
function sniffK2ajax(){
	var fobj = this;
	var containerID = fobj.className.split('k2ajax-')[1].split(' ')[0];
	var fileUrl = gebtn('a',gebi(containerID))[0].href;
	var mvnt = (fobj.className.indexOf('k2over-') > -1) ? 'mouseover' : 'click';
	addEvent(fobj,mvnt,function(){
		if(gebi(containerID).innerHTML.indexOf('getUrl') > -1){
			var fvars = [containerID,fobj];
			getfile(fileUrl,function(rdata,fvar){
				if(rdata.indexOf('contentchunk') > -1){
					rdata = getRequestObject('contentchunk',rdata).innerHTML;
				}
				gebi(fvar[0]).innerHTML = rdata;
				reg.rerun(gebi(fvar[0]));
				sniffK2.call(fvar[1],true);
			},fvars);
		}
	});
}

// SETUP -> K4
function sniffModal(){
	var fobj = this;
	if (hasClassName(fobj, "modal-launch")){
		var matches = fobj.className.match(/launch\-id\-([a-z0-9_-]+)/);
		if (!matches) { return; }
		else { fobj.modalId = matches[1]; }
		fobj.onclick = function(e){
			showK4(this.modalId);
			return false;
		};
	}
}
function showK4(id){
	var div = gebi(id);
	if (!div) { return; }
	removeClassName(div, "k4hidden");
	var inputs = gebtn("input",div);
	for (var a=0;a<inputs.length;a++){
		if (inputs[a].type == 'text'){
			inputs[a].focus();
			break;
		}
	}
	if (is.ie6){
		var selects = gebtn("select");
		for (var a=0;a<selects.length;a++){
			addClassName(selects[a], 'k4in-effect');
		}
	}
}
function hideK4(id){
	var div = gebi(id);
	addClassName(div, "k4hidden");
	if (is.ie6){
		var selects = gebtn("select");
		for (var a=0;a<selects.length;a++){
			removeClassName(selects[a], 'k4in-effect');
		}
	}
}
function modalClose(e){
	var k4 = this.parentNode;
	while (!hasClassName(k4, 'k4') && k4.parentNode) { k4 = k4.parentNode; }
	if (hasClassName(k4, 'k4') && k4.id) { hideK4(k4.id); }
	return false;
}

// SETUP -> COUNTRY & LANGUAGE SELECTOR
function sniffSiteSelector(span) {
	var lnks = gebtn('a',span);
	for (var a=0; a<lnks.length; a++) {
		var lnk = lnks[a];
		if (hasClassName(lnk, 'country-select')) {
			addClassName(lnk,'modal-launch launch-id-country-selector');
			sniffModal.call(lnk);
			var k4 = elem('div',{'class':'k4 k4v1 k4hidden','id':'country-selector'});
			k4.innerHTML = '<div class="k4w1"><div class="k4w2"><div class="k4w3"><div class="k4w4"><div class="k4title"><h2>'
				+'</h2><p class="modal-extra"><a href="" class="modal-close">[X]</a></p></div><div class="k4body">'
				+'</div></div></div></div></div>';
			k4.setTitle=function(txt){gebtn('h2',this)[0].innerHTML=txt;};
			k4.setBody=function(txt){gebtn('div',this)[5].innerHTML=txt;};
			document.body.appendChild(k4);
			addEvent(lnk, 'click', function(){
				var thisHref = this.href;
				try {
					getfile(this.href, function(rdata,fvar){
						try {
							var headingText = elemText(getRequestObject('country-data-title',rdata,'h2'));
							var bodyText = getRequestObject('country-data',rdata).innerHTML;
						} catch (ex) { window.location = thisHref; }
						k4.setTitle(headingText);
						k4.setBody(bodyText);
					});
				} catch (e) { window.location = thisHref; }
			});
		} else if (hasClassName(lnk, 'language-select')) {
			var k2 = gebi('languageselector');
			k2.setTitle=function(txt){gebtn('h5',this)[0].innerHTML=txt;};
			k2.setBody=function(txt){gebtn('div',this)[3].innerHTML=txt;};
			addEvent(lnk, 'mouseover', function(){
				var thisHref = this.href;
				try {
					getfile(this.href, function(rdata,fvar){
						try {
							var headingText = elemText(getRequestObject('language-data-title',rdata,'h2'));
							var bodyText = getRequestObject('language-data',rdata).innerHTML;
						} catch (ex) {
							k2.setTitle('no data');
							return;
						}
						k2.setTitle(headingText);
						k2.setBody(bodyText);
					});
				} catch (e) { window.location = thisHref; }
			});
		}
	}
}

// K5 ONLOAD
reg.postSetup(function(){
	var k5onload = gebi('k5onload');
	if(!k5onload){return;}
	k5Click.call(k5onload);
});

// K5 FUNCTIONS
function pauseAll() {
	window.paused = true;
	addClassName(document.body,'paused');
}
function resumeAll() {
	window.paused = false;
	removeClassName(document.body,'paused');
}

function k5Click() {

	var thisHref = this.href;
	if (reg.matches(this,'div.k5')) { return; }
	k5Close(); // close any open k5s

	// get id ##############################
	var idMatches = matchClassName(this,/^id-(\S+)$/);
	if (idMatches) {
		var id = idMatches[1];
	} else if (thisHref && thisHref.indexOf('#')!=-1) {
		var id = thisHref.substring(thisHref.indexOf('#')+1);
	}else{
		throw new Error('no id value was specified for k5 object. className "id-someId" or URL anchor reference "...page.html#someId"');
	}

	// mode ################################
	var k5DivClass = 'k5 k5empty';
	var isVid,isInf,isLog,isMed,isInterrupt,interruptParent=getParent(this,'.k5interrupt');
	if     (hcn(this,'k5interrupt')||interruptParent){k5DivClass+=' k5interrupt';      isInterrupt=true;}
	if     (hcn(this,'k5vid'))                       {k5DivClass+=' k5vid';            isVid=true;}
	else if(hcn(this,'k5login'))                     {k5DivClass+=' k5login';          isLog=true;}
	else if(hcn(this,'k5media'))                     {k5DivClass+=' k5media hijax-'+id;isMed=true;}
	else if(hcn(this,'k5info'))                      {k5DivClass+=' k5info';           isInf=true;}

	// title string ########################
	var titleText = (this.title) ? this.title : elemText(this);
	if (!titleText) { titleText = ' '; }

	// [x] image ###########################
	if     (isLog){var closeImgAtts={'title':'close','alt':'close','src':imdir+'/k5login_x.gif',         'border':'0','width':'21','height':'21'};}
	else if(isInf){var closeImgAtts={'title':'close','alt':'close','src':imdir+'/k5info_x.gif',          'border':'0','width':'21','height':'21'};}
	else          {var closeImgAtts={'title':'close','alt':'close','src':imdir+'/ic_close_win_big_x.gif','border':'0','width':'30','height':'19'};}

	// #####################################
	if (interruptParent) {
		this.continueTo = interruptParent.continueTo;
		this.submitTo = interruptParent.submitTo;
		this.thankYouHref = interruptParent.thankYouHref;
	}

	// #####################################
	var titleEl = elem('h2.k5title',null,titleText);
	var close = elem('span.'+(isInterrupt?'k5skip':'k5close'),null,elem('img',closeImgAtts));//send them on their way?
	var closePara = elem('p.k5closer',null,close);
	var k5w2 = elem('div.k5w2');
	var k5w1 = elem('div.k5w1',null,[titleEl,closePara,k5w2]);
	var k5shadow = elem('div.k5shadow');
	k5shadow.innerHTML = '<table><tr><td class="tl"></td><td class="tc"></td><td class="tr"></td></tr><tr><td class="ml"></td><td class="mc"></td><td class="mr"></td></tr><tr><td class="bl"></td><td class="bc"></td><td class="br"></td></tr></table>';
	var k5Div = elem('div#k5',{'class':k5DivClass},[k5w1,k5shadow]);
	if (this.continueTo) { k5Div.continueTo = this.continueTo; }
	if (this.submitTo) { k5Div.submitTo = this.submitTo; }
	if (this.thankYouHref) { k5Div.thankYouHref = this.thankYouHref; }

	// #####################################
	k5shadow.position=function(width,height){
		width-=33;
		height-=29;
		var centerStyle = gebcn('mc',k5shadow)[0].style;
		centerStyle.width=width+'px';
		centerStyle.height=height+'px';
		this.style.top=(-31-height)+'px';
		this.style.left='8px';
	};

	// #####################################
	k5w1.centerOnScreen = function() {
		var docEl = document.documentElement, w = window;
		if (!this.vHeight) { this.vHeight = (w.innerHeight) ? w.innerHeight : docEl.clientHeight; }
		if (!this.vWidth) { this.vWidth = (w.innerWidth) ? w.innerWidth : docEl.clientWidth; }
		var thisHeight = this.offsetHeight;
		var thisWidth = this.offsetWidth;
		var distance = ((this.vHeight / 2) - (thisHeight / 2)) * .666;
		if (distance < 0) {
			distance = 0;
			this.style.height = (this.vHeight - 20)+'px';
			this.style.overflow = 'auto';
		}
		if (thisWidth > this.vWidth) {
			this.style.width = (this.vWidth - 40) + 'px';
			this.style.overflow = 'auto';
		}
		this.style.marginTop = distance+"px";
	};

	// #####################################
	k5w1.setContent = function(contentEl) {
		contentEl.style.visibility = 'hidden';
		k5shadow.style.visibility = 'hidden';
		removeClassName(k5Div, 'k5empty');
		removeClassName(contentEl, 'hidethis');

		var customTitles = gebcn('k5customtitle',contentEl);
		if (customTitles && customTitles.length > 0) {
			var customTitle = customTitles[0];
			var customTitleText = elemText(customTitle);
			customTitle.parentNode.removeChild(customTitle);
			titleEl.firstChild.data = customTitleText;
		}

		var xyMatches = matchClassName(contentEl,/^(\d+)(x(\d+))?$/);
		if (xyMatches) {
			if (!k5w1.style.width) { k5w1.style.width = xyMatches[1] + 'px'; }
			if (xyMatches.length > 3 && xyMatches[3] && !k5w2.style.height) { k5w2.style.height = xyMatches[3] + 'px'; }
		}

		k5w2.innerHTML='';
		k5w2.appendChild(contentEl);
		var newHeight = k5w2.offsetHeight;
		this.centerOnScreen();
		contentEl.style.visibility = '';
		window.setTimeout(function(){
			k5shadow.position(k5w1.offsetWidth,k5w1.offsetHeight);
			k5shadow.style.visibility = '';
		}, 40);
	};

	// #####################################
	k5Div.setError = function(title,error,url) {
		removeClassName(this,'k5empty');
		addClassName(this,'k5error');
		k5w1.style.height = 'auto';
		k5w1.style.width = '';
		k5w2.style.height = '';
		error = error || 'Unspecified error';
		title = title || 'Error';
		var titleEl = title ? elem('h5.k5customtitle',{},title) : '';
		var errorEl = elem('p',{},error);
		var urlEl = url ? elem('p',{},""+url) : '';
		k5w1.setContent(elem('div',{'class':'g29 g29v2'},elem('div.g29w1',{},elem('div.g29w2',{},[titleEl,errorEl,urlEl]))));
	};

	// append the node #####################
	k5Div.style.visibility = 'hidden';
	if (is.ie6) {
		var k5ie6bg = elem('div#k5ie6bg');
		document.body.appendChild(k5ie6bg);
	}
	document.body.appendChild(k5Div);
	var xyMatches = matchClassName(this,/^(\d+)(x(\d+))?$/);
	if (xyMatches) {
		k5w1.style.width = xyMatches[1] + 'px';
		if (xyMatches.length > 3 && xyMatches[3]) { k5w2.style.height = xyMatches[3] + 'px'; }
	}
	k5w1.centerOnScreen();
	k5Div.style.visibility = '';

	// set content #########################
	var linkPage = thisHref || location.href;
	if (linkPage.indexOf('http')!==0) { linkPage = resolveUrl(linkPage); }//in case not fully resolved url
	if (linkPage.indexOf('#')!=-1) { linkPage = linkPage.substring(0,linkPage.indexOf('#')); }
	var locPage=location.href;
	if (locPage.indexOf('#')!=-1) { locPage = locPage.substring(0,locPage.indexOf('#')); }
	if (locPage === linkPage) {
		// do local
		var content = gebi(id);
		if (!content) { k5Div.setError('Unable to load content', 'id="'+id+'" not found on this page', linkPage); }
		else { k5w1.setContent(content.cloneNode(true)); }
	} else {
		// do ajax
		try{
			xhr(linkPage, function(responseText){
				// success!
				var content = getElementByIdFromString(responseText, id);
				if (!content) { k5Div.setError('Unable to load content', 'id="'+id+'" not found on remote page', linkPage); }
				else { k5w1.setContent(content); }
			}, function(statusCode, statusText, url){
				// fail!
				var err = statusCode+" "+statusText;
				if (!statusCode) { err = "This could have been caused by attempting to make a cross-domain ajax request. Here's the error message returned by the browser: "+err; }
				k5Div.setError('Unable to load content', err, url);
			});
		} catch (ex) {
			k5Div.setError('Unable to load content', 'XHR FAIL: '+(ex.message||ex), linkPage);
		}
	}

	// set focus ###########################
	try {
		this.blur();
		var fitems = gebs('input@type="text",button,select,textarea', k5Div);
		if (fitems && fitems.length > 0) {
			fitems[0].focus();
		}
	} catch (ex) {}

	// done ################################
	pauseAll();
	return false;
}

function k5Close(e){
	k5SoftClose();
	return false;
}

function k5SoftClose(e){
	var k5Div = gebi('k5');
	if(k5Div){document.body.removeChild(k5Div);}
	var k5ie6bg = gebi('k5ie6bg');
	if(k5ie6bg){document.body.removeChild(k5ie6bg);}
	resumeAll();
}

(function(){
	var done=false;
	window.k5Onload=function(href, id, title, lf, width, height) {
		if (done) { throw new Error("k5Onload called multiple times"); } else { done = true; }
		if (!href) { href = location.href; }
		if (href.indexOf('#') != -1) {
			if (!id) { id = href.substring(href.indexOf('#')+1); }
			href = href.substring(0,href.indexOf('#'));
		}
		href = href + '#' + id;
		var className = 'k5';
		if (width) { className += ' ' + width; }
		if (height) { className += 'x' + height; }
		if (lf) { className += ' ' + lf; }
		var a = elem('a',{'class':className,'href':href},title);
		reg.postSetup(function(){
			window.setTimeout(function(){k5Click.call(a);},200);
		});
	}
})();

(function(){
	var links, done = false;
	function handleIt(el, continueTo, submitTo, matchUrl) {
		if (!done && (done = true)) {
			links = gebs('link@rel="k5interrupt"', gebtn('head')[0]);
		}
		for (var i=0; i<links.length; i++) {
			var link = links[i];
			var patternAtt = link.getAttribute('match');
			var selector = link.getAttribute('select');
			if (!patternAtt && !selector) { continue; }
			var patternAtt = patternAtt || '.?';
			var selector = selector || '*';
			var pattern = new RegExp(patternAtt);
			if (!patternAtt && !selector) { continue; }
			if (!pattern.test(matchUrl) || !matches(el,selector)) { continue; }
			var href = link.href;
			var title = link.getAttribute('title');
			var thankYouHref = link.getAttribute('thanks');
			var dummyLink = elem('a',{'class':link.className+' k5interrupt','href':href},title);
			dummyLink.continueTo = continueTo;
			dummyLink.submitTo = submitTo;
			dummyLink.thankYouHref = thankYouHref;
			try {
				return k5Click.call(dummyLink);
			} catch (ex) {
				console.log("error while calling k5Click(): "+ex.message);
				return true;
			}
		}
	}
	var protocolPatt = /^https?:/;
	var hostPatt = /^\/\//;
	var rootPatt = /^\//;
	var queryPatt = /^\?/;
	var hashPatt = /^#/;
	var l = location;
	var lindex = l.protocol+'//'+l.host+l.pathname;
	lindex = lindex.substring(0,lindex.lastIndexOf('/')+1);
	function resolveUrl(frag,paramString) {
		frag=frag.strip();
		var result = null;
		if (protocolPatt.test(frag))   { result = frag; }
		else if (hostPatt.test(frag))  { result = l.protocol+frag; }
		else if (rootPatt.test(frag))  { result = l.protocol+'//'+l.host+frag; }
		else if (queryPatt.test(frag)) { result = l.protocol+'//'+l.host+l.pathname+frag; }
		else if (hashPatt.test(frag))  { result = l.protocol+'//'+l.host+l.pathname+l.search+frag; }
		else if (!frag)                { result = l.href; }
		else                           { result = lindex + frag; }
		if (paramString) {
			var qind = result.indexOf('?');
			var hind = result.indexOf('#');
			if (qind!=-1) { result=result.substring(0,qind); }
			if (hind!=-1) { result=result.substring(0,hind); }
			result+='?'+paramString;
		}
		return result;
	}
	window.resolveUrl = resolveUrl;

	// interrupt "nag screen" behavior
	reg.click('@href', function(e){
		try { var rhref = resolveUrl(this.href); }
		catch (ex) { console.log(ex.message); return; }
		return handleIt(this, rhref, null, rhref);
	});
	reg.submit('form', function(e){
		try { var raction = resolveUrl(this.action); }
		catch (ex) { console.log(ex.message); return; }
		return handleIt(this, null, this, raction);
	});

	function getLabel(field) {
		var labelEl = getParent(field,'label');
		var id = field.id || field.name;
		if (!labelEl) {
			var labels = gebtn('label');
			for (var i=0;i<labels.length;i++){
				if (labels[i].htmlFor===id) {
					labelEl = labels[i];
					break;
				}
			}
		}
		return (labelEl) ? elemText(labelEl) : id;
	}

	// ajaxify the nag screen form behavior
	reg.submit('.k5interrupt',function(e){
		cancelDefault(e);
		if (!this.continueTo && !this.submitTo) {
			console.log('no continueTo url or submitTo form');
			return false;
		}
		var continueTo = this.continueTo;
		var submitTo = this.submitTo;
		var thankYouHref = this.thankYouHref;
		var classes = this.className;
		var k5Form = getTarget(e);
		var fargs = getFormData(k5Form);
		var url = resolveUrl(k5Form.action);
		var k5Div = this;

		var valMess = validateForm(k5Form);

		if (valMess) {
			if (!hcn(k5Form,"failsilent")) {
				alert(valMess);
			} else {
				k5Close();
				continueTo && (location.href=continueTo);
				submitTo && submitTo.submit();
			}
			return;
		}

		if (k5Form.whichSubmit) {
			k5Form.whichSubmit.value = "sending...";
		}
		try {
			//console.log('sending form results: '+url);
			xhr(url, function(){
				//success
				if (thankYouHref) {
					k5Click.call(elem('a',{'href':thankYouHref,'class':classes},'Thank You'));
					window.setTimeout(function(){
						k5Close();
						continueTo && (location.href=continueTo);
						submitTo && submitTo.submit();
					},2700);
				} else {
					k5Close();
					continueTo && (location.href=continueTo);
					submitTo && submitTo.submit();
				}
			}, function(statusCode, statusText){
				//fail
				if (continueTo) {
					var url = continueTo;
				} else if (submitTo) {
					var url = resolveUrl(submitTo.action,getFormData(submitTo));
				}
				k5Form.appendChild(elem('input',{'type':'hidden','name':'redirect_to','value':url}));
				k5Form.appendChild(elem('input',{'type':'hidden','name':'goto','value':url}));
				k5Form.submit();
				window.setTimeout(function(){k5Close();},100);
			},null,fargs);
		} catch (ex) {
			if (continueTo) {
				var url = continueTo;
			} else if (submitTo) {
				var url = resolveUrl(submitTo.action,getFormData(submitTo));
			}
			k5Form.appendChild(elem('input',{'type':'hidden','name':'redirect_to','value':url}));
			k5Form.appendChild(elem('input',{'type':'hidden','name':'goto','value':url}));
			k5Form.submit();
			window.setTimeout(function(){k5Close();},100);
		}
	});
	// they have chosen to skip the nag screen
	reg.click('.k5skip',function(e){
		var k5Div = gebi('k5');
		if (!k5Div || (!k5Div.continueTo && !k5Div.submitTo)) { return; }
		var continueTo = k5Div.continueTo;
		var submitTo = k5Div.submitTo;
		k5Close();
		continueTo && (location.href=continueTo);
		submitTo && submitTo.submit();
		return false;
	});
	// for easy access to clicked submit button later
	reg.click('.k5interrupt form @type="submit"', function(e){
		if (hcn(this,'k5skip')) { return; }
		var form = getParent(this,'form');
		form.whichSubmit = this;
	});
})();

(function(){
	/**
	get the label string associated with a field element
	*/
	function getLabel(field) {
		var labelEl = getParent(field,'label');
		var id = field.id || field.name;
		if (!labelEl) {
			var labels = gebtn('label');
			for (var i=0;i<labels.length;i++){
				if (labels[i].htmlFor===id) {
					labelEl = labels[i];
					break;
				}
			}
		}
		return (labelEl) ? elemText(labelEl) : id;
	}
	/**
	return an error message if there's an error,
	otherwise an empty string
	*/
	function validateForm(form) {
		var valMess = '';
		var inpReq = gebs('input.required@type="text", input.required@type="password", textarea.required',form);
		var chkReq = gebs('input.required@type="checkbox", input.required@type="radio"',form);
		var selReq = gebs('select.required',form);
		for (var i=0; i<inpReq.length; i++) { var f=inpReq[i]; if(!f.value){valMess+='missing: '+getLabel(f)+'\n';} }
		for (var i=0; i<chkReq.length; i++) { var f=chkReq[i]; if(!f.checked){valMess+='must select: '+getLabel(f)+'\n';} }
		for (var i=0; i<selReq.length; i++) { var f=selReq[i]; if(!f.options[f.selectedIndex].value){valMess+='must select: '+getLabel(f)+'\n';} }
		valMess && (valMess="This form is not complete. Please provide the\nrequired information in order to proceed.\n\n"+valMess);
		return valMess;
	}
	window.validateForm = validateForm;
})();

reg.click("@href*='thisURL'",function(e){
	this.href = this.href.replace(/(thisURL)/,encodeURIComponent(document.location));
});


//////////////////////////////////
// GLOBAL OMNITURE LINK TRACKER //
//////////////////////////////////

// GLOBAL COMPONENT HANDLERS
reg.submit("div.a2search form",function(e){	i = gebs("input.searchfield,input#searchfield",this); if (i[0].value != '' && i[0].value != i[0].defaultValue){	oTrack(this,'A2','Search-'+document.getElementById('searchfield').value); }});
reg.click('a#sunlogo',function(){oTrack(this,'A2','SunLogo');});
reg.click('div.a2topiclinks > ul > li > a',function(){oTrack(this,'A2',this.innerHTML);});
reg.click('div.a2m a',function(){oTrack(this,'A2',this.parentNode.parentNode.parentNode.parentNode.getElementsByTagName('a')[0].innerHTML+'-'+this.innerHTML);});
reg.click('div.a1menu a',function(){var p = hasParent(this,'div','a1menu');p = prevElem(p);oTrack(this,'A1',elemText(p)+'-'+elemText(this));});
reg.click('div.a1 span > a',function(){oTrack(this,'A1');});
reg.click('div#a5 > ul > li > a',function(){oTrack(this,'A5');});
reg.click('div#a5 li li a',function(){var p = hasParent(this,'li','hasmenu');oTrack(this,'A5',elemText(p.getElementsByTagName('a')[0])+'-'+elemText(this))});
reg.click('div.k5 a',function(){var type = 'K5';if(hasParent(this,'poweredby')){type = '-poweredby';}else if(hasParent(this,'countries')){type = '-countries';}oTrack(this,type,this.innerHTML)});

reg.click('ul#navigation a',function(){oTrack(this,'oracle hnav');});
reg.click('div#oraclesunmenu a',function(){oTrack(this,'oraclesun menu');});
reg.click('div.ra5 a',function(){oTrack(this,'oracle complete footer');});

// OMNITURE WHITELIST
var omniwhite = {
	'www':['all'],
	'star-wip.eng':['all']
};

// ALL OTHER CUSTOM LINK SETTING FUNCTION
function oTrack(a,comp,atxt,aud) {

	// if omniture exist
	if(window.s_account){

		// get subdomain (kills off port if localhost or IP)
		var l = (typeof document.location.host.split('sun.com')[0].replace(/\.$/gi,"").split(':')[0] == 'undefined') ?  navigator.userAgent.toLowerCase().normalize('_') : document.location.host.split('sun.com')[0].replace(/\.$/gi,"").split(':')[0];

		// check subdomain whitelist for component or all
		var gowhite = false;
		if(omniwhite[l]){
			for (var i=0;i<omniwhite[l].length;i++){
				if(omniwhite[l][i] == comp || omniwhite[l][i] == "all"){
					gowhite = true;
				}
			}
		}else if(omniwhite['home']){
			gowhite = true;
		}

		// if whitelisted
		if((gowhite && !a.trackFirst) || (gowhite && a.trackFirst == comp)){

			a.trackFirst = comp;

			if(a.getElementsByTagName('img')[0] && !atxt){
				if(a.getElementsByTagName('img')[0].alt){
					atxt = a.getElementsByTagName('img')[0].alt;
				}else if(a.getElementsByTagName('img')[0].title){
					atxt = a.getElementsByTagName('img')[0].title;
				}else{
					atxt = a.getElementsByTagName('img')[0].src.replace(/.*\/([^\/.]+)\..*$/g,"$1");
				}
			}else if(!atxt){
				atxt = elemText(a);
			}
			atxt = atxt.replace(/\.\.\./gi,"");
			atxt = atxt.normalize();

			s_linkType='o';

			if(!omniwhite['home']){
				s_linkTrackVars = 'prop13,prop14,prop15,prop16,s_eVar37,s_eVar38';
			}else if(omniwhite['home'] && aud && l && atxt && comp){
				s_linkTrackVars = 'prop13,prop14,prop15,prop16,s_eVar37,s_eVar38,eVar30,eVar36';
				s_eVar30 = l+'-'+ comp+'-'+atxt;
				s_eVar36 = l +'-'+aud;
			}else if(omniwhite['home'] && l && atxt && comp){
				s_linkTrackVars = 'prop13,prop14,prop15,prop16,s_eVar37,s_eVar38,eVar30';
				s_eVar30 = l+'-'+ comp+'-'+atxt;
			}

			s_prop13=comp;
			s_prop14=decodeURIComponent(a.href);
			s_prop15=s_pageName;
			s_prop16=atxt;
			s_eVar37=l+'-'+atxt;
			s_eVar38=l+'-'+comp;
			s_linkName=l+':'+comp+':'+atxt;
			// console for testing
			if(omniwhite['console']){
				console.log(
					  '   s_prop13 = '+comp+
					'\n   s_prop14 = '+decodeURIComponent(a.href)+
					'\n   s_prop15 = '+s_pageName+
					'\n   s_prop16 = '+atxt+
					'\n   s_eVar37 = '+l+'-'+atxt+
					'\n   s_eVar38 = '+l+'-'+comp+
					'\n s_linkName = '+l+':'+ comp+':'+atxt
				);
				if(omniwhite['home']){ console.log('\n s_eVar30 = '+l+'-'+ comp+'-'+atxt);}
				if(aud){ console.log('\n s_eVar36 = '+l+'-'+aud);}
			}
			// if any var is null/undefined don't process
			if(s_prop13 && s_prop14 && s_prop15 && s_prop16 && s_eVar37 && s_eVar38){
				s_lnk=s_co(a);
				s_gs(s_account)
			}
			s_prop13 = s_prop14 = s_prop15 = s_prop16 = s_linkTrackVars = s_eVar37 = s_eVar38 = s_eVar30 = s_eVar36 = "";
		}
	}
}

(function(){

	/**
	Pop up a new survey window.
	@param url          (string) url to pop up
	@param nProb        (float >0.0 and <=1.0) probability of survey randomly popping up (default 1.0) (can be expressed as 1/N where N means every "Nth" visitor)
	@param suppressDays (int) don't show again for X days, -1 means never show again, 0 means don't suppress (default 0)
	@param height       (int) height of popup (default 600)
	@param width        (int) width of popup (default 548)
	@param noScrolling  (boolean) suppress scrollbars in popup (default false)
	*/
	window.surveyPop = function(url, nProb, suppressDays, height, width, noScrolling) {
		if (nProb && nProb < Math.random()) { return false; }
		if (beenThereDoneThat(surveyUrl, suppressDays)) { return false; }

		if (!width) { width = 548; }
		if (!height) { height = 600; }
		var args = 'resizable,status,width='+width+',height='+height;
		if (!noScrolling) { args += ',scrollbars'; }
		var newWin = window.open(url, '_surveyWin', args);
		return newWin;
	}

	/**
	Opens a modal dialog for surveys.
	@param dialogUrl    (string) url of survey dialog to pop up (must be same-page or same-domain, with fragment id)
	@param nProb        (float >0.0 and <=1.0) probability of survey randomly popping up (default 1.0) (can be expressed as 1/N where N means every "Nth" visitor)
	@param suppressDays (int) don't show again for X days, -1 means never show again, 0 means don't suppress (default 0)
	*/
	window.surveyDialog = function(dialogUrl, nProb, suppressDays) {
		if (nProb && nProb < Math.random()) { return false; }
		if (beenThereDoneThat(dialogUrl, suppressDays)) { return false; }
		var dummyLink = elem('a',{'class':'k5 k5info','href':dialogUrl},'');
		k5Click.call(dummyLink);
	}

	// private function for cookies
	function beenThereDoneThat(url, suppressDays) {
		var patt = new RegExp('^'+ckName+'_'+uHash+'=seen$');
		var ck = document.cookie;
		var ckName = 'surveyHash';
		var ckArr = ck.split('; ');
		var uHash = url.toLowerCase().replace(/[^a-z0-9_\/]/g,'_');
		var beenThere = false;
		for (var i=0; i<ckArr.length; i++) {
			if (patt.test(ckArr[i])) { return true; }
		}
		if (suppressDays) {
			if (suppressDays < 0) { suppressDays = 9999; }
			var expires = new Date();
			expires.setTime(expires.getTime() + suppressDays * 1000 * 60 * 60 * 24);
			document.cookie = ckName+'_'+uHash+'=seen; expires='+expires.toGMTString();
		}
		return false;
	}

})();


/*
Version 0.9.1: 2009-06-19

Change-log (0.9.1):
* Removed "comApp" from all function names
* Updated suncomExtendedCookieWhiteList

*/

function decodeSunSessionCookie() {
    var lookup = "SASC=";
    var value = "";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1, c.length);
        if (c.indexOf(lookup) == 0) value = c.substring(lookup.length, c.length);
    }
    return decodeURIComponent(value);
}

/** Set session cookie by name/value. */
function setSunSessionCookie(name, value) {
    var decoded = decodeSunSessionCookie();
    var newValue = "";
    var newSubcookie = true;
    if (decoded != "") {
        var nvps = decoded.split('&');
        for(var i=0; i<nvps.length; i++) {
            var nvp = nvps[i].split('=');
            if (nvp[0] == name) {
                nvp[1] = encodeURIComponent(value);
                newSubcookie = false;
            }
            newValue += nvp[0] + "=" + nvp[1] + "&";
        }
        newValue = newValue.substring(0, newValue.length - 1);
    }
    if (newSubcookie) {
        if (newValue != "") newValue += "&";
        newValue += name + "=" + encodeURIComponent(value);
    }
    if (newValue.length > 4080) {
        throw "Out of application session cookie space";
    }
    document.cookie = "SASC="+encodeURIComponent(newValue)+"; path=/";
}

/** Get session cookie by name. */
function getSunSessionCookie(name) {
    var decoded = decodeSunSessionCookie();
    if (decoded != "") {
        var nvps = decoded.split('&');
        for(var i=0; i<nvps.length; i++) {
            var nvp = nvps[i].split('=');
            if (nvp[0] == name) {
                return decodeURIComponent(nvp[1]);
            }
        }
    }
    return null;
}

/** Remove session cookie by name. */
function removeSunSessionCookie(name) {
    var decoded = decodeSunSessionCookie();
    var newValue = "";
    if (decoded != "") {
        var nvps = decoded.split('&');
        for(var i=0; i<nvps.length; i++) {
            var nvp = nvps[i].split('=');
            if (nvp[0] == name) {
                continue; // Skip
            }
            newValue += nvp[0] + "=" + nvp[1] + "&";
        }
        newValue = newValue.substring(0, newValue.length - 1);
    }
    document.cookie = "SASC="+encodeURIComponent(newValue)+"; path=/";
}

function deriveExpirationForAppExtendedCookie() {
    var date = new Date();
    date.setTime(date.getTime()+(365*24*60*60*1000));
    return "; expires="+date.toGMTString();
}

function decodeSunExtendedCookie() {
    var lookup = "SAEC=";
    var value = "";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1, c.length);
        if (c.indexOf(lookup) == 0) value = c.substring(lookup.length, c.length);
    }
    return decodeURIComponent(value);
}

/** Set extended cookie by name/value, with an optional expiration in days. */
function setSunExtendedCookie(name, value, days) {
    if (suncomExtendedCookieWhiteList[name]) {
        // allowed
    } else if (name.length > 4 &&
        name.substring(name.length-4, name.length) == "_exp" &&
        suncomExtendedCookieWhiteList[name.substring(0, name.length - 4)]) {
        // allowed
    } else {
        throw "This cookie name is not supported - " + name;
    }
    var decoded = decodeSunExtendedCookie();
    var newValue = "";
    var newSubcookie = true;
    if (decoded != "") {
        var nvps = decoded.split('&');
        for(var i=0; i<nvps.length; i++) {
            var nvp = nvps[i].split('=');
            if (nvp[0] == name) {
                nvp[1] = encodeURIComponent(value);
                newSubcookie = false;
            }
            newValue += nvp[0] + "=" + nvp[1] + "&";
        }
        newValue = newValue.substring(0, newValue.length - 1);
    }
    if (newSubcookie) {
        if (newValue != "") newValue += "&";
        newValue += name + "=" + encodeURIComponent(value);
    }
    if (newValue.length > 4080) {
        throw "Out of application session cookie space";
    }
    var expires = deriveExpirationForAppExtendedCookie();
    document.cookie = "SAEC="+encodeURIComponent(newValue)+expires+"; path=/";
    if (days) {
        var date = new Date();
        var expiresAt = days + Math.ceil(date.getTime() / 24 / 60 / 60 / 1000);
        setSunExtendedCookie(name + "_exp", expiresAt, null);
    }
}

/** Get extended cookie by name. */
function getSunExtendedCookie(name) {
    var expiresAt = null;
    if (!(name.length > 4 && name.substring(name.length-4, name.length) == "_exp")) {
        expiresAt = getSunExtendedCookie(name+"_exp");
    }
    if (expiresAt != null) {
        var today = Math.ceil(new Date().getTime() / 24 / 60 / 60 / 1000);
        if (today > expiresAt) {
            removeSunExtendedCookie(name);
            return null;
        }
    }
    var decoded = decodeSunExtendedCookie();
    if (decoded != "") {
        var nvps = decoded.split('&');
        for(var i=0; i<nvps.length; i++) {
            var nvp = nvps[i].split('=');
            if (nvp[0] == name) {
                return decodeURIComponent(nvp[1]);
            }
        }
    }
    return null;
}

/** Remove extended cookie by name. */
function removeSunExtendedCookie(name) {
    if (!(name.length > 4 && name.substring(name.length-4, name.length) == "_exp")) {
        removeSunExtendedCookie(name + "_exp");
    }
    var decoded = decodeSunExtendedCookie();
    var newValue = "";
    if (decoded != "") {
        var nvps = decoded.split('&');
        for(var i=0; i<nvps.length; i++) {
            var nvp = nvps[i].split('=');
            if (nvp[0] == name) {
                continue; // Skip
            }
            newValue += nvp[0] + "=" + nvp[1] + "&";
        }
        newValue = newValue.substring(0, newValue.length - 1);
    }
    var expires = deriveExpirationForAppExtendedCookie();
    document.cookie = "SAEC="+encodeURIComponent(newValue)+expires+"; path=/";
}

var suncomExtendedCookieWhiteList = {
//    placeholder1 : true,
//    placeholder2 : true
};




// IMG POSTLOAD
var imgpostload = [];
reg.postSetup(function(){
	if(typeof imgpostload=='undefined'){return;}
	for (var imp=0;imp<imgpostload.length;imp++){
		if(imgpostload[imp].title){
			imgpostload[imp].src = imgpostload[imp].title;
			imgpostload[imp].title = "";
		}
	}
});

if(!shutoff.global){
	if(is.ie56){
		reg.setup('div.g15v5 > table',function(){addClassName(this,'tickle');});
	}
}

if(!shutoff.share){reg.setup("div.pagetitle, div.smallpagetitle",sniffSharePage,true);}

if(!shutoff.misc){
	reg.setup("@class*='cTool-'",sniffClassTool);
	reg.setup("img@src*='_off.'",sniffRollover);
	reg.setup("div.g23",sniffG23);
	reg.setup("div.g27w2",sniffG27);
	reg.click('div.g27w2 > h3 > span.g27targ',toggleG27);
	reg.click("a@href*='#'.g27v1 > span",toggleG27v1);
	reg.setup("div.imgbox",sniffImgbox);
	reg.setup("select.goto, select.showDiv",sniffGoto);
	reg.setup("ul.goto, ul.showDiv",sniffGotoUL);
	reg.setup(".xfadefirst",sniffXfade);
	reg.setup("ul.listfade",sniffListfade);
	reg.setup("a.loadUrl@href",sniffLoadUrl);
	reg.setup('a.imgswap, area.imgswap, img.imgswap, span.imgswap', sniffImgswap);
	reg.setup('img@class*="mswap"', sniffMultiswap);
	reg.setup('img.postload', function(){imgpostload.push(this);});
	reg.setup('a.toggleObj, area.toggleObj', sniffToggler);
	reg.setup('a.toggle-all-table-checkboxes', sniffToggleAllCheckboxesInTable);
	reg.setup('div.pc1collapsible', sniffExpandCollapsePc1);
	reg.setup("select.platformDetect",platformDetect);
	reg.setup("select.langDetect",langDetect);
	reg.setup('form@class*="wgform-",form@class*="rgform-"', sniffFormHijax);
	reg.setup('.pn0 > .pn0v5 a.big,.pn0 > .pn0v3 a.big,.pn0 > .pn0v2 a.big,.pn0 > .pn0v1 a.big', sniffpn00links);
	reg.setup('div.g15v5 > table.details tr.main-row > th',function(){this.appendChild(elem('div.after',{},[elem('div.show',{},ltxt.showDetails),elem('div.hide',{},ltxt.hideDetails)]));});
	if (location.hash) {
		try {
			reg.setup('div.g15v5 table tbody'+location.hash,function(){removeClassName(this, 'collapsed');addClassName(this, 'uncollapsed');});
		} catch (ex) {
			console.log(ex.message);
		}
	}
	if(is.ie56){
		reg.setup('div.g15v5 > table',function(){ addClassName(this, 'tickle'); });
		reg.setup('div.pngimg',function(){
			this.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+this.getElementsByTagName('img')[0].src+"')";
		});
	}
	if (typeof widgets != 'undefined'){reg.setup('.wg1', sniffWg1);}// can this go away?
}


function sniffpn00links(){
	if(this.href){
		var pn0 = hasParent(this,'div','pn0');
		if (!hasClassName(pn0, "hasimglink")){
			addClassName(pn0,'hasimglink');
			pn0.appendChild(elem('a.pn0linkimg',{'href':this.href},[]));
		}
	}
}


// setup download page action
reg.preSetup(function(){
	var pc10 = gebi('pc10');
	if (!pc10) { return; }
	var imgs = gebs("p.pc10img img.pc10img");
	if (!imgs || imgs.length==0) { return; }

	// now i know i'm on the right page
	for (var a=0; a<imgs.length; a++){
		var img = imgs[a];

		// need src for hovered and non-hovered versions
		var src = img.src;
		var src_over = src.replace(/(\.[a-z]+$)/,"_hvr$1");//x.png > x_hvr.png

		// append hovered image
		var img_over = img.cloneNode(true);
		img_over.src = src_over;
		img_over.className = 'pc10img_over';
		img.parentNode.appendChild(img_over);
	}

	// init the hover action
	if (!window.pc10active) {
		window.pc10active = true;
		reg.hover("div.pc10item",function(e){
			addClassName(this,'pc10itemover');
		},function(e){
			removeClassName(this,'pc10itemover');
		});
	}
});

// SETUP PRODUCT FINDER
reg.preSetup(function(){
	var fn1 = gebi('productFinder');
	if(!fn1){return;}
	reg.setup('td.fnCmp input@type="checkbox"',function(){
		if(this.checked == true){
			addClassName(this.parentNode.parentNode, "checked");
		}
	});

	reg.setup('ul#fn1Filters',function(){
		// set up toggle links
		var ems = gebtn('em',this);
		for (var i=0;i<ems.length;i++){
			if(ems[i].parentNode.nodeName.toLowerCase() == "li"){
				var a = elem('a',{'href':'#toggleView'});
				a.onclick = function(){
					toggleClassName(this.parentNode.parentNode, "collapsed");
					return false;
				};
				innerWrap(ems[i],a)
			}
		}

		// collapse all but first 4 LIs, unless var showLIs exist
		var li = gebtn('li',this);
		var n = 0;
		for (var i=0;i<li.length;i++){
			var firstLi = gebtn('li',li[i])[0];
			if(li[i].parentNode == this && n > 3 && firstLi && firstLi.className.indexOf('selection') > -1){
				addClassName(li[i], "collapsed");
			}else if(li[i].parentNode == this && gebtn('em',li[i])[0]){
				n++;
			}
		}
	});

	reg.setup('fieldset.fieldset-collapsed,fieldset.fieldset-uncollapsed',function(){
		if(gebtn('h6',this)[0]){
			var a = elem('a.fieldsettoggle',{'href':'#toggleView'});
			innerWrap(gebtn('h6',this)[0], a);
			addClassName(gebtn('h6',this)[0], "fieldsettoggle");		}
	});

	reg.click('td.fnCmp input@type="checkbox"',function(){
		var parent = this;
		while (parent = parent.parentNode) {
			if (parent.nodeName.toLowerCase() == 'form'){
				var form = parent;
				break;
			}
		}
		var maxcheck = form.className.split('maxchecked-')[1].split(' ')[0];
		if(maxcheck){
			var n = 0;
			var ck = gebtn('input',form);
			for (var i=0;i<ck.length;i++){
				if(ck[i].type == "checkbox" && ck[i].checked == true){
					n++;
				}
			}
			if(n > maxcheck){
				this.checked = false;
				alert(ltxt['maxCheckedPart1']+' '+maxcheck+' '+ltxt['maxCheckedPart2']);
			}
		}

		if(this.checked == true){
			addClassName(this.parentNode.parentNode, "checked");
		}else if(this.checked == false){
			removeClassName(this.parentNode.parentNode, "checked");
		}
	});
});

// SETUP RESELLER FINDER WIDGET
reg.preSetup(function() {
	var frw = gebi("findresellerwidget");
	if (!frw) { return; }
	frw.onsubmit = function(e) {
		var k = this.keywords;
		var l = this.location;
		if (hasClassName(k, 'autoclear') && k.value == k.defaultValue) { k.value = ''; }
		if (hasClassName(l, 'autoclear') && l.value == l.defaultValue) { l.value = ''; }
		return true;
	};
});

// SETUP FLOATING SIDEBAR
reg.postSetup(function(){
	var fixme = gebi("floating-sidebar");
	if (!fixme) { return; }
	getXY(fixme);
	var distFromTop = fixme.Y;
	addEvent(window,"scroll",function(){
		var docEl = document.documentElement, w = window;
		var vHeight = (w.innerHeight) ? w.innerHeight : docEl.clientHeight;
		var height = fixme.offsetHeight;
		var scrlAmt = getScrollTop();
		var distFromViewport = distFromTop - scrlAmt;
		if (distFromViewport < 10 && height+10 < vHeight) { acn(fixme,"floating-sidebar"); }
		else { rcn(fixme,"floating-sidebar"); }
	});
});

// BUBBLING EVENTS
reg.click('a@class*="hijax-",@class*="hijax-" a,.fn1 .g8pages a', hijaxLink);
reg.click('div.g15v5 tr.main-row > th@scope="row"',function(ev){switchClassName(this.parentNode.parentNode, 'collapsed', 'uncollapsed');});
reg.hover("img.spriteswap",spriteOver,spriteOut, 0);
reg.click('.modal-close',modalClose);
reg.click('a@class*="mswap", area@class*="mswap", span@class*="mswap"', clickMultiswap);
reg.click('a.fieldsettoggle', function(ev){switchClassName(this.parentNode.parentNode, 'fieldset-collapsed', 'fieldset-uncollapsed');return false;});
reg.click("a#sr2Adv,a.sr2Adv",function(){addClassName(document.getElementById('sr2'),'sr2showOptions');document.getElementById('searchtermsAll').focus();return false})
reg.click("a#sr2Simple,a.sr2Simple",function(){removeClassName(document.getElementById('sr2'),'sr2showOptions');document.getElementById('simpleSearch').focus();return false})
reg.click('span.disabled a',function(){return false});

// SETUP -> G27
function sniffG27() {

	var h3 = gebtn('h3',this);
	if (!h3 || h3.length < 1) { return; }
	h3 = h3[0];
	var h3Text = elemText(h3).strip();
	var targSpan = elem('span.g27targ');
	acn(h3,'g27head');
	innerWrap(h3,targSpan);
	if (!h3Text) {
		var im = elem('img.g27targimg',{'src':imdir+'/a.gif','alt':''});
		targSpan.appendChild(im);
	}

	var block = gebcn('g27block',this);
	if (!block || block.length < 1) { return; }
	block = block[0];

	if (hcn(block,'hidethis')) {
		acn(this,'g27collapsed');
		rcn(this,'g27expanded');
	} else {
		rcn(this,'g27collapsed');
		acn(this,'g27expanded');
	}

	if (location.hash && location.hash.length > 1) {
		var lh = location.hash.substring(1);
		var targ = gebi(lh);
		if (!targ) { return; }
		var pG27 = getParent(this, '.g27');
		if (pG27.contains(targ) || pG27.id == lh) {
			rcn(block,'hidethis');
			rcn(this,'g27collapsed');
			acn(this,'g27expanded');
		}
	}
}

function toggleG27(e) {
	var h3 = this.parentNode;
	var g27w2 = h3.parentNode;
	var block = gebcn("g27block", g27w2);
	if (!block || block.length < 1) { return; }
	block = block[0];
	var isToggleText = false;
	var showSpan = gebcn('showtext',this);
	var hideSpan = gebcn('hidetext',this);
	if (showSpan.length && hideSpan.length) {
		isToggleText = true;
		showSpan = showSpan[0];
		hideSpan = hideSpan[0];
	}
	if (hcn(block, 'hidethis')) {
		rcn(block,'hidethis');
		rcn(g27w2,'g27collapsed');
		acn(g27w2,'g27expanded');
		if (isToggleText) {
			acn(showSpan,'hidethis');
			rcn(hideSpan,'hidethis');
		}
	} else {
		acn(block,'hidethis');
		acn(g27w2,'g27collapsed');
		rcn(g27w2,'g27expanded');
		if (isToggleText) {
			rcn(showSpan,'hidethis');
			acn(hideSpan,'hidethis');
		}
	}

	var idElChain = [], idEl = this;
	while (idEl = getParent(idEl,'@id')) {
		idElChain.push(idEl);
	}
	idElChain.forEach(function(idEl){
		var g27w2s = gebcn('g27w2',idEl);
		var g27v1s = gebcn('g27v1').filter(function(g27v1){
			return g27v1.hash==='#'+idEl.id;
		});
		if(g27w2s.every(function(g27w2){
			return hcn(g27w2,'g27expanded');
		})){
			g27v1s.forEach(function(g27v1){
				acn(gebs('span.showtext',g27v1)[0],'hidethis');
				rcn(gebs('span.hidetext',g27v1)[0],'hidethis');
			});
		} else if(g27w2s.every(function(g27w2){
			return hcn(g27w2,'g27collapsed');
		})){
			g27v1s.forEach(function(g27v1){
				rcn(gebs('span.showtext',g27v1)[0],'hidethis');
				acn(gebs('span.hidetext',g27v1)[0],'hidethis');
			});
		}
	});
}

function toggleG27v1(){
	var id=this.parentNode.hash.substring(1);
	var show = gebcn('showtext', this.parentNode)[0];
	var hide = gebcn('hidetext', this.parentNode)[0];
	acn(this,'hidethis');
	if (this===show) {
		rcn(hide,'hidethis');
		gebs('div.g27w2.g27collapsed > h3 > span.g27targ',gebi(id)).forEach(function(g27targ){
			toggleG27.call(g27targ);
		});
	} else {
		rcn(show,'hidethis');
		gebs('div.g27w2.g27expanded > h3 > span.g27targ',gebi(id)).forEach(function(g27targ){
			toggleG27.call(g27targ);
		});
	}
	return false;
}

// SETUP -> G23
(function(){

	function expand(li) {
		if (gebtn('ul',li).length===0) { return; }
		rcn(li, 'collapsed');
		if (is.ie6 && li.isLast && li.isBranch){
			rcn(li, 'ie-collapsed-last');
			acn(li, 'ie-expanded-last');
		}
	}

	function collapse(li) {
		if (gebtn('ul',li).length===0) { return; }
		acn(li, 'collapsed');
		if (is.ie6 && li.isLast && li.isBranch){
			acn(li, 'ie-collapsed-last');
			rcn(li, 'ie-expanded-last');
		}
	}

	function expandCollapse(){
		// takes a.g23toggler as 'this'
		var parent = getParent(this,'li');
		if (!hcn(parent, 'collapsed')){
			collapse(parent);
		} else {
			expand(parent);
		}
	}

	function checkUncheck(){
		var parent = getParent(this, 'li');
		var subinputs = gebtn('input',parent);
		for (var c=0;c<subinputs.length;c++){
			if(!subinputs[c].disabled){
				subinputs[c].checked = this.checked;
			}
		}
		var subitems = gebtn('li',parent);
		for (var c=0;c<subitems.length;c++){
			if (typeof subitems[c].updateCount == 'function') { subitems[c].updateCount(); }
		}
		var ancestor = getParent(parent,'li');
		if (!this.checked){
			parent = this;
			while (parent.parentNode){
				parent = parent.parentNode;
				if (parent.checkBox) { parent.checkBox.checked = false; }
			}
		}else if (ancestor && ancestor.checkBox){
			subinputs = gebtn('input',ancestor);
			var allChecked = true;
			for (var c=0;c<subinputs.length;c++){
				if (subinputs[c].type != 'checkbox') { continue; }
				if (subinputs[c] != parent.parentNode.parentNode.checkBox && !subinputs[c].checked) { allChecked = false; }
			}
			parent.parentNode.parentNode.checkBox.checked = allChecked;
		}
		parent = this;
		while (parent.parentNode){
			parent = parent.parentNode;
			if (typeof parent.updateCount == 'function') { parent.updateCount(); }
		}
		parent = null;
	}

	reg.click("a.g23toggler",expandCollapse);

	reg.click("div.g23 p.exp-coll a.expand-all",function(){
		var parent = getParent(this, "div.g23");
		var lis = gebs("ul.g23tree li", parent);
		for (var i=0; i<lis.length; i++) {
			expand(lis[i]);
		}
		return false;
	});

	reg.click("div.g23 p.exp-coll a.collapse-all",function(){
		var parent = getParent(this, "div.g23");
		var lis = gebs("ul.g23tree li", parent);
		for (var i=0; i<lis.length; i++) {
			collapse(lis[i]);
		}
		return false;
	});

	reg.click(".g23check-tree input@type='checkbox'", checkUncheck);
})();

function sniffG23(){
        var aGifPath = getWebDesignFolderLocation() + "im/a.gif";
	if (hcn(this,'multi')) {
		var p = elem('p',{'class':'multi exp-coll'});
		var ex = ltxt.expandAll || "expand all";
		var cl = ltxt.collapseAll || "collapse all";
		p.innerHTML = '<a class="expand-all" href="#expand">'+ex+'</a> <a class="collapse-all" href="#collapse">'+cl+'</a>';
		var g23w4 = gebcn("g23w4",this)[0];
		g23w4.insertBefore(p, g23w4.firstChild);
	}
	var fobj = this;
	if (hcn(this,'static')){
		// for static trees
		var uls = gebcn("g23tree",fobj,'ul');
		for (var a=0;a<uls.length;a++){
			var tree = uls[a];
			var lis = gebtn('li',tree);
			for (var b=0,li;li=lis[b++];){
				var isLast = !nextElem(li);
				if (isLast) { acn(li, 'last'); }
				if (is.ie6 && isLast) { acn(li, 'ie-'+(hcn(li,'collapsed')?'collapsed':'expanded')+'-last'); }
				var nodeLink = li.firstChild;
				if (nodeLink.nodeType != 1) { nodeLink = nextElem(nodeLink); }
				if (hcn(li,'branch') && nodeLink && nodeLink.href){
					// build the expand/collapse button
					var link = elem('a.g23toggler',{'href':nodeLink.href},elem('img',{'src':aGifPath,'height':'10','width':'20','alt':'expand / collapse '}));
					li.insertBefore(link, li.firstChild);
				}
			}
		}
		return;
	}
	var uls = gebcn("g23tree",fobj,'ul');
	for (var a=0;a<uls.length;a++){
		var tree = uls[a];
		var lis = gebtn('li',tree);
		for (var b=0,li;li=lis[b++];){
			var isDefaultExpanded = hcn(li, 'default-expanded');
			var isBranch = false;
			if (gebtn('ul',li).length>0){
				// it's a branch if there's a nested <ul>
				if (isDefaultExpanded) { acn(li, 'branch'); }
				else { acn(li, 'collapsed branch'); }
				isBranch = true;
				var subUl = gebtn('ul',li)[0];
				subUl.parentNode.removeChild(subUl);
				li.innerWrap = elem('div.g23x');
				innerWrap(li, li.innerWrap);
				li.appendChild(subUl);
			}
			var isLast = !nextElem(li);
			if (isLast) { acn(li, 'last'); }
			if (is.ie6) { li.isLast = isLast; li.isBranch = isBranch; }
			if (is.ie6 && li.isLast && li.isBranch && isDefaultExpanded) { acn(li, 'ie-expanded-last'); }
			else if (is.ie6 && li.isLast && li.isBranch && !isDefaultExpanded) { acn(li, 'ie-collapsed-last'); }
			if (isBranch){
				// build the expand/collapse button
				var link = elem('a.g23toggler',{},elem('img',{'src':aGifPath,'height':'10','width':'20','alt':'expand / collapse '}));
				gebtn('div',li)[0].insertBefore(link, gebtn('div',li)[0].firstChild);
				if (hcn(tree, 'g23check-tree')){
					// build the indicator of how many children are checked
					var countSpan = document.createElement('span');
					countSpan.className = 'g23checked-count';
					for (var c=0;c<li.childNodes.length;c++){
						if (li.childNodes[c].nodeName.toLowerCase()=='ul') { li.sublist = li.childNodes[c]; }
						if (hcn(li.childNodes[c], 'g23item-extra-info')) { li.extraInfo = li.childNodes[c]; }
					}
					li.innerWrap.appendChild(countSpan);
					li.countSpan = countSpan;
					countSpan.appendChild(document.createTextNode(' ')); // space, rather than empty string, for safari
					if (window.opera) { countSpan.innerHTML = '&nbsp;'; } // tickle opera
					li.updateCount = function(){
						var count = 0;
						var inputs = gebs('input@type="checkbox"', this.sublist);
						for (var b=0; b<inputs.length; b++){ if (inputs[b].checked) { count++; } }
						inputs = null;
						if (this.countSpan){
							if (count  < 1) { this.countSpan.firstChild.data = ' '; if (window.opera) { this.countSpan.innerHTML = '&nbsp;'; } } // safari space, tickle opera
							if (count == 1) { this.countSpan.firstChild.data = '(1 checked item not shown)'; }
							if (count  > 1) { this.countSpan.firstChild.data = '('+count+' checked items not shown)'; }
						}
					}
				}
			}
			li = null;
		}
		if (location.hash) {
			var target = gebi(location.hash.substring(1));
			if (target && matches(target, 'ul.g23tree li')) {
				do {
					rcn(target,'collapsed');
					target = getParent(target,'ul.g23tree li');
				} while (target);
			}
		}
		if (hcn(tree, 'g23check-tree')){
			var inputs = gebs('input@type="checkbox"', tree);
			for (var b=0; b<inputs.length; b++){
				var parent = getParent(inputs[b], 'li');
				parent.checkBox = inputs[b];
			}
			if (location.hash){
				var target = location.hash.substring(1);
				for (var b=0;b<lis.length;b++){
					var li = lis[b];
					if (li.id == target){
						var inputs = gebtn('input',li);
						for (var c=0; c<inputs.length; c++){
							if (inputs[c].type != 'checkbox') { continue; }
							inputs[c].checked = true;
						}
						var el = li;
						while (el.parentNode && !hcn(el, 'g23tree')){
							if (el.nodeName.toLowerCase() == 'li' && hcn(el, 'branch')){
								rcn(el, 'collapsed');
								if (is.ie6 && el.isLast && el.isBranch){
									rcn(el, 'ie-collapsed-last');
									acn(el, 'ie-expanded-last');
								}
							}
							el = el.parentNode;
						}
						var subitems = gebtn('li',li);
						for (var c=0,subitem;subitem=subitems[c++];){
							if (hcn(subitem, 'branch')){
								rcn(subitem, 'collapsed');
								if (is.ie6 && subitem.isLast && subitem.isBranch){
									rcn(subitem, 'ie-collapsed-last');
									acn(subitem, 'ie-expanded-last');
								}
							}
						}
						inputs = null;
						el = null;
					}
				}
			}
			for (var b=0;b<lis.length;b++){
				var li = lis[b];
				if (typeof li.updateCount == 'function') { li.updateCount(); }
				li = null;
			}
		}
		tree = null;
	}

}

// SETUP -> ROLLOVERS
var preloaderOn = [];
var preloaderOff = [];
var preloaderActive = [];
var activeImg = [];
function sniffRollover(){
	var fobj = this;
	fobj.rsrc = fobj.src;
	preloaderOff[fobj.rsrc] = new Image();
	preloaderOff[fobj.rsrc].src = fobj.rsrc;
	if (hasClassName(fobj, "rollover")){
	  preloaderOn[fobj.rsrc] = new Image();
	  preloaderOn[fobj.rsrc].src = fobj.src.replace(/_off\./,"_on.");
	  fobj.onmouseout = function(){
		  if (activeImg[this.imgGroup] != this){
			  this.src = preloaderOff[this.rsrc].src
		  }
	  };
		fobj.onmouseover = function(){
			if (activeImg[this.imgGroup] != this){
				this.src = preloaderOn[this.rsrc].src
			}
		};
	}
	if (fobj.className.indexOf("active-") > -1){
	  fobj.imgGroup = fobj.className;
	  fobj.imgGroup = fobj.imgGroup.replace(/.*active-(.*).*/,"$1");
	  preloaderActive[fobj.rsrc] = new Image();
	  preloaderActive[fobj.rsrc].src = fobj.src.replace(/_off\./,"_active.");
	  if (fobj.className.indexOf("setactive-") > -1){
		  activeImg[fobj.imgGroup] = fobj;
		  fobj.src = preloaderActive[fobj.rsrc].src;
	  }
	  fobj.onclick = function(){
			if (this.src != preloaderActive[this.rsrc].src){
				this.src = preloaderActive[this.rsrc].src;
				if (activeImg[this.imgGroup]){
					activeImg[this.imgGroup].src = preloaderOff[activeImg[this.imgGroup].rsrc].src;
				}
				activeImg[this.imgGroup] = this;
			}
		};
	}
}

// SETUP -> GOTO MENU
function sniffGoto(){
	var fobj = this;
	if(hasClassName(fobj, 'showDiv')){
		addEvent(fobj,"change",function(){
				var divID = this.options[this.selectedIndex].value.split('#')[1];
				if (this.currentItem){
						addClassName(this.currentItem,'hidethis');
				}
				if(gebi(divID)){
					this.currentItem = gebi(divID);
					removeClassName(this.currentItem,'hidethis');
				}else{
					this.currentItem = null;
				}
		});
	}else if(this.className.indexOf('hijax-') > -1){
		addEvent(fobj,"change",function(){
			var link = this.options[this.selectedIndex];
			try{
				var id = matchClassName(this,/^hijax-(\S*)/)[1];
				var targetDiv = gebi(id);
				var h = targetDiv.offsetHeight;
				targetDiv.innerHTML = '';
				targetDiv.style.height=h+'px';
				addClassName(targetDiv, 'hijaxLoading');
			} catch (ex) {
				return;
			}

			if (targetDiv.className.indexOf('hijaxTrue') > -1){
				var delim = (link.value.indexOf('?') > -1) ? '&' : '?';
				var linkHref = link.value+delim+"hijax=true";
			}else{
				var linkHref = link.value;
			}

			if(link.value != "" && link.getAttribute("value")){
				xhr(linkHref, function(rdata,obj){
					// succeed
					var el = getElementByIdFromString(rdata, id);
					if (!el) { window.location=link.href; }
					rdata = el.innerHTML;
					hijaxCache[linkHref+' '] = rdata;
					removeClassName(targetDiv, 'hijaxLoading');
					targetDiv.style.height='auto';
					targetDiv.innerHTML = rdata;
					reg.rerun(targetDiv);
					if(gebi('linkToPage') && !hasClassName(targetDiv, 'noPermalink')){
						gebi('linkToPage').href = link.value;
					}
				},function(){
					// fail
					window.location=link.value;
				});
			}
		});
	}else{
		addEvent(fobj,"change",function(){
			if(this.options[this.selectedIndex].value != "" && this.options[this.selectedIndex].getAttribute("value")){
				document.location = this.options[this.selectedIndex].value;
			}
		});
	}
}

// SETUP -> GOTO UL MENU
function sniffGotoUL(){
	var fobj = this;
	var li = getChildNodesByTagName(fobj,'li');
	var options = "";
	var heading = prevElem(fobj);
	if(heading && hasClassName(heading, 'listTitle') && gebtn('a',heading)[0]){
		options = options+'<option value="'+gebtn('a',heading)[0].href+'" class="gotoHeading">'+heading.innerHTML+'</option>\n';
	}else if(heading && hasClassName(heading, 'listTitle')){
		options = options+'<option value="" class="gotoHeading">'+heading.innerHTML+'</option>\n';
	}
	var ulclass = "goto";
	var hi = (this.className.indexOf('hijax-') > -1) ? ' '+matchClassName(this,/^(hijax-\S*)/)[1] : '';
	var form = elem('form',{'action':''});
	fobj.parentNode.insertBefore(form, fobj);
	if(hasClassName(fobj, 'showDiv')){
		ulclass = "showDiv";
		var exdiv = document.createElement('div');
		fobj.parentNode.insertBefore(exdiv, fobj);
	}
	for (var n=0;n<li.length;n++){
		var sel = (hasClassName(li[n], 'selected'))? ' selected="selected"' : '';
		if (gebtn('a',li[n])[0]){
			options = options+'<option'+sel+' value="'+gebtn('a',li[n])[0].href+'">'+gebtn('a',li[n])[0].innerHTML+'</option>';
		}else if (li[n].innerHTML){
			options = options+'<option'+sel+' value="">'+li[n].innerHTML+'</option>';
		}
		if (hasClassName(fobj, 'showDiv') && gebtn('div',li[n])[0]){
			exdiv.appendChild(gebtn('div',li[n])[0]);
		}
	}
	var listID = (this.id) ? ' id="'+this.id+'"' : '';
	form.innerHTML = '<select class="'+ulclass+hi+'"'+listID+'>'+options+'</select>';
	fobj.parentNode.removeChild(fobj);
	reg.rerun(form);
}

// SETUP -> IMG BOX & IMG ZOOM
var zimg = 1;
function sniffImgbox(){
	var imgdiv = this;
	var img = gebtn('img',imgdiv)[0];
	imgdiv.style.background  = 'url('+img.src+') no-repeat';
	imgdiv.style.width = img.width+'px';
	imgdiv.style.height = img.height+'px';
	img.style.visibility = 'hidden';

	if (is.ie56 && hasParent(imgdiv,'div','g20w1')){
		var wrapdiv = hasParent(imgdiv,'div','g20w1');
		wrapdiv.style.width = ((img.width * 1) + 12) + 'px';
		addClassName(wrapdiv, 'showcorners');
	}

	if (hasClassName(imgdiv,'imgcorners')){
		imgdiv.innerHTML = '<div class="imgw1"><div class="imgw2"><div class="imgw3"><div class="imgw4" style="width:'+img.width+'px;height:'+img.height+'px">'+imgdiv.innerHTML+'</div></div></div></div>';
	}
	if (hasClassName(imgdiv,'imgzoom')){
		var lgimg = gebtn('a',imgdiv)[0].href;
		var lgDiv = document.createElement('div');
		lgDiv.className = 'zoomimg k2';
		lgDiv.id = 'zoomimg'+zimg;
		var lgblur = document.createElement('a');
		lgblur.style.backgroundImage = 'none';
		lgblur.onclick = function(){return false;}
		var lgImg = document.createElement('img');
		lgImg.src = lgimg;
		lgblur.appendChild(lgImg);
		lgDiv.appendChild(lgblur);
		imgdiv.appendChild(lgDiv);
		if (hasClassName(imgdiv,'imgright')){
			imgdiv.className = imgdiv.className+' hAlignRight x10';
		}else{
			imgdiv.className = imgdiv.className+' x-10';
		}
		imgdiv.className = imgdiv.className+' vAlignTopBottom y-10 k2over-zoomimg'+zimg;
		sniffK2.call(imgdiv);
		var firstA = gebtn('a',imgdiv)[0];
		firstA.onclick = function(){return false;}
		firstA.style.width = img.width+'px';
		firstA.style.height = img.height+'px';
		zimg++;
	}
}

// KILL INTCMP FROM SOCIAL E10 PRINT LINKS
reg.click('div.e10 a',function(){
	this.href = this.href.replace(/(intcmp=[^&]+)/,"").replace(/\&+/g,"%26").replace(/%3F%26/g,"%3F");
});


// SETUP -> SHARE THIS PAGE
function sniffSharePage() {
	var titleDiv = this;
	if(typeof sharetxt!='undefined'){
		var share_url = getSafelyEncodedString(location.href).replace(/%26/g,"&").replace(/intcmp%3D[^&]+/g,"").replace(/\&+/g,"%26").replace(/%3F%26/g,"%3F");
		var share_title = getSafelyEncodedString(document.title);
		var shareThisPage = '\
		<div class="sharepagew1 share-mailto">\
		<table summary="" cellpadding="0" cellspacing="0"><tr>\
		<td id="share-mailto"><a href="mailto:?subject='+sharetxt[0]+'{pagetitle}&body='+sharetxt[1]+'%0A%0A'+share_url+'" class="sharelink mailto" title="'+sharetxt[2]+'"></a></td>\
		<td id="share-technorati"><a href="http://technorati.com/search/'+share_url+'" class="sharelink technorati" title="'+sharetxt[3]+'"></a></td>\
		<td id="share-delicious"><a href="http://del.icio.us/post?v=4;url='+share_url+';title='+share_title+'" class="sharelink delicious" title="'+sharetxt[4]+'"></a></td>\
		<td id="share-digg"><a href="http://digg.com/submit?phase=2&amp;url='+share_url+'&amp;title='+share_title+'" class="sharelink digg" title="'+sharetxt[5]+'"></a></td>\
		<td id="share-slashdot"><a href="http://slashdot.org/bookmark.pl?title='+share_title+'&amp;url='+share_url+'" class="sharelink slashdot" title="'+sharetxt[6]+'"></a></td>\
		';
		var links = gebtn('link');
		var feed_url = null;
		var feed_title = null;
		var numFeeds = 0;
		for (var a=0; a<links.length; a++) {
			if (''+links[a].rel.toLowerCase() == 'alternate') {
				numFeeds++;
				if (!feed_url) {
					feed_url = links[a].href;
					feed_title = links[a].title;
				}
			}
		}
		if (numFeeds > 1) {
			shareThisPage += '<td id="share-multiple-feeds"><a href="#" title="'+sharetxt[7]+'"></a></td>';
		} else if (numFeeds == 1) {
			shareThisPage += '<td id="share-feed"><a href="'+feed_url+'" class="sharelink feed" title="'+feed_title+'"></a></td>';
		} else {
			shareThisPage += '<td id="share-blank"> </td>';
		}
		shareThisPage += '</tr></table></div>';

		if(hasClassName(document.body,'a0v3')){return;}// not on media shells
		titleDiv.id='sharepage';
		if (is.ie5) { return; }
		if (typeof shareThisPage == 'undefined') { return; }
		share_title = (gebtn('h1',titleDiv)[0]) ? elemText(gebtn('h1',titleDiv)[0]) : share_title;
		share_title = share_title.normalize();
		shareThisPage = shareThisPage.replace(/{pagetitle}/,share_title);
		var metas = gebtn('meta');
		for (var a=0;a<metas.length;a++) {
			if (""+metas[a].name.toLowerCase()=='share-this-page' && ""+metas[a].content.toLowerCase()=='no') { return; }
		}
		var shareDiv = document.createElement('div');
		shareDiv.className = 'sharepage';
		titleDiv.appendChild(shareDiv);
		shareDiv.innerHTML = shareThisPage;
		var mult = gebi("share-multiple-feeds");
		if (mult) {
			var lnk = gebtn('a',mult)[0];
			lnk.titleDiv = titleDiv;
			lnk.mult = mult;
			addEvent(lnk,'click',function(e){
				if (!this.feedListDiv) {
					var links = gebtn('link');
					var feedLinks = [];
					var feedListStr = '<ul>';
					for (var a=0; a<links.length; a++) {
						if (''+links[a].rel.toLowerCase() == 'alternate') {
							feedLinks[feedLinks.length] = links[a];
						}
					}
					for (var a=0; a<feedLinks.length; a++) {
						feedListStr += '<li';
						if (a==0) { feedListStr += ' class="first-child"'; }
						else if (a==feedLinks.length - 1) { feedListStr += ' class="last-child"'; }
						feedListStr += '><div><a class="sharelink feed" href="'+feedLinks[a].href+'">'+feedLinks[a].title+'</a></div></li>';
					}
					feedListStr += '</ul><span class="x1"></span><span class="x2"></span>';
					var feedListDiv = elem('div',{'id':'share-feed-list'});
					feedListDiv.innerHTML = feedListStr;
					this.titleDiv.appendChild(feedListDiv);
					this.feedListDiv = feedListDiv;
					addClassName(this.mult,'showing');
					tagOmnitureCustomLinksForSharePage(this.feedListDiv);
				} else {
					if (hasClassName(this.feedListDiv,'hidethis')) {
						removeClassName(this.feedListDiv,'hidethis');
						addClassName(this.mult,'showing');
					} else {
						addClassName(this.feedListDiv,'hidethis');
						removeClassName(this.mult,'showing');
					}
				}
				cancelDefault(e);
			});
		}
		tagOmnitureCustomLinksForSharePage(shareDiv);
	}
}
function tagOmnitureCustomLinksForSharePage(el){
	if (typeof window.s_co!='undefined') {
		var custLink = function(e) {
			var prepend = this.className.replace(/sharelink /,"")+": ";
			s_linkType='o';
			s_linkName=prepend+this.href;
			s_lnk=s_co(this);
			s_gs(s_account);
		}
		var links = gebtn('a',el);
		for (var a=0; a<links.length; a++) {
			if (!hasClassName(links[a], 'sharelink')) { continue; }
			addEvent(links[a], 'click', custLink);
		}
	}
}

// SETUP -> IMG SWAP
var imgpreload = [];
function sniffImgswap() {
	var link = this;
	if (link.src){
		imgpreload[link.id] = new Image();
		imgpreload[link.id].src = link.src;
	}else{
		link.imgref = link.className.replace(/[^ ]* ?([^ ]+_\d).*/,"$1").split('_');
		link.src = gebi(link.imgref[0]).src.replace(/_\d+\./,"_"+link.imgref[1]+".");
		imgpreload[link.src] = new Image();
		imgpreload[link.src].src = link.src;
		if (!hasClassName(link,'swapOnclick')){
			link.onmouseover = function(){
				gebi(this.imgref[0]).src = imgpreload[this.src].src;
			}
			link.onmouseout = function(){
				gebi(this.imgref[0]).src = imgpreload[this.imgref[0]].src;
			}
			if (!hasClassName(link,'followLink')){
				link.onclick = function(){return false;}
			}
		}else{
			link.onclick = function(){
				imgpreload[this.imgref[0]].src = gebi(this.imgref[0]).src = imgpreload[this.src].src;
				return false;
			}
		}
	}
}

// SETUP -> IMG MULTI SWAP
function sniffMultiswap(){
	var fobj = this;
	if(fobj.src){
		imgpreload[fobj.id] = new Image();
		imgpreload[fobj.id].src = fobj.src;
		if(fobj.className.indexOf('mswap-') > -1){
			var aimg = fobj.className.split('mswap-')[1].split('-')[0].split(' ')[0];
			fobj.src = fobj.src.replace(/[^\/]+(\.....?)$/,aimg+'$1');
		}
	}
}

// CLICK -> IMG MULTI SWAP
function clickMultiswap(){
	this.targetid = this.className.split('mswap-')[1].split('-')[0].split(' ')[0];
	var prefixid = this.targetid.replace(/(.*)\d+?/,'$1');
	this.pre = prefixid;
	if(this.className.indexOf('mswap-'+this.targetid+'-') > -1){
		var imgfile = this.className.split('mswap-'+this.targetid+'-')[1].split(' ')[0];
	}else{
		var imgfile = this.href.replace(/.*\/([^\/]+)?/,'$1').split('.')[0];
	}
	this.src = gebi(this.targetid).src.replace(/[^\/]+(\.....?)$/,imgfile+'$1');
	imgpreload[this] = new Image();
	imgpreload[this].src = this.src;

	var n = 1;
	while(gebi(this.pre+n)){
		gebi(this.pre+n).src = imgpreload[this.pre+n].src;
		n++;
	}
	gebi(this.targetid).src = this.src;
	if (hasClassName(this,'followLink') || this.target != ''){
	}else{
		cancelDefault(e);
	}
}

// SETUP -> TOGGLE ALL CHECKBOXES IN A TABLE
function sniffToggleAllCheckboxesInTable(){
	var lnk = this;
	var pTab = lnk.parentNode;
	while(pTab.nodeName.toLowerCase()!='table'){pTab=pTab.parentNode;}
	lnk.checkStatus=true;
	lnk.titleSelect='Select All';
	lnk.titleUnselect='Unselect All';
	lnk.title=lnk.titleSelect;
	lnk.img=gebtn('img',lnk)[0];
	lnk.img.alt=lnk.titleSelect;
	var inputs=gebtn('input',pTab);
	lnk.checkboxes=[];
	for(var b=0;b<inputs.length;b++){
		if('checkbox'==inputs[b].type){lnk.checkboxes.push(inputs[b]);}
	}
	lnk.onclick=function(){
		for(var c=0;c<this.checkboxes.length;c++){
			this.checkboxes[c].checked=this.checkStatus;
		}
		this.title=(this.checkStatus)?this.titleUnselect:this.titleSelect;
		this.img.alt=(this.checkStatus)?this.titleUnselect:this.titleSelect;
		this.checkStatus=!this.checkStatus;
		return false;
	}
}

// SETUP -> EXPANDIBLE / COLLAPSIBLE PC1
function sniffExpandCollapsePc1(){
	addClassName(this,'pc1collapsed');
	removeClassName(this,'pc1collapsible');
	var h=gebtn('h2',this)[0];
	var lnk=elem('a.pc1toggler',{'href':'#'},' '+elemText(h));
	var im=elem('img',{'src':imdir+'/pc1-expand.gif','alt':'','class':'pc1expand-collapse-icon','border':'0'});
	im.srcCollapse=imdir+'/pc1-collapse.gif';
	im.srcExpand=im.src;
	lnk.titleCollapse='Collapse this section';
	lnk.titleExpand='Expand this section';
	lnk.title=lnk.titleExpand;
	lnk.insertBefore(im,lnk.firstChild);
	lnk.im=im;
	lnk.div=this;
	h.innerHTML='';
	h.appendChild(lnk);
	var outerContainer=gebcn('cornerBR',this)[0];
	var p=elem('p',{'class':'pc1expand-note'},' Click the plus icon to expand this section.');
	var innerContainer = elem('div.pc1container');
	innerWrap(outerContainer,innerContainer);
	outerContainer.appendChild(p);
}

reg.click('a.pc1toggler',function(){
	if(hasClassName(this.div,'pc1expanded')){
		addClassName(this.div,'pc1collapsed');
		removeClassName(this.div,'pc1expanded');
		this.title=this.titleExpand;
		this.im.src=this.im.srcExpand;
	}else{
		addClassName(this.div,'pc1expanded');
		removeClassName(this.div,'pc1collapsed');
		this.title=this.titleCollapse;
		this.im.src=this.im.srcCollapse;
	}
	return false;
});

// SETUP -> CLASS TOGGLE
function sniffClassTool(){
	var fobj = this;
	var cls = fobj.className.split(' ');
	for (var v=0;v<cls.length;v++){
		if (cls[v].indexOf('cTool-') == 0){
			var objs = cls[v].split('cTool-')[1].split('-');
			if(objs[objs.length - 1].indexOf('RMV') > -1 || objs[objs.length - 1].indexOf('TGL') > -1 || objs[objs.length - 1].indexOf('ADD') > -1){
				var action = "click";
			}else{
				var action = objs[objs.length - 1];
				objs.pop();
			}
			fobj.objs = objs;
			fobj.tid = objs.shift();
			var thistest = fobj.tid;
			if(fobj.tid == "this"){
				fobj.tid = fobj;
			}
			if (action == 'hover' && !is.ie56 && thistest == "this"){
				// then do this hover in the css!
			}else if(action == 'hover'){
				addEvent(fobj,"mouseout",function(e){
					classomatic(this.tid,this.objs);
				});
				var action = "mouseover";
				addEvent(fobj,action,function(e){
					classomatic(this.tid,this.objs);
					if (action == 'click'){
						cancelDefault(e);
					}
				});
			}else{
				addEvent(fobj,action,function(e){
					classomatic(this.tid,this.objs);
					if (action == 'click'){
						cancelDefault(e);
					}
				});
			}
		}
	}
}
function classomatic(id,todo){
	if(!gebi(id)){
		var tobj = id;
	}else{
		var tobj = gebi(id);
	}
	for (var v=0;v<todo.length;v++){
		if(todo[v].indexOf('RMV') == 0){
			removeClassName(tobj, todo[v].substring(3,todo[v].length));
		}else if(todo[v].indexOf('ADD') == 0){
			addClassName(tobj, todo[v].substring(3,todo[v].length));
		}else if(todo[v].indexOf('TGL') == 0){
			if (hasClassName(tobj, todo[v].substring(3,todo[v].length))){
				removeClassName(tobj, todo[v].substring(3,todo[v].length));
			}else if (!hasClassName(tobj, todo[v].substring(3,todo[v].length))){
				addClassName(tobj, todo[v].substring(3,todo[v].length));
			}
		}
	}
}

// SETUP -> GENERIC TOGGLER
function sniffToggler(){
	var fobj = this;
	if (fobj.toggler) { return; }
	if(hasClassName(fobj, 'showThis')){
			fobj.toggler = fobj.href.split('#')[1];
			addEvent(fobj,"click",function(e){
				var objRoot = this.toggler.replace(/\d+?/,"");
				var n = 1;
				while(gebi(objRoot+n)){
					if(this.toggler == objRoot+n){
						removeClassName(gebi(this.toggler), 'hidethis');
					}else{
						addClassName(gebi(objRoot+n), 'hidethis');
					}
					n++;
				}
				cancelDefault(e);
			});
	}else{
		var cls = fobj.className.split(' ');
		for (var v=0;v<cls.length;v++){
			if (cls[v].indexOf('objects-') == 0){
				fobj.toggler = cls[v].replace(/objects-/,"");
			}
		}
		addEvent(fobj,"click",function(e){
			var tid = this.toggler.split('-');
			for (var i=0; i<tid.length; i++){
				if (tid[i].indexOf('ALL') > -1){
					var tAll = [];
					var x = 1;
					while (gebi(tid[i].split('ALL')[0]+x)){
						tAll.push(tid[i].split('ALL')[0]+x);
						x++;
					}
					for (var j=0; j<tAll.length; j++){
						toggler(this,tAll[j]);
					}
				}else{
					toggler(this,tid[i]);
				}
			}
			cancelDefault(e);
		});
	}
}
function toggler(fobj,id){
	if (hasClassName(gebi(id), 'hidethis') && !hasClassName(fobj, 'hideall') || hasClassName(fobj, 'showall')){
		removeClassName(gebi(id), 'hidethis');
	}else if (!hasClassName(gebi(id), 'hidethis') || hasClassName(fobj, 'hideall')){
		addClassName(gebi(id), 'hidethis');
	}
}

// SETUP -> UL.LISTFADE
var ulid = 0;
function sniffListfade(){
	var fobj = this;
	ulid++;
	var li = gebtn('li',fobj);
	var x = 0;
	while (li[x]){
		li[x].id = 'ulfade'+ulid+(x+1);
		if (x==0){
			addClassName(li[x], 'xfadefirst');
			var p = 'pause5';
			if (fobj.className.indexOf('pause') > -1){
				p = getClassContains(fobj,'pause');
			}
			addClassName(li[x], p);
		}else{
			addClassName(li[x], 'xfade');
		}
		x++;
	}
	sniffXfade.call(li[0]);
}

// SETUP -> AJAX INCLUDE
function sniffLoadUrl(){
	var fobj = this;
	if(fobj.href.indexOf('#') > -1){
		var thehref = fobj.href.split('#')[0];
		var id = fobj.href.split('#')[1];
		getfile(thehref,function(rdata,objs){
			if(objs[0]){
				rdata = getRequestObject(objs[0],rdata);
				var wclass = rdata.className;
				rdata = rdata.innerHTML;
			}
			if(objs[1].parentNode.className.indexOf('g32auto') > -1 && objs[0]){
				objs[1].parentNode.className = wclass;
				objs[1].parentNode.innerHTML = rdata;
			}else{
				var insertDIV = elem('div');
				objs[1].parentNode.insertBefore(insertDIV, objs[1]);
				insertDIV.innerHTML = rdata;
				reg.rerun(insertDIV);
				objs[1].parentNode.removeChild(objs[1]);
			}
		},[id,fobj]);
	}
}

// SETUP -> FORM AJAXER
function sniffFormHijax(){
	var fobj = this;
	addEvent(fobj,"submit",function(e){
		var targetDiv = getClassContains(this, "gform-").split('gform-')[1];
		var tDivObj = gebi(targetDiv);
		var hjx = (tDivObj.className.indexOf('hijaxTrue') > -1) ? '&hijax=true' : '';
		var h = tDivObj.offsetHeight;
		tDivObj.innerHTML = '';
		tDivObj.style.height=h+'px';
		addClassName(tDivObj, 'hijaxLoading');

		if(hasParent(this,targetDiv)){
			var findSubmits = gebtn('input',this);
			var foundSubmits = [];
			for (i=0; i<findSubmits.length; i++){
				if(findSubmits[i].type == 'submit'){
					foundSubmits.push(findSubmits[i]);
				}
			}
			for (i=0; i<foundSubmits.length; i++){
				addClassName(foundSubmits[i], 'disabled');
			}
		}
		getfile(this.action+'?'+getFormData(this)+hjx, function(rdata,fvar){
			if(rdata.indexOf(targetDiv) > -1){
				rdata = getRequestObject(targetDiv,rdata).innerHTML;
			}
			var tDivObj = gebi(targetDiv);
			removeClassName(tDivObj, 'hijaxLoading');
			tDivObj.style.height='auto';
			tDivObj.innerHTML = rdata;
			reg.rerun(tDivObj);
		},false,false,true);
		cancelDefault(e);
	});
}

// SETUP -> XFADE
var xfade = [];
var xfadeObj = [];
var xfadeLoop = [];
var xfadeStop = [];
function sniffXfade(){
	var fobj = this;
	if ((fobj.id.substring((fobj.id.length - 1),fobj.id.length) * 1) == 1){
		var transparent = false;
		var bgforie;
		var pause = 10000;
		var id =  fobj.id.substring(0,(fobj.id.length - 1));
		var cls = fobj.className.split(' ');
		for (var v=0;v<cls.length;v++){
			if (cls[v].indexOf("pause") == 0){
				pause = cls[v].replace(/pause(.*)$/,"$1");
				pause = pause * 1000;
			}else if (cls[v].indexOf("transparent") == 0){
				transparent = true;
			}else if (cls[v].indexOf(".jpg") == 0 || cls[v].indexOf(".gif") == 0){
				bgforie = cls[v];
			}
		}
		var xf = 1;
		while (gebi(id+xf)){
			xfadeObj[id+xf] = [gebi(id+xf),0];
			xfadeObj[id+xf][0].onmouseover = function(){if(xfadeStop[id][0] != -1){xfadeStop[id][0] = 0;}}
			xfadeObj[id+xf][0].onmouseout  = function(){if(xfadeStop[id][0] != -1){xfadeStop[id][0] = 1;}}
			// transparent obj
			if (transparent){
				if (is.oldmoz){
					setopacity(xfadeObj[id+xf][0],1);
					xfadeObj[id+xf][0].style.visibility = "hidden";
				}
				if (bgforie && is.iewin){
					xfadeObj[id+xf][0].style.backgroundImage = 'url('+bgforie+')';
				}
				if (is.oldmoz && xf == 1){
					xfadeObj[id+xf][0].style.visibility = "visible";
				}
			}
			xf++;
		}
		xf--;
		xfade[id] = [xf,1,pause];
		if (gebi(id+'Total')){
			gebi(id+'Total').innerHTML = xf;
		}
		if (gebi(id+'Back')){
			gebi(id+'Back').onclick = function(){
				xfadeStop[id] = [-1,-1];
				clearTimeout(xfadeLoop[id]);
				xfader(id);
				return false;
			};
		}
		if (gebi(id+'Next')){
			gebi(id+'Next').onclick = function(){
				xfadeStop[id] = [-1,1];
				clearTimeout(xfadeLoop[id]);
				xfader(id);
				return false;
			};
		}
		xfadeStop[id] = [1,1];
		xfadeLoop[id] = setTimeout('xfader(\''+id+'\')',pause);
	}
}
function xfader(id){
	// define this/next frame
	var nx = xfade[id][1] + xfadeStop[id][1];
	if(nx > xfade[id][0]){
		nx = 1;
	}
	if(nx < 1){
		nx = xfade[id][0];
	}
	var stillfading = false;
	if (xfadeStop[id][0] == 0 && xfadeObj[id+nx][1] != 0){
		var stillfading = true;
	}
	var ox = xfade[id][1];
	if (xfadeObj[id+ox][1] == 0){
		xfadeObj[id+ox][1] = 1;
	}
	if (xfadeStop[id][0] != 0 || stillfading){
		// set up objects
		if (xfadeObj[id+nx][1] == 0){
			if (!is.oldmoz){
				setopacity(xfadeObj[id+nx][0],.1);
			}
			xfadeObj[id+nx][0].style.visibility = "visible";
			xfadeObj[id+ox][0].style.zIndex = 2;
			xfadeObj[id+nx][0].style.zIndex = 10;
		}
		// if skip to next
		if (xfadeStop[id][0] == -1){
			xfadeObj[id+nx][1] = 1;
		}else{
			if (is.safari || is.oldmoz || is.ns6 || is.iemac){
				xfadeObj[id+nx][1] = 1;
			}else{
				xfadeObj[id+nx][1] = xfadeObj[id+nx][1] + .2;
			}
		}

		// set opac
		if (is.anymoz && xfadeObj[id+nx][1] == 1){
			if (!is.oldmoz){
				setopacity(xfadeObj[id+nx][0],.99);
			}
		}else{
			setopacity(xfadeObj[id+nx][0],xfadeObj[id+nx][1]);
		}
		// if fading else, complete and pause
		if (xfadeObj[id+nx][1] < 1){
			setTimeout('xfader(\''+id+'\')',120);
		}else{
			xfade[id][1] = nx;
			xfadeObj[id+ox][0].style.visibility = "hidden";
			xfadeObj[id+ox][1] = 0;
			if (gebi(id+'This')){
				gebi(id+'This').innerHTML = nx;
			}
			if (xfadeStop[id][0] != 0){
				xfadeStop[id] = [1,1];
				xfadeLoop[id] = setTimeout('xfader(\''+id+'\')',xfade[id][2]);
			}
		}
	}
	// if paused
	if(xfadeStop[id][0] == 0){
		clearTimeout(xfadeLoop[id]);
		xfadeLoop[id] = setTimeout('xfader(\''+id+'\')',200);
	}
}

// BUBBLE -> LINK AJAXER
var hijaxCache = {};
function hijaxLink(ev){
var link = this;
	if (hasClassName(link, 'noHijax')) { return true; }
	if (this.target) { return true; }
	try{
		if (link.className.indexOf('hijax-') > -1){
			var hijaxEl = this;
		}else{
			var hijaxEl = getParent(link, "@class*='hijax-'");
		}
		var id = matchClassName(hijaxEl,/^hijax-(\S*)/)[1];
		var targetDiv = gebi(id);
		if (targetDiv.className.indexOf('hijaxTrue') > -1){
			var delim = (link.href.indexOf('?') > -1) ? '&' : '?';
			var linkHref = link.href+delim+"hijax=true";
		}else{
			var linkHref = link.href;
		}
		var h = targetDiv.offsetHeight;
		targetDiv.innerHTML = '';
		targetDiv.style.height=h+'px';
		addClassName(targetDiv, 'hijaxLoading');
	} catch (ex) {
		return true;
	}

	var hstring = linkHref+' ';
	if (!hijaxCache[hstring]){
		xhr(linkHref, function(rdata,obj){
			// succeed
			var el = getElementByIdFromString(rdata, id);
			if (!el) { window.location=link.href; }
			rdata = el.innerHTML;
			hijaxCache[hstring] = rdata;
			removeClassName(targetDiv, 'hijaxLoading');
			targetDiv.style.height='auto';
			targetDiv.innerHTML = rdata;
			reg.rerun(targetDiv);
			if(gebi('linkToPage') && !hasClassName(targetDiv, 'noPermalink')){
				gebi('linkToPage').href = link.href;
			}
		},function(){
			// fail
			window.location=link.href;
		});
		return false;
	}else{
		targetDiv.innerHTML = hijaxCache[hstring];
		removeClassName(targetDiv, 'hijaxLoading');
		reg.rerun(targetDiv);
		if(gebi('linkToPage') && !hasClassName(targetDiv, 'noPermalink')){
			gebi('linkToPage').href = link.href;
		}
		return false;
	}
}

// BUBBLE -> SPRITE SWAP
function spriteOver(){
	this.style.left = (this.width)/2 * -1 +'px';
}
function spriteOut(){
	this.style.left = 0+'px';
}

// event handler funcs for .jscal
(function(){
	var calendarEls = [];
	function launchCal(e) {
		var id = this.id;
		if (!id) { throw 'date field missing id attribute'; }
		if (calendarEls[id] && calendarEls[id].parentNode) { return; }
		for (var oid in calendarEls) {
			if (id == oid){continue;}
			if (calendarEls[oid] && calendarEls[oid].parentNode) {
				calendarEls[oid].parentNode.removeChild(calendarEls[oid]);
				calendarEls[oid] = null;
			}
		}
		var parentInputBox = getParent(this,'div.labeled-input');
		if(parentInputBox){addClassName(parentInputBox,'has-jscal');}
		if (this.value) { var time = Date.parse(this.value); var inpDate = (!isNaN(time)) ? new Date(time) : new Date(); }
		else { var inpDate = new Date(); }

		var rangeId = matchClassName(this,/^range-(.+)/);
		if (rangeId) {
			var rangeEl = gebi(rangeId[1]);
			if(!rangeEl){throw 'no element found with id="'+rangeId[1]+'"';}
			var startDate,endDate;
			var startArr = gebcn('jscal-start', rangeEl);
			var endArr = gebcn('jscal-end', rangeEl);
			if (startArr.length) {
				var time = Date.parse(elemText(startArr[0]));
				if (isNaN(time)) { throw 'Date.parse("'+elemText(startArr[0])+'") returns NaN'; }
				startDate=new Date(time);
			}
			if (endArr.length) {
				var time = Date.parse(elemText(endArr[0]));
				if (isNaN(time)) { throw 'Date.parse("'+elemText(endArr[0])+'") returns NaN'; }
				endDate=new Date(time);
			}
			if (startDate && startDate.getTime() > inpDate.getTime()) { inpDate = startDate.diffDay(0); }
			if (endDate && endDate.getTime() < inpDate.getTime()) { inpDate = endDate.diffDay(0); }
			if (startDate && endDate && startDate.getTime() > endDate.getTime()) { throw 'whoops! start date is less than end date'; }
		}
		var myFormat = defaultDateFormat;
		var formatId = matchClassName(this,/^format-(.+)/);
		if (formatId) {
			var formatEl = gebi(formatId[1]);
			if(!formatEl){throw 'no element found with id="'+formatId[1]+'"';}
			myFormat = elemText(formatEl);
		}

		calendarEls[id] = (new Calendar(inpDate, startDate, endDate)).getCalendarTable();
		calendarEls[id].inp = this;
		this.parentNode.appendChild(calendarEls[id]);
		addEvent(calendarEls[id],'click',function(e){
			var targ = getTarget(e);
			if (targ.date && getParent(targ, '.jscal-inrange')) {
				this.inp.value = targ.date.format(myFormat);
				calendarEls[id].parentNode.removeChild(calendarEls[id]);
			}
		});
	}
	function closeCal(e){
		var targ = getTarget(e);
		var parJscalTable = getParent(targ, 'div.jscal-x1');
		if (parJscalTable || matches(targ, 'input.jscal@type="text", table.jscal, div.jscal-x1')) { return; }
		for (var id in calendarEls) {
			if (calendarEls[id] && calendarEls[id].parentNode) {
				calendarEls[id].parentNode.removeChild(calendarEls[id]);
				calendarEls[id] = null;
			}
		}
	}
	reg.focus('input.jscal@type="text"', launchCal);
	reg.focus('body', closeCal);
	reg.click('body', closeCal);

})();

(function(){
	function animate(collapsing, expanding) {
		removeClassName(collapsing, 'g39exp');
		removeClassName(expanding, 'g39coll');
		addClassName(collapsing, 'g39t1');
		addClassName(expanding, 'g39t6');
		var inc = 20;//ms
		window.setTimeout(function() { collapsing.className = collapsing.className.replace(/g39t1/, "g39t2");   expanding.className = expanding.className.replace(/g39t6/, "g39t5");  }, inc*1);
		window.setTimeout(function() { collapsing.className = collapsing.className.replace(/g39t2/, "g39t3");   expanding.className = expanding.className.replace(/g39t5/, "g39t4");  }, inc*2);
		window.setTimeout(function() { collapsing.className = collapsing.className.replace(/g39t3/, "g39t4");   expanding.className = expanding.className.replace(/g39t4/, "g39t3");  }, inc*3);
		window.setTimeout(function() { collapsing.className = collapsing.className.replace(/g39t4/, "g39t5");   expanding.className = expanding.className.replace(/g39t3/, "g39t2");  }, inc*4);
		window.setTimeout(function() { collapsing.className = collapsing.className.replace(/g39t5/, "g39t6");   expanding.className = expanding.className.replace(/g39t2/, "g39t1");  }, inc*5);
		window.setTimeout(function() { collapsing.className = collapsing.className.replace(/g39t6/, "g39coll"); expanding.className = expanding.className.replace(/g39t1/, "g39exp"); }, inc*6);
	}
	reg.click('div.g39sect',function(e){
		var allSects = gebs('div.g39sect',this.parentNode);
		for(var i=0;i<allSects.length;i++){
			var aSect = allSects[i];
			if (hasClassName(aSect, 'g39exp') && aSect != this) {
				animate(aSect, this);
				break;
			}
		}
	});
})();

// ONLOAD -> platform detection for select menu
function platformDetect(){
	/*
	for this script to work the select menu needs to have the class "platformDetect"
	then the string in the OPTION object needs to match one of the strings below...

	Solaris
	Solaris SPARC
	Solaris x86
	Linux
	Linux x86
	Linux x64
	Windows
	Windows 2000
	Windows XP
	Windows Vista
	Mac OS X
	Mac OS X (Intel)
	Mac OS X (PowerPC)
	*/

    var thisMajor = "";
    var thisMinor = "";
    var agent = navigator.userAgent.toUpperCase();
    if(agent.indexOf("SUNOS") > -1){
        thisMajor = "Solaris";
	}else if(agent.indexOf("MAC OS") > -1){
        thisMajor = "Mac OS X";
	}else if(agent.indexOf("LINUX") > -1){
        thisMajor = "Linux";
	}else if(agent.indexOf("WINDOWS") > -1){
        thisMajor = "Windows";
    }
    if(agent.indexOf("SUNOS SUN4") > -1){
        thisMinor = "Solaris SPARC";
	}
    if(agent.indexOf("SUNOS I86PC") > -1){
        thisMinor = "Solaris x86";
    }
    if(agent.indexOf("LINUX") > -1 && agent.indexOf("86;") > -1){
        thisMinor = "Linux x86";
    }
    if(agent.indexOf("LINUX") > -1 && agent.indexOf("X86_64") > -1){
        thisMinor = "Linux x64";
    }
    if(agent.indexOf("WINDOWS NT 5.0") > -1){
        thisMinor = "Windows 2000";
    }
    if(agent.indexOf("WINDOWS NT 5.1") > -1){
        thisMinor = "Windows XP";
    }
    if(agent.indexOf("WINDOWS NT 6.0") > -1){
        thisMinor = "Windows Vista";
    }
    if(agent.indexOf("INTEL MAC OS") > -1){
        thisMinor = "Mac OS X (Intel)";
    }
    if(agent.indexOf("PPC MAC OS") > -1){
        thisMinor = "Mac OS X (PowerPC)";
    }

	var minor = false;
	var option = gebtn('option',this);
	for (var n=0;n<option.length;n++){
		if(option[n].innerHTML.toUpperCase() == thisMinor.toUpperCase()){
			option[n].selected = true;
			minor = true;
			break;
		}
	}
	if(!minor){
		for (var n=0;n<option.length;n++){
			if(option[n].innerHTML.toUpperCase() == thisMajor.toUpperCase()){
				option[n].selected = true;
				break;
			}
		}
	}
}

// ONLOAD -> language detection for select menu
function langDetect(){
	/*
	for this script to work the select menu needs to have the class "langDetect"
	then the string in the OPTION object needs to match one of the strings below...

	Danish
	English
	Dutch
	French
	German
	Hindi
	Indian
	Italian
	Japanese
	Korean
	Polish
	Portuguese
	Russian
	Simplified Chinese
	Traditional Chinese
	Spanish
	Swedish
	Turkish

	alternatively, if the menu text is not in english, class names may be used on each
	OPTION tag to identify which language each OPTION represents this is done using iso
	language id's in the format <option class="lang_en" ...> where _en represents english.
	supported language codes are show below...

	en = English
	da = Danish
	nl = Dutch
	fr = French
	de = German
	hi = Hindi
	it = Italian
	ja = Japanese
	ko = Korean
	pl = Polish
	pt = Portuguese
	ru = Russian
	es = Spanish
	sv = Swedish
	tr = Turkish
	zh-cn = Simplified Chinese
	zh-tw = Traditional Chinese

	*/

	var lang = null;

	if (navigator.language){
		lang = navigator.language.toUpperCase();
	}else if (navigator.browserLanguage){
		lang = navigator.browserLanguage.toUpperCase();
	}else if (document.documentElement.lang){
		lang = document.documentElement.lang.toUpperCase();
	}

	if(lang.indexOf("DA") > -1){
        lang = "da_Danish";
    }else if(lang.indexOf("NL") > -1){
        lang = "nl_Dutch";
    }else if(lang.indexOf("FR") > -1){
        lang = "fr_French";
    }else if(lang.indexOf("DE") > -1){
        lang = "de_German";
    }else if(lang.indexOf("HI") > -1){
        lang = "hi_Hindi";
    }else if(lang.indexOf("IT") > -1){
        lang = "it_Italian";
    }else if(lang.indexOf("JA") > -1){
        lang = "ja_Japanese";
    }else if(lang.indexOf("KO") > -1){
        lang = "ko_Korean";
    }else if(lang.indexOf("PL") > -1){
        lang = "pl_Polish";
    }else if(lang.indexOf("PT") > -1){
        lang = "pt_Portuguese";
    }else if(lang.indexOf("RU") > -1){
        lang = "ru_Russian";
    }else if(lang.indexOf("ZH-CN") > -1 || lang.indexOf("ZH-HANS") > -1){
        lang = "zh-cn_Simplified Chinese";
    }else if(lang.indexOf("ZH-TW") > -1 || lang.indexOf("ZH-HANT") > -1){
        lang = "zh-tw_Traditional Chinese";
    }else if(lang.indexOf("ES") > -1){
        lang = "es_Spanish";
    }else if(lang.indexOf("SV") > -1){
        lang = "sv_Swedish";
    }else if(lang.indexOf("TR") > -1){
        lang = "tr_Turkish";
    }else{
        lang = "en_English";
    }

	var option = gebtn('option',this);
	for (var n=0;n<option.length;n++){
		if(option[n].innerHTML.toUpperCase() == lang.split('_')[1].toUpperCase() || option[n].className.indexOf("lang_"+lang.split('_')[0]) > -1){
			option[n].selected = true;
			break;
		}
	}
}

// L6
var l6 = (function(s){

	// Event Handlers
	function openBox(e){
		reg.addClassName(reg.getParent(this, s.box), s.classOpen);
		reg.cancelDefault(e);
	};

	function closeBox(e){
		reg.removeClassName(reg.getParent(this, s.box), s.classOpen);
		reg.cancelDefault(e);
	};

	// Init
	function l6(){
		reg.click(s.open, openBox);
		reg.click(s.close, closeBox);
		return l6;
	};
	return l6();
})({
	bg:'div.l6bg',
	box:'div.l6box',
	classOpen:'l6box-open',
	open:'div.l6box a.l6box-open',
	close:'div.l6 a.l6box-close'
});

// imgMaxWidth
// This makes CSS resized images into k5's so that the user can click to see the larger image
// does not function in IE 5 or 6 since it relies on max-width
reg.click("@class*='pc11' img",function(){
	if(this.parentNode.nodeName.toLowerCase() != "a" && !hasClassName(this, 'fullsized') && !is.ie56){
		var pdiv = getParent(this, '.pc11');
		this.style.border="0px";
		var x = 0;
		while(getElementById('imgMax'+x)){
			x++;
		}
		pdiv.appendChild(elem('div',{'id':'imgMax'+x,'class':'maximagek5'},[elem('div',{'style':'text-align:center'},[elem('img',{'src':this.src})])]));
		var a = elem('a.k5 '+ ((getElementById('imgMax'+x).getElementsByTagName('img')[0].offsetWidth)),{'href':'#imgMax'+x});
		outerWrap(this, a);
		k5Click.call(this.parentNode);
	}
});

reg.hover("@class*='imgMax-' img",function(){
	var imgw = this.offsetWidth;
	var maxw = getParent(this, '.pc11');
	maxw = maxw.className.split('imgMax-')[1].split(' ')[0];
	if(imgw < maxw){
		addClassName(this, 'fullsized')
	}else{
		removeClassName(this, 'fullsized')
	}
});


////////////////////////////
// OMNITURE LINK TRACKING //
////////////////////////////

// links are only tracked for the first click listed
// below that matches the selector

// this custom track must stay first in the order
reg.click('.overwriteTrack a',function(){
	var cnm = getParent(this, "@class*='track-'");
	if (cnm){
		cnm = cnm.className.split('track-')[1].split(' ')[0];
		oTrack(this,cnm);
	}
});
reg.click('div#breadcrumb a',function(){oTrack(this,'A4')});
reg.click('div.gwpadding1 a,td.sectiontitle2 a',function(){oTrack(this,'D1/2')});
reg.click('td.suntab a',function(){oTrack(this,'D7-Tab')});
reg.click('div.suntabsubrow a',function(){oTrack(this,'D7-SubTab')});
reg.click('div.d7v10 a',function(){oTrack(this,'D7-TertiaryTab')});
reg.click('div.d8 a',function(){oTrack(this,'D8')});
reg.click('div.e14 a',function(){oTrack(this,'E14')});
reg.click('div.e15 a',function(){oTrack(this,'E15')});
reg.click('div.e19 a',function(){oTrack(this,'E19')});
reg.click('div.g23x a',function(){if(!hasClassName(this,'g23toggler')){oTrack(this,'G23')}});
reg.click('div.g28 a',function(){oTrack(this,'G28')});
reg.click('div.vidtext a,div.vidbox a',function(){oTrack(this,'G37')});
reg.click('div.hb1w1 a,div.hb1v1 a,div.hb1v2 a',function(){oTrack(this,'HB1')});
reg.click('div.i03 a',function(){oTrack(this,'I3')});
reg.click('div.l0v0 a,div.l0v1 area,div.l0v2 area,div.l0v3 a',function(){oTrack(this,'L0')});
reg.click('div.l1 a',function(){oTrack(this,'L1')});
reg.click('div.l2 a',function(){oTrack(this,'L2')});
reg.click('div.l3 a',function(){oTrack(this,'L3')});
reg.click('div.l5 a',function(){oTrack(this,'L5')});
reg.click('div.l6v1 a,div.l6v2 a',function(){oTrack(this,'L6')});
reg.click('div.l6v0 a.l6box-open',function(){
	// add panel position info to omniture link tracking
	var l6v0 = getParent(this,'.l6v0'),thisBtn = this;
	gebs('a.l6box-open',l6v0).forEach(function(thatBtn,index){
		var txt = "opening L6 panel "+(index+1);
		if(thisBtn===thatBtn){oTrack(this,'L6',txt);}
	});
});
reg.click('div.pm1 a',function(){oTrack(this,'PM1')});
reg.click('div.pc9 a',function(){oTrack(this,'PC9')}); // do not move below the PC0!
reg.click('div.pc0 a',function(){oTrack(this,'PC0')});
reg.click('div.pc3 a',function(){oTrack(this,'PC3')});
reg.click('div.pc4 a',function(){oTrack(this,'PC4')});
reg.click('div.pn0 a',function(){oTrack(this,'PN0')});
reg.click('div.pn4 a',function(){oTrack(this,'PN4')});
reg.click('div.pn5 a',function(){oTrack(this,'PN5')});
reg.click('div.e4v0 a',function(){oTrack(this,'E4v0')});
reg.click('div.e4v2 a',function(){oTrack(this,'E4v2')});
reg.click('div.e4v3 a',function(){oTrack(this,'E4v3')});
reg.click('div.pn6xnav a,div.pn6 a',function(){oTrack(this,'PN6')});
reg.click('div.hb1w2 a',function(){oTrack(this,'HB1-Content')});
// always leave this as the last omniture track function
reg.click("@class*='track-' a",function(){
	var cnm = getParent(this, "@class*='track-'");
	cnm = cnm.className.split('track-')[1].split(' ')[0];
	oTrack(this,cnm);
});

// hb1 auto selector, looks for ID in ULR foo.html#bar and opens #bar if exist
// setup only happens if URL contains #
(function(){
var loco = document.location+'';
	if(loco.indexOf('#') > 1){
		reg.setup('div.hb1w1 a',function(){
			if(loco.split('#')[1] == this.href.split('#')[1]){
				hb1select(this);
			}
		});
	}
})();

// hb1 click
reg.click('div.hb1w1 a,a.hb1trigger',function(){
	hb1select(this);
	return false;
});

// hb1 selector function
function hb1select(a,st){
	if(a.href.split('#')[1] && !hasClassName(a,'hb1trigger')){
		if(!hasClassName(a.parentNode,'hb1selected') || hasClassName(a.parentNode,'hb1selected') && st){
			// hide all
			var li = a.parentNode.parentNode.getElementsByTagName('li');
			for (var i=0;i<li.length;i++){
				if(!st){ removeClassName(li[i],'hb1selected');}
				removeClassName(gebi(li[i].getElementsByTagName('a')[0].href.split('#')[1]),'hb1selectedpanel');
			}
			addClassName(gebi(a.href.split('#')[1]),'hb1selectedpanel');

			// fade in new div
			gebi(a.href.split('#')[1]).sfade = null;
			setopacity(gebi(a.href.split('#')[1]),0);
			sfadein(gebi(a.href.split('#')[1]),.025);

			// highlight current li
			addClassName(a.parentNode,'hb1selected');
		}
	}else if(a.href.split('#')[1] && hasClassName(a,'hb1trigger')){
		var subtoggle = (hasClassName(a,'subtoggle'))? true : false;
		hb1s = gebs("div.hb1w1 a");
		for (var i=0;i<hb1s.length;i++){
			if(hb1s[i].href.split('#')[1] == a.href.split('#')[1]){
				hb1select(hb1s[i],subtoggle);
			}
		}
	}else{
		return;
	}
}

reg.setup('div.g41',function(){

	// get pre object
	var pre = this.getElementsByTagName('pre')[0];

	// if fixed height, add adjusters, set height
	if(this.className.indexOf('fixed-') > -1){
		if(this.getElementsByTagName('h5')[0]){addClassName(this,'hasttl')}
		var ex = elem('a.g41expand',{'href':'#increase'});
		var co = elem('a.g41collapse',{'href':'#decrease'});
		ex.onclick = function(){ resizeObjectHeight(this.parentNode.getElementsByTagName('div')[0],80,-20);return false;};
		co.onclick = function(){ resizeObjectHeight(this.parentNode.getElementsByTagName('div')[0],-80,20);return false;};
		this.appendChild(ex);
		this.appendChild(co);
		this.getElementsByTagName('div')[0].style.height = this.className.split('fixed-')[1].split(' ')[0]+'px';
	}

	// clean up leading and trailing whitespace on top/bottom only (not in IE)
	var wspace = (is.ie) ? false : true;
	while(wspace){
		pre.innerHTML = pre.innerHTML.replace(/^[ 	]*\n/,"\n");
		if(pre.innerHTML.indexOf('\n') == 0){
			pre.innerHTML = pre.innerHTML.replace(/^\n/,"");
		}else{
			wspace = false;
			pre.innerHTML = pre.innerHTML.replace(/[ 	\n]*$/,"\n");
		}
	}

	// install g41_codeprettify if needed
	if(typeof prettyPrint == 'undefined' && hasClassName(pre, 'prettyprint')){
		document.getElementsByTagName('head')[0].appendChild(elem('script',{'src':'/js/g41_codeprettify.js','type':'text/javascript'}));
	}
});

function resizeObjectHeight(obj,incr,paddingDiff){
	var currh = obj.offsetHeight;
	if(obj.rsize){
		if((currh + incr) <= obj.rsize){
			obj.style.height = obj.rsize + 'px';
		}else{
			obj.style.height = obj.offsetHeight + incr + paddingDiff + 'px';
		}
	}else if(incr < 0){
		obj.rsize = obj.offsetHeight;
	}else{
		obj.rsize = obj.offsetHeight;
		obj.style.height = obj.offsetHeight + incr + paddingDiff + 'px';
	}

}

// G25 SELECTORS SHOW/HIDE PORTIONS OF FORM
reg.change(".g25 select.showhide", function(){
	var selected = this.options[this.options.selectedIndex];
	var showHideAll = {};
	gebs('option',this).forEach(function(option){
		option.showHide = {};
		var matches = option.className.match(/(^|\s)(#.+(\s+#.+)*)/);
		if (!matches) { return; }
		var hashIds = matches[2].split(/\s+/);
		hashIds.forEach(function(hashId){
			var id = hashId.substring(1);
			var showHideEl = gebi(id);
			if (!showHideEl) { return; }
			showHideAll[id] = option.showHide[id] = showHideEl;
		});
	});
	for (id in showHideAll) { acn(showHideAll[id], 'hidethis'); }
	gebs('option',this).forEach(function(option){
		if (option === selected) {
			for (id in option.showHide) {
				rcn(option.showHide[id], 'hidethis');
			}
		}
	});
});

// LEARNING PATH PACKAGE EDITION TOGGLE
(function(){
	var links = null;//a list of all package edition links
	reg.click("div.lppkged li > a@href",function(){
		if (!links) {
			//populate list
			links = gebs("div.lppkged li > a@href");
			for (var i=0; i<links.length; i++) {
				//on the link, store a ref to the corresponding
				//set of package edition items
				var link = links[i];
				var hashInd = link.href.indexOf("#");
				if (hashInd === -1) { continue; }
				var item = gebi(link.href.substring(hashInd+1));
				if (!item) { continue; }
				link.item = item;
			}
		}
		//unexpect situation, bail now
		if (!this.item) { return false; }
		if (hcn(this.parentNode, "current")) { return false; }
		var pkg = getParent(this, ".lppkg");
		for (var i=0; i<links.length; i++) {
			//take away "current" status on all
			var link = links[i];
			if (!pkg.contains(link)) { continue; }
			rcn(link.parentNode, "current");
			rcn(link.item, "current");
		}
		//add "current" status to this link and item set
		acn(this.parentNode, "current");
		acn(this.item, "current");

		// renumber all visible items
		num();

		// prevent default action
		return false;
	});

	//#############################################################

	// number a single item
	function setText(el, txt) {
		for (var i=0; i<el.childNodes.length; i++) {
			if (el.childNodes[i].nodeType == 1) {
				setText(el.childNodes[i], txt);
				return;
			}
		}
		el.innerHTML = txt;
	}
	// item numbering subroutine
	var allINums;
	reg.preSetup(function(){
		// figure out which items are numbered "1"
		if (!gebi("lp")) { return; }
		allINums = gebcn("lpitemid");
		for (var i=0; i<allINums.length; i++) {
			var thisIsFirst = true;
			var lpitem = getParent(allINums[i], ".lpitem");
			if (gebs(".lpfollow", lpitem).length > 0) {
				thisIsFirst = false;
			} else {
				var pkg = getParent(allINums[i], ".lppkg");
				if (pkg && gebs(".lppkg > .lpfollow", pkg).length > 0) {
					thisIsFirst = false;
				}
			}
			if (thisIsFirst) {
				setText(allINums[i], 1);
			}
		}
		// number the visible items
		num();
	});
	function num(el) {
		var n = 2;
		for (var i=0; i<allINums.length; i++) {
			var iNum = allINums[i];
			var num = parseInt(elemText(iNum));
			var par = getParent(iNum, ".lppkgitems");
			if (num === 1) { n = 2; }
			else {
				if (!par || hcn(par, "current")) {
					setText(iNum, n++);
				}
			}
		}
	}
})();



// PC9 CAROUSEL SETUP
reg.postSetup(function(){

	// if true, setup the dumb, non-animating version
	var dumb = is.ie6 || (is.gecko && !is.geckoAtOrAbove('1.8'));

	var pc9v1 = gebi("pc9v1");
	if (!pc9v1) { return; }
	var count = 0;//for unique ids

	gebcn("pc9carousel",pc9v1).forEach(function(csl){

		//set some vars
		var head = gebcn('pc9carousel-numbering',csl.parentNode);
		head = head.length > 0 ? head[0] : null;
		var panes = gebs('div.pc9carousel > div.pane',csl);
		if (panes.length < 2) { return; }
		dumb || acn(csl,'pc9carousel-animating');

		//add ids to each pane
		panes.forEach(function(pane, i){
			if (!pane.id) { pane.id = 'pc9carousel_pane_'+(count++); }
			var nextI = i+1;
			var prevI = i-1;
			if (prevI < 0) { prevI += panes.length; }
			if (nextI >= panes.length) { nextI -= panes.length; }
			pane.prev = panes[prevI];
			pane.next = panes[nextI];
			if (i>0) { acn(pane,'hidethis'); }
		});
		//add arrow links to interlink panes
		panes.forEach(function(pane){
			gebs('p.thumb > img',pane).forEach(function(img){
				var pdot = elem('img',{'src':imdir+'/a.gif','alt':'previous'});
				var ndot = pdot.cloneNode(false);
				ndot.alt = 'next';
				var prev = elem('a.pc9prev',{'href':'#'+pane.prev.id},pdot);
				var next = elem('a.pc9next',{'href':'#'+pane.next.id},ndot);
				img.parentNode.insertBefore(prev, img);
				insertAfter(next, img);
			});
		});
		//set the 1/n message
		if (head){
			var numHolder = elem('span.number',null,'1');
			var marker = elem('span.marker',null,[' ',numHolder,'/'+panes.length+' ']);
			panes.forEach(function(pane,i){
				pane.numHolder = numHolder;
				pane.num = i+1;
			});
			head.insertBefore(marker, head.firstChild);
		}
	});

	// animation by percentages
	function setPhase(pane, phase) {
		pane.style.left = (phase * 10) + "%";
		pane.style.right = (phase * -10) + "%";
	}

	var interval = 20;//animation interval in ms

	// handle events on carousel arrow links
	reg.click("a.pc9prev,a.pc9next",function(){
		var pane = getParent(this, ".pane");
		var otherId = this.href.substring(this.href.indexOf("#")+1);
		var otherPane = gebi(otherId);

		if (dumb) {
			//don't animate
			acn(pane,'hidethis');
			rcn(otherPane,'hidethis');
		} else {
			//animate
			var neg = hcn(this,'pc9prev') ? 1 : -1;
			setPhase(pane,1*neg);
			setPhase(otherPane,-9*neg);
			rcn(otherPane,'hidethis');
			for (var i=2,phase=2,mult=1; i<10; i++) {
				window.setTimeout(function(){
					setPhase(pane,neg*phase);
					setPhase(otherPane,-neg*(10-(phase++)));
				},(mult++)*interval);
			}
			window.setTimeout(function(){
				acn(pane,'hidethis');
				setPhase(pane,0);
				setPhase(otherPane,0);
			},9*interval);
		}

		if (otherPane.numHolder) {
			otherPane.numHolder.firstChild.data = otherPane.num+'';
		}
		return false;
	});
});



// ########################### LEGACY / DEPRECATED ###########################

// in case this is still called from somewhere
function domCrawl(domObject,tagList){reg.rerun(domObject);}

// this needs to go away
function catchBodyClicks() {
	if (document.body) {
		addEvent(document.body,'click',function(e){
			if (!e) var e = window.event;
			if (e.target) { var targ = e.target; }
			else if (e.srcElement) { var targ = e.srcElement; }
			if (targ.nodeType == 3) { targ = targ.parentNode; } // we don't need no stinkin' text nodes
			var sel;
			if (typeof bodyClickHandlers != 'undefined') {
				selectors:for (sel in bodyClickHandlers) {
					var el = targ;
					var tries = 0;
					while (el.nodeType == 1) {
						try { if (matches(el, sel)) { bodyClickHandlers[sel](el, e); break; } }
						catch (e) { continue selectors; }
						if (!el.parentNode || tries > 20) { break; }
						el = el.parentNode;
						tries++;
					}
				}
			}
		});
	}else{
		window.setTimeout('catchBodyClicks()',100);
	}
}
catchBodyClicks();
window.bodyClickHandlers = {};

// TODO: DELETE THIS
function sniffLinkHijax(fobj){
	if (fobj.nodeName.toLowerCase() == 'a'){
		var links = new Array(fobj);
	}else if(gebtn('a',fobj)[0]){
		var links = gebtn('a',fobj);
	}
	for (i=0; i<links.length; i++){
		links[i].targetDiv = fobj.className.split('hijax-')[1];
		addEvent(links[i],"click",function(e){
			var targetDiv = this.targetDiv;
			var hstring = this.href+' ';
			if (!hijaxCache[hstring]){
				getfile(this.href, function(rdata,fvar){
					if(rdata.indexOf('id="'+targetDiv+'"') > -1){
						rdata = getRequestObject(targetDiv,rdata).innerHTML;
						hijaxCache[hstring] = rdata;
						gebi(targetDiv).innerHTML = rdata;
						reg.rerun(gebi(targetDiv));
					}
				});
				cancelDefault(e);
			}else{
				gebi(targetDiv).innerHTML = hijaxCache[hstring];
				reg.rerun(gebi(targetDiv));
				cancelDefault(e);
			}
		});
	}
};

// this needs to go away
function addOnresizeEvent(func){addEvent(window, 'resize', func);}






// ################################ OBJECT HELPERS ###########################

// " foo  " -> "foo"
if(!String.prototype.strip){
	String.prototype.strip=function(){return this.replace(/^\s+|\s+$/g, "");};
}

// " foo   bar  " -> "foo bar"
if(!String.prototype.normalize){
	String.prototype.normalize=function(sp){
		sp=(!sp && sp!=='')?' ':sp;
		return this.strip().replace(/\s+/g,sp);
	};
}

// ###########################################################################
// END REG LIB, BEGIN XMLHTTPREQUEST FUNCTIONS
// ###########################################################################

// GENERIC HTTP REQUEST
function getfile(filepath,ftodo,fvar,ferr,forceText){
	var http_request = false;
	if (window.XMLHttpRequest) {
		http_request = new XMLHttpRequest();
		if (http_request.overrideMimeType && filepath.indexOf('.xml') > -1){
			http_request.overrideMimeType('text/xml');
		}
	}else if (window.ActiveXObject) { // IE
		try { http_request = new ActiveXObject("Msxml2.XMLHTTP");
		}catch(ex1){
			try{
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			}catch(ex2){}
		}
	}
	if (!http_request) {
		return false;
	}
	http_request.onreadystatechange = function() {
		if (http_request.readyState == 4) {
			if (http_request.status == 200) {
				if (filepath.indexOf('.xml') > -1 && !forceText){
					var rdata = http_request.responseXML.documentElement;
				}else{
					var rdata = http_request.responseText;
				}
				ftodo(rdata,fvar); // SUCCESS
			}else{
				if (ferr) { ferr(fvar,filepath,http_request.status,http_request.statusText); } // FAIL
			}
		}
	};
	http_request.open('GET', filepath, true);
	http_request.send(null);
}

// RETURN OBJECT FROM STRING
function getRequestObject(elementID,rdata,elementTag) {
	if (!elementTag){ elementTag = 'div'; } // elementTag optional, defaults to DIV
	var sudocont = document.createElement(elementTag);
	sudocont.innerHTML = rdata;
	var x = gebtn(elementTag,sudocont);
	var chunk;
	for (var i=0;i<x.length;i++) {
		if (x[i].id == elementID) {
			chunk = x[i];
			break;
		}
	}
	return chunk;
}

// BUILD AN ELEMENT FROM TEXT PULLED FROM XHR
function getElementByIdFromString(textBlob, id) {
	var container = document.createElement('div');
	container.innerHTML = textBlob;
	var tags = gebtn("*",container);
	for (var a=0,tag;tag=tags[a++];){
		if (tag.id == id) { return tag; }
	}
	return null;
}

// GENERIC XML HTTP REQUEST
function xhr(url, successFunc, failFunc, obj, postData){
	/*
	successFunc(responseText, obj)
	failFunc(statusCode, statusText, url, obj)
	*/
	//check whether this is same-domain
	var parts=resolveUrl(url).split(/\/+/g);
	if(parts[0]!==location.protocol||parts[1]!==location.host){
		throw new Error("cross-domain requests not allowed");
	}
	var http_request = false;
	if (window.XMLHttpRequest) {
		http_request = new XMLHttpRequest();
	}else if (window.ActiveXObject) { // IE
		try { http_request = new ActiveXObject("Msxml2.XMLHTTP"); }
		catch(e){
			try{ http_request = new ActiveXObject("Msxml3.XMLHTTP"); }
			catch(ex1){
				try{ http_request = new ActiveXObject("Microsoft.XMLHTTP"); }
				catch(ex2){}
			}
		}
	}
	if (!http_request) { return false; }
	if (!postData) { postData = null; }
	var method = (postData) ? "POST" : "GET";
	http_request.open(method, url, true);
	if (postData) {
		http_request.setRequestHeader('Content-type','application/x-www-form-urlencoded');
		http_request.setRequestHeader("Content-length", postData.length);
		http_request.setRequestHeader("Connection", "close");
	}
	http_request.onreadystatechange = function() {
		if (http_request.readyState == 4) {
			if (http_request.status == 200) {
				successFunc(http_request.responseText, obj);
			}else{
				try { failFunc(http_request.status, http_request.statusText, url, obj); }
				catch (ex) { failFunc('', ex, url, obj); }
			}
		}
	};
	http_request.send(postData);
}

// GET DATA FROM A FORM FOR XHR
function getFormData(thisform) {
	var fargs = [];
	var inps = reg.getElementsBySelector("input, select, textarea",thisform);
	for (var a=0; a<inps.length; a++){
		var inp = inps[a];
		if (matches(inp,'@type="text",@type="hidden",@type="password"')){
			fargs.push(encodeURIComponent(inp.name) + "=" + encodeURIComponent(inp.value));
		}
		if (inp.type == "checkbox"  && inp.checked || inp.type == "radio" && inp.checked){
			fargs.push(encodeURIComponent(inp.name) + "=" + encodeURIComponent(inp.value));
		}
		if (inp.nodeName.toLowerCase()=='select'){
			var selVal = inp.options[inp.selectedIndex].value;
			fargs.push(encodeURIComponent(inp.name) + "=" + encodeURIComponent(selVal));
		}
		if (inp.nodeName.toLowerCase()=='textarea'){
			fargs.push(encodeURIComponent(inp.name) + "=" + encodeURIComponent(inp.value));
		}
	}
	return fargs.join('&');
}

// ###########################################################################
// END XMLHTTPREQUEST FUNCTIONS, BEGIN SUN FUNCTIONS
// ###########################################################################

// HAS PARENT
function hasParent(obj,tag,classname){
	var parent = obj;
	if(classname){
		while (parent = parent.parentNode) {
			if (parent.nodeName.toLowerCase() == tag && hasClassName(parent,classname) || tag == "*" && hasClassName(parent,classname)){
				return parent;
			}
		}
	}else if (typeof tag == 'string') {
		while (parent = parent.parentNode) {
			if (parent.id == tag){
				return parent;
			}
		}
	}else{
		while (parent = parent.parentNode) {
			if (parent == tag){
				return parent;
			}
		}
	}
}

// GET XY OF OBJ
function getXY(obj){
 	var o = obj;
 	obj.X = obj.Y = 0;
 	while(o){
		if (obj.relativePos){
			if (getStyle(o, 'position') != 'relative' && getStyle(o, 'position') != 'absolute'){
				obj.X = obj.X + o.offsetLeft;
				obj.Y = obj.Y + o.offsetTop;
			}
		}else{
			obj.X = obj.X + o.offsetLeft;
			obj.Y = obj.Y + o.offsetTop;
		}
 		o = o.offsetParent;
 	}
}

// RETURNS THE SPECIFIED COMPUTED STYLE ON AN OBJECT
function getStyle(obj, styleProp){
	if (obj.currentStyle){
		return obj.currentStyle[styleProp];
	}else if (window.getComputedStyle){
		return document.defaultView.getComputedStyle(obj,null).getPropertyValue(styleProp);
	}
}

// GET FULL CLASS NAME FROM PARTIAL STRING
function getClassContains(obj,subst){
	var rcl = false;
	var cls = obj.className.split(' ');
	for (var v=0;v<cls.length;v++){
		if (cls[v].indexOf(subst) > -1){
			rcl = cls[v];
		}
	}
	return rcl;
}

// GET CHILD NODES VIA TAG NAME
function getChildNodesByTagName(el, tagName){
	var cn = el.childNodes;
	var nd = [];
	for (var n=0;n<cn.length;n++){
		if(tagName == cn[n].nodeName.toLowerCase()){
			nd.push(cn[n]);
		}
	}
	return nd;
}

// SET OPACITY
function setopacity(id_or_obj,opac){
	if (gebi(id_or_obj)){
		var oobj = gebi(id_or_obj);
	}else if(id_or_obj){
		var oobj = id_or_obj;
	}
	if (oobj){
		if (oobj.filters && oobj.filters.alpha){
			oobj.filters.alpha.opacity = opac * 100;
		}else{
			oobj.style.MozOpacity = opac;
			oobj.style.opacity = opac;
		}
	}
}

// FADEIN
function sfadein(obj,n){
	if(!obj.sfade){ obj.sfade = 0; }
	if(obj.sfade< 1){
		if(is.safariAll){
			obj.sfade = obj.sfade + (n * 5);
		}else{
			obj.sfade = obj.sfade + n;
		}
		setopacity(obj,obj.sfade);
 		setTimeout(function(){sfadein(obj,obj.sfade);},75);
	}else{
		setopacity(obj,1);
		obj.sfade = null;
	}
}


// takes an integer, returns a new month
// if someDate = jan 11 2004 11:04:27 am
// then someDate.diffDay(-9) = jan 2 2004 11:04:27 am
Date.prototype.diffDay = function(days){
	var r = new Date(this.getTime());
	r.setDate(r.getDate()+days);
	return r;
}

// takes an integer, returns a new month
// if someDate = jan 11 2004 11:04:27 am
// then someDate.diffMonth(3) = apr 11 2004 11:04:27 am
Date.prototype.diffMonth = function(months){
	var r=new Date(this.getTime());
	var num = r.getMonth()+months;
	var yearInc = 0;
	// because safari messes up on date.setMonth(-1)
	if (num < 0) { while(num < 0) { num += 12; yearInc--; } }
	else if (num > 11) { while(num > 11) { num -= 12; yearInc++; } }
	r.setMonth(num);
	r.setFullYear(r.getFullYear() + yearInc)
	return r;
}

// pad a string on the left up to a given amount
// foo = "3"
// foo = foo.padLeft("0", 3)
// foo now is "003"
String.prototype.padLeft = function(ch,amount){
	var r=this;
	while(r.length<amount){r=ch+r;}
	return r;
}

/*
takes a format mask and returns a string representation of this date.
enclose escape sequences in single quotes.
new Date().format("DD/MM/YYYY")   // evaluates to "25/11/2008"
new Date().format("'DD'/MM/YYYY") // evaluates to "DD/11/2008"
format flags:
	D		1-31 (day of month)
	DD		01-31 (day of month)
	Dth		1st, 2nd, 3rd... (day of month)
	M		1-12 (month of year)
	MM		01-12 (month of year)
	mon		jan-dec
	month	january-december
	Mon		Jan-Dec
	Month	January-December
	MON		JAN-DEC
	MONTH	JANUARY-DECEMBER
	w		s, m, t, w, t, f, s (weekday)
	we		su-sa (weekday)
	wee		sun-sat (weekday)
	weekday	sunday-saturday
	W		S, M, T, W, T, F, S (weekday)
	We		Su-Sa (weekday)
	Wee		Sun-Sat (weekday)
	Weekday	Sunday-Saturday
	WE		SU-SA (weekday)
	WEE		SUN-SAT (weekday)
	WEEKDAY	SUNDAY-SATURDAY
	YY		2-digit year
	YYYY		4-digit year
	ss		00-59 (seconds)
	mm		00-59 (minutes)
	h		1-12 (hours)
	hh		01-12 (hours)
	H		0-23 (hours)
	HH		00-23 (hours)
	a		am, pm
	A		AM, PM
	X		timezone offset
*/
Date.prototype.format = (function(){
	var pattern =       /(WEEKDAY)|(Weekday)|(weekday)|(WEE)|(Wee)|(wee)|(WE)|(We)|(we)|(W)|(w)|(MONTH)|(Month)|(month)|(MON)|(Mon)|(mon)|(MM)|(M)|(DD)|(Dth)|(D)|(YYYY)|(YY)|(HH)|(hh)|(H)|(h)|(mm)|(ss)|(A)|(a)|(X)/g;
	var dobj;
	function parser(str,  WEEKDAY,  Weekday,  weekday,  WEE,  Wee,  wee,  WE,  We,  we,  W,  w,  MONTH,  Month,  month,  MON,  Mon,  mon,  MM,  M,  DD,  Dth,  D,  YYYY,  YY,  HH,  hh,  H,  h,  mm,  ss,  A,  a,  X){
		var result;
		if (ss)      { return (''+dobj.getSeconds()).padLeft('0',2); }
		if (mm)      { return (''+dobj.getMinutes()).padLeft('0',2); }
		if (H)       { return dobj.getHours()+''; }
		if (HH)      { return (dobj.getHours()+'').padLeft('0',2); }
		if (h)       {
			result=(dobj.getHours()%12)+'';
			if(result=='0'){result='12';}
			return result;
		}
		if (hh)      {
			result=(dobj.getHours()%12)+'';
			if(result=='0'){result='12';}
			result=result.padLeft('0',2);
			return result;
		}
		if (Weekday) { return dayNamesFull[dobj.getDay()]; }
		if (W)       { return dayNames1[dobj.getDay()]; }
		if (We)      { return dayNames2[dobj.getDay()]; }
		if (Wee)     { return dayNames3[dobj.getDay()]; }
		if (WEEKDAY) { return dayNamesFull[dobj.getDay()].toUpperCase(); }
		if (WE)      { return dayNames2[dobj.getDay()].toUpperCase(); }
		if (WEE)     { return dayNames3[dobj.getDay()].toUpperCase(); }
		if (weekday) { return dayNamesFull[dobj.getDay()].toLowerCase(); }
		if (w)       { return dayNames1[dobj.getDay()].toLowerCase(); }
		if (we)      { return dayNames2[dobj.getDay()].toLowerCase(); }
		if (wee)     { return dayNames3[dobj.getDay()].toLowerCase(); }
		if (D)       { return dobj.getDate()+''; }
		if (DD)      { return (dobj.getDate()+'').padLeft('0',2); }
		if (Dth)     {
			result=dobj.getDate()+'';
			if(result.match(/^1\d$/)){result+='th';}
			else if(result.match(/1$/)){result+='st';}
			else if(result.match(/2$/)){result+='nd';}
			else if(result.match(/3$/)){result+='rd';}
			else{result+='th';}
			return result;
		}
		if (YYYY)    { return dobj.getFullYear()+''; }
		if (YY)      { return (dobj.getFullYear()+'').substring(2,4); }
		if (M)       { return (dobj.getMonth()+1)+''; }
		if (MM)      { return ((dobj.getMonth()+1)+'').padLeft('0',2); }
		if (Month)   { return monthNamesFull[dobj.getMonth()]; }
		if (Mon)     { return monthNames3[dobj.getMonth()]; }
		if (MONTH)   { return monthNamesFull[dobj.getMonth()].toUpperCase(); }
		if (MON)     { return monthNames3[dobj.getMonth()].toUpperCase(); }
		if (month)   { return monthNamesFull[dobj.getMonth()].toLowerCase(); }
		if (mon)     { return monthNames3[dobj.getMonth()].toLowerCase(); }
		if (X)       { return (dobj.getTimezoneOffset()/60)+''; }
		if (A)       { return (dobj.getHours()<12)?'AM':'PM'; }
		if (a)       { return (dobj.getHours()<12)?'am':'pm'; }
	}
	return function(fmt) {
		dobj = this;
		var parts = fmt.split("'");
		if (parts.length % 2 == 0) { throw "missing closing single quote in date format \""+fmt+"\"";}
		for (var i=0;i<parts.length;i+=2){
			parts[i]=parts[i].replace(pattern, parser);
		}
		return parts.join('');
	};
})();

// for displaying and manipulating a calendar
// encapsulates a 2d array
// only cares about days, not times
function Calendar(date, startDate, endDate, origDate) {
	this.origDate = (origDate) ? origDate : date.diffDay(0);
	this.startDate = startDate;
	this.endDate = endDate;
	date.setDate(1);
	this.canonicalMonth = date.diffDay(0);

	// init the date 2d array
	this.g = [];
	this.g[0] = [];

	// populate the pre days
	var numPreDays = date.getDay();
	var row = this.g[0];
	for (var a=0;a<numPreDays;a++){
		row[a] = date.diffDay(a-numPreDays);
		row[a].dayClass = 'jscal-before';
		if (startDate && row[a].getTime() < startDate) { row[a].dayClass += ' jscal-outofrange'; }
		else if (endDate && row[a].getTime() > endDate) { row[a].dayClass += ' jscal-outofrange'; }
		else { row[a].dayClass += ' jscal-inrange'; }
	}

	// populate the days
	var todayDateStr = new Date().format("DD/MM/YYYY");
	var curDateStr = this.origDate.format("DD/MM/YYYY");
	while (date.getMonth() == this.canonicalMonth.getMonth()) {
		var curDate = this.g[this.g.length-1][date.getDay()];
		this.g[this.g.length-1][date.getDay()] = date;
		this.g[this.g.length-1][date.getDay()].dayClass = 'jscal-during';
		var dateStr = date.format("DD/MM/YYYY");
		if (dateStr == todayDateStr) {date.dayClass += ' jscal-today';}
		if (dateStr == curDateStr) {date.dayClass += ' jscal-current';}
		if (startDate && date.getTime() < startDate) { date.dayClass += ' jscal-outofrange'; }
		else if (endDate && date.getTime() > endDate) { date.dayClass += ' jscal-outofrange'; }
		else { date.dayClass += ' jscal-inrange'; }
		date = date.diffDay(1);
		if (date.getDay() == 0 && date.getMonth() == this.canonicalMonth.getMonth()) { this.g[this.g.length] = []; }
	}

	// populate the post days
	var row = this.g[this.g.length-1];
	var numPostDays = row.length;
	for (var a=row.length;a<7;a++){
		row[a] = date.diffDay(a-numPostDays);
		row[a].dayClass = 'jscal-after';
		if (startDate && row[a].getTime() < startDate) { row[a].dayClass += ' jscal-outofrange'; }
		else if (endDate && row[a].getTime() > endDate) { row[a].dayClass += ' jscal-outofrange'; }
		else { row[a].dayClass += ' jscal-inrange'; }
	}
}

// how many weeks (i.e. rows) actually exist in this calendar grid?
Calendar.prototype.weeks = function(){
	return this.g.length;
}

// return a date object by coordinates
// getDayAt(0,0) will probably return a day from the month previous
// getDayAt(0,7) is an index out of bounds error since weekday indices are 0-6
Calendar.prototype.getDayAt = function(weekOfMonth,dayOfWeek){
	return this.g[weekOfMonth][dayOfWeek];
}

// return a clone of this calendar but representing a different month
Calendar.prototype.diffMonth = function(months){
	return new Calendar(this.canonicalMonth.diffMonth(months), this.startDate, this.endDate, this.origDate);
}

// return a DOM tree showing a calendar
Calendar.prototype.getCalendarTable=function() {
	var t = elem('table.jscal',{'cellSpacing':'0'});
	var div = elem('div.jscal-x1',{},elem('div.jscal-x2',{},t));

	t.createTHead().insertRow(0);
	t.tHead.rows[0].className = "jscal-mname";
	t.tHead.rows[0].appendChild(elem('th')).colSpan = '7';
	t.tHead.insertRow(1).className = "jscal-dname";
	t.tHead.rows[1].appendChild(elem('th')).appendChild(document.createTextNode(dayNames1[0]));
	t.tHead.rows[1].appendChild(elem('th')).appendChild(document.createTextNode(dayNames1[1]));
	t.tHead.rows[1].appendChild(elem('th')).appendChild(document.createTextNode(dayNames1[2]));
	t.tHead.rows[1].appendChild(elem('th')).appendChild(document.createTextNode(dayNames1[3]));
	t.tHead.rows[1].appendChild(elem('th')).appendChild(document.createTextNode(dayNames1[4]));
	t.tHead.rows[1].appendChild(elem('th')).appendChild(document.createTextNode(dayNames1[5]));
	t.tHead.rows[1].appendChild(elem('th')).appendChild(document.createTextNode(dayNames1[6]));

	t.appendChild(elem('tbody'));
	var m = t.tHead.rows[0].cells[0];
	var closer = elem('span.jscal-closer',{'href':'#','border':'0'},elem('img',{'alt':'[x]','src':imdir+'/ic_close_win_light.gif','title':'close'}));
	var pMonth = elem('a.jscal-mselect',{'title':'previous month'},'\u00AB ');
	var monthYear = elem('span.jscal-monthyear',{},this.canonicalMonth.format('Mon')+' '+this.canonicalMonth.format('YYYY'))
	var nMonth = elem('a.jscal-mselect',{'title':'next month'},' \u00BB');
	pMonth.calendar = nMonth.calendar = div.calendar = this;
	closer.div = pMonth.div = nMonth.div = div;
	m.appendChild(closer);
	m.appendChild(pMonth);
	m.appendChild(monthYear);
	m.appendChild(nMonth);
	addEvent(pMonth,'click',function(e){
		getParent(this,'div.jscal-x1').setCalendar(this.calendar.diffMonth(-1));
		cancelDefault(e);
	});
	addEvent(nMonth,'click',function(e){
		getParent(this,'div.jscal-x1').setCalendar(this.calendar.diffMonth(1));
		cancelDefault(e);
	});
	addEvent(closer,'click',function(e){
		var parentDiv = getParent(this,'div.jscal-x1');
		parentDiv.parentNode.removeChild(parentDiv);
		cancelDefault(e);
	});

	for (var a=0;a<this.weeks();a++){
		t.tBodies[0].insertRow(a);
		for (var b=0;b<7;b++){
			t.tBodies[0].rows[a].insertCell(b);
			var dt = this.getDayAt(a,b);
			if(!dt){throw "empty month date at "+a+","+b;}
			t.tBodies[0].rows[a].cells[b].className = dt.dayClass;
			var lnk = elem('span',{},''+dt.getDate());
			lnk.date = dt;
			t.tBodies[0].rows[a].cells[b].appendChild(lnk);
		}
	}

	div.setCalendar = function(cal) {
		var newDiv = cal.getCalendarTable();
		this.appendChild(newDiv.firstChild);
		this.removeChild(this.firstChild);
	}
	return div;
};


// GET SAFELY ENCODED STRINGS
function getSafelyEncodedString(s) {
	s = encodeURIComponent(s);
	s = s.replace(/&/,"&amp;").replace(/"/,"&quot;").replace(/</,"&lt;").replace(/>/,"&gt;");
	return s;
}

// GETS AMOUNT SCROLLED FROM TOP
function getScrollTop(){
	if(window.pageYOffset !== undefined){
		return window.pageYOffset;
	} else {
		var db = document.body; //IE 'quirks'
		var dd = document.documentElement; //IE with doctype
		var d = (dd.clientHeight)? dd: db;
		return d.scrollTop;
	}
}


function getWebDesignFolderLocation() {
    var url = document.location.href;   
    var i = url.indexOf("/javase/");
    i = i + 8;
    url = url.substring(0, i);
    url = url + "webdesign/pubs/";
    return url;
}
