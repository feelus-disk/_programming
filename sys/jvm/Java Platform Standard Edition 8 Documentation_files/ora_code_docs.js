/*
######################################################
# ORA_CODE_DOCS.JS
# VERSION: 1.06
# ORIGINAL BUILD DATE: 2 SEPTEMBER 2015
# COPYRIGHT ORACLE CORP 2015 [UNLESS STATED OTHERWISE]
######################################################
*/
/* Report suite set up */
function s_setAccount(){var sa=["oracledevall","docs","en-us"];sa[0]=(s_checkdev())?"oracledevdocs,oracledevall":"oracledocs,oracleglobal";return sa;}
/* Pre/Post Plugins plus site functions */
function s_prePlugins(s){s_oraVer(":docs",":1.06");s.linkInternalFilters="javascript:,.oracle.,sellingpoint,documentation.custhelp.com,rightnow.com";}
/* PrePlugins plus site functions */
function s_postPlugins(s){if(s.pageName=="docs:en-us:/apps/search/search.jsp"){var pageName_addition="Results";var refURL=document.referrer.replace(/\?.+$/,"");var keyword=s.getQueryParam("q");if(keyword){keyword=unescape(keyword).toLowerCase().replace(/\++/g," ");if(refURL!=""){s.prop3=refURL+": "+keyword;}s.prop4=keyword;}if(document.body.innerHTML.indexOf("No results found")!=-1){pageName_addition="No Results";if(keyword){s.prop5=keyword;}}if(document.body.innerHTML.indexOf("No data to display")!=-1){pageName_addition="No data to display";if(keyword){s.prop7=keyword;}}s.pageName="Search:doc.oracle.com:"+pageName_addition;}}function s_checkdev(){var isDev=false;var devSites=new Array();devSites=["-stage","us.oracle.com","-dev","-content","localhost","127.0.0.1","docs-uat"];var al=devSites.length;for(i=0;i<al;i++){if(location.host.indexOf(devSites[i])!=-1){isDev=true;i=al+1;}}return(isDev);}function s_oraVer(_s,_v){_v=_s+_v;oraVersion=(oraVersion.indexOf(_s)==-1)?oraVersion+_v:oraVersion.substr(0,oraVersion.indexOf(_s))+_v;}function gotjQ(){try{var jq=(jQuery)?true:false;}catch(err){var jq=false;}return jq;}function hiddenDlink(){var dLink=this;if(dLink){s.prop8="D=pageName";var dLinkTxt=dLink.toString();dLinkTxt=dLinkTxt.replace(/&amp;/g,"&");if(dLink.name!==""){dLinkTxt=dLink.name;}if(dLinkTxt.indexOf("img")>-1){if(dLinkTxt.indexOf("name")>-1){dLinkTxt=dLinkTxt.substring(dLinkTxt.indexOf('name="')+6,dLinkTxt.length);dLinkTxt=dLinkTxt.substring(0,dLinkTxt.indexOf('"'));}else{if(dLinkTxt.indexOf("alt")>-1){dLinkTxt=dLinkTxt.substring(dLinkTxt.indexOf('alt="')+5,dLinkTxt.length);dLinkTxt=dLinkTxt.substring(0,dLinkTxt.indexOf('"'));}else{dLinkTxt=dLink.href;}}}else{dLinkTxt=dLinkTxt.replace(/.*?:\/\//g,"");}s.eVar29=s.prop23=dLinkTxt;s.eVar15=dLink.href.substring(dLink.href.lastIndexOf("/")+1,dLink.href.length);s.eVar16=dLink.href;s.events=s.apl(s.events,"event15",",",1);s.linkTrackVars="prop8,prop23,eVar29,eVar15,eVar16,events";s.linkTrackEvents="event15";s.tl(dLink,"d",dLink);}}
/* JQUERY FUNCTIONS */
if(gotjQ()){jQuery(document).ready(function($){$('a[href$=".pdf"]').click(hiddenDlink);$('a[href$=".mobi"]').click(hiddenDlink);$('a[href$=".epub"]').click(hiddenDlink);});}