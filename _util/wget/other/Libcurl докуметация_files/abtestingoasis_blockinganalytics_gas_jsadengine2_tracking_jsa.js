(function(window){var AbTest,Wikia=window.Wikia=(window.Wikia||{}),config=Wikia.AbTestConfig||{},logCache={},serverTimeString=window.varnishTime,serverTime=new Date(serverTimeString).getTime()/1000;var log=(function(console){return(console&&console.log)?function(methodName,message){if(!message){message=methodName;methodName=undefined;}
if(!logCache[message]){logCache[message]=true;console.log('Wikia.AbTest'+(methodName?'.'+methodName+'()':'')+':',message);}}:function(){};})(window.console);AbTest=function(expName){this.expName=expName;};AbTest.uuid=(function(uuid){var ret=uuid&&uuid!='ThisIsFake'?uuid:null;if(!ret){log('init','UUID is not available, A/B testing will be disabled');}
return ret;})(window.beacon_id);AbTest.getGroup=function(expName){var exp=getExperiment(expName,'getGroup'),group=exp&&exp.group;return group&&group.name;};AbTest.inGroup=function(expName,groupName){return AbTest.getGroup(expName)===groupName;};AbTest.isValidGroup=function(expName,groupName){var exp=getExperiment(expName,'isValidGroup'),current=exp&&exp.current;return!!(current&&current.groups[groupName]);};AbTest.getGASlot=function(expName){var exp=getExperiment(expName,'getGASlot'),current=exp&&exp.current;return current&&current.gaSlot;};AbTest.getExperiments=function(includeAll){var expName,exp,group,el,list=[];if(!AbTest.uuid){list.nouuid=true;}
for(expName in AbTest.experiments){exp=AbTest.experiments[expName];group=exp.group;if(!group&&!includeAll){continue;}
el={id:exp.id,name:exp.name,flags:exp.flags};if(group){el.group={id:group.id,name:group.name}}
list.push(el);}
return list;};AbTest.loadExternalData=function(data){var index,groupData,html='';log('init','Received external configuration');for(index in data){groupData=data[index];if(groupData.styles){html+='<style>'+groupData.styles+'</style>';}
if(groupData.scripts){html+='<script>'+groupData.scripts+'</script>';}}
if(html!=''){document.write(html);}};(function(prototype){var i,length,methodNames=['inGroup','getGroup','getGASlot','getUserSlot'];for(i=0,length=methodNames.length;i<length;i++){(function(methodName){prototype[methodName]=function(){return AbTest[methodName].apply(AbTest,[this.expName].concat(arguments));};})(methodNames[i]);}})(AbTest.prototype);function getExperiment(expName,methodName){if(!expName){log(methodName,'Missing required argument "expName".');}
var exp=AbTest.experiments[expName];if(!exp){log(methodName,'Experiment configuration not found for "'+expName+'."');}
return exp;}
function hash(s){var slot=0,i;for(i=0;i<s.length;i++){slot+=s.charCodeAt(i)*(i+1);}
return Math.abs(slot)%100;}
function getSlot(expName){return AbTest.uuid?hash(AbTest.uuid+expName):-1;}
function setActiveGroup(expName,groupName,force){var exp=getExperiment(expName,'setActiveGroup'),current=exp&&exp.current,group=current&&current.groups[groupName];if(group&&(!exp.group||force)){exp.group=group;return true;}
return false;}
function isInRanges(value,ranges){var i,range;for(i=0;i<ranges.length;i++){range=ranges[i];if(value>=range.min&&value<=range.max){return true;}}
return false;}
AbTest.experiments=(function(experiments){var expName,exp,versions,version,i,activeExperiments={},count=0;for(expName in experiments){exp=experiments[expName];versions=exp.versions;for(i=0;i<versions.length;i++){version=versions[i];if(serverTime>=version.startTime&&serverTime<version.endTime){exp.current=version;exp.flags=version.flags;count++;break;}}
if(exp.current){activeExperiments[expName]=exp;}}
AbTest.experimentCount=count;return activeExperiments;})(config.experiments||{});(function(experiments){var matches,rTreatmentGroups=/AbTest\.([^=]+)=([^?&]+)/gi,queryString=window.location.search,expName,groupName,exp,slot,externalIds=[];if(queryString){while((matches=rTreatmentGroups.exec(queryString))!=null){expName=matches[1];groupName=matches[2];if(!AbTest.isValidGroup(expName,groupName)){log('init','Invalid experiment/group specified in URL: '+expName+'/'+groupName);continue;}
setActiveGroup(expName,groupName);}}
for(expName in experiments){exp=experiments[expName];slot=getSlot(expName);if(exp.group||!exp.current||slot<0){continue;}
if(exp.flags&&exp.flags.limit_to_special_wikis&&!window.wgIsGASpecialWiki){log('init','Skipping experiment '+expName+' - not a special Wiki');continue;}
for(groupName in exp.current.groups){if(isInRanges(slot,exp.current.groups[groupName].ranges)){setActiveGroup(expName,groupName);}}}
for(expName in experiments){exp=experiments[expName];if(exp.current.external&&exp.group){externalIds.push(exp.name+'.'+exp.current.id+'.'+exp.group.id);}}
if(externalIds.length>0){log('init','Loading external configuration');var url=window.wgCdnApiUrl+'/wikia.php?controller=AbTesting&method=externalData&callback=Wikia.AbTest.loadExternalData&ids=';url+=externalIds.join(',');document.write('<scr'+'ipt src="'+encodeURI(url)+'"></script>');}})(AbTest.experiments);(function(experiments){var expName,exp;for(expName in experiments){exp=experiments[expName];if(Wikia.Tracker&&exp.flags&&exp.flags.dw_tracking&&exp.group){Wikia.Tracker.track({eventName:'ab_treatment',experiment:exp.name,experimentId:exp.id,time:serverTimeString,trackingMethod:'internal',treatmentGroup:exp.group.name,treatmentGroupId:exp.group.id});}}})(AbTest.experiments);Wikia.AbTest=AbTest;})(window);;


(function(context){'use strict';function lazyQueue(){function makeQueue(queue,callback){if(typeof callback!=='function'){throw new Error('LazyQueue used with callback not being a function');}else if(queue instanceof Array){queue.start=function(){while(queue.length>0){callback(queue.shift());}
queue.push=function(item){callback(item);};};}else{throw new Error('LazyQueue requires an array as the first parameter');}}
return{makeQueue:makeQueue};}
if(!context.Wikia){context.Wikia={};}
context.Wikia.LazyQueue=lazyQueue();if(context.define&&context.define.amd){context.define('wikia.lazyqueue',lazyQueue);}}(this));;


(function(window,undefined){var possible_domains,i,cookieExists;window._gaq=window._gaq||[];cookieExists=function(cookieName){return document.cookie.indexOf(cookieName)>-1;};window._gaq.push(['_setAccount','UA-32129070-1']);if(!cookieExists('qualaroo_survey_submission')){window._gaq.push(['_setSampleRate','10']);}else{window._gaq.push(['_setSampleRate','100']);}
if(window.wgIsGASpecialWiki){window._gaq.push(['special._setAccount','UA-32132943-1']);window._gaq.push(['special._setSampleRate','100']);}
window._gaq.push(['ve._setAccount','UA-32132943-4']);window._gaq.push(['ve._setSampleRate','100']);function _gaqWikiaPush(){var i,spec,args=Array.prototype.slice.call(arguments);for(i=0;i<args.length;i++){if(typeof args[i]==='function'){window._gaq.push(args[i]);continue;}
window._gaq.push(args[i]);if(args[i][0].indexOf('.')===-1){if(window.wgIsGASpecialWiki){spec=args[i].slice();spec[0]='special.'+spec[0];window._gaq.push(spec);}
if(args[i][1]&&args[i][1]==='editor-ve'){spec=args[i].slice();spec[0]='ve.'+spec[0];window._gaq.push(spec);}}}}
function getKruxSegment(){var kruxSegment='not set',uniqueKruxSegments={ocry7a4xg:'Game Heroes 2014',ocr1te1tc:'Digital DNA 2014',ocr6m2jd6:'Inquisitive Minds 2014',ocr05ve5z:'Culture Caster 2014',ocr88oqh9:'Social Entertainers 2014'},uniqueKruxSegmentsKeys=Object.keys(uniqueKruxSegments),markedSegments=[],kruxSegments=[];if(window.localStorage){kruxSegments=(window.localStorage.kxsegs||'').split(',');}
if(kruxSegments.length){markedSegments=uniqueKruxSegmentsKeys.filter(function(n){return kruxSegments.indexOf(n)!==-1;});if(markedSegments.length){kruxSegment=uniqueKruxSegments[markedSegments[0]];}}
return kruxSegment;}
possible_domains=['wikia.com','ffxiclopedia.org','jedipedia.de','marveldatabase.com','memory-alpha.org','uncyclopedia.org','websitewiki.de','wowwiki.com','yoyowiki.org'];for(i=0;i<possible_domains.length;i++){if(document.location.hostname.indexOf(possible_domains[i])>-1){_gaqWikiaPush(['_setDomainName',possible_domains[i]]);break;}}
_gaqWikiaPush(['_setCustomVar',1,'DBname',window.wgDBname,3],['_setCustomVar',2,'ContentLanguage',window.wgContentLanguage,3],['_setCustomVar',3,'Hub',window.cscoreCat,3],['_setCustomVar',4,'Skin',window.skin,3],['_setCustomVar',5,'LoginStatus',!!window.wgUserName?'user':'anon',3]);_gaqWikiaPush(['_setCustomVar',8,'PageType',window.wikiaPageType,3],['_setCustomVar',9,'CityId',window.wgCityId,3],['_setCustomVar',14,'HasAds',window.wgGaHasAds?'Yes':'No',3],['_setCustomVar',15,'IsCorporatePage',window.wikiaPageIsCorporate?'Yes':'No',3],['_setCustomVar',16,'Krux Segment',getKruxSegment(),3],['_setCustomVar',17,'Vertical',window.wgWikiVertical,3],['_setCustomVar',18,'Categories',window.wgWikiCategories.join(','),3]);if(window.Wikia&&window.Wikia.AbTest){var abList=window.Wikia.AbTest.getExperiments(true),abExp,abGroupName,abSlot,abIndex,abForceTrackOnLoad=false,abCustomVarsForAds=[];for(abIndex=0;abIndex<abList.length;abIndex++){abExp=abList[abIndex];if(!abExp||!abExp.flags){continue;}
if(!abExp.flags.ga_tracking){continue;}
if(abExp.flags.forced_ga_tracking_on_load&&abExp.group){abForceTrackOnLoad=true;}
abSlot=window.Wikia.AbTest.getGASlot(abExp.name);if(abSlot>=40&&abSlot<=49){abGroupName=abExp.group?abExp.group.name:(abList.nouuid?'NOBEACON':'CONTROL');_gaqWikiaPush(['_setCustomVar',abSlot,abExp.name,abGroupName,3]);abCustomVarsForAds.push(['ads._setCustomVar',abSlot,abExp.name,abGroupName,3]);}}
if(abForceTrackOnLoad){var abRenderStart=window.wgNow||(new Date());var abOnLoadHandler=function(){var renderTime=(new Date()).getTime()-abRenderStart.getTime();setTimeout(function(){window.gaTrackEvent('ABtest','ONLOAD','TIME',renderTime);},10);};if(window.attachEvent){window.attachEvent("onload",abOnLoadHandler);}else if(window.addEventListener){window.addEventListener("load",abOnLoadHandler,false);}}}
_gaqWikiaPush(['_trackPageview']);window._gaq.push(['ads._setAccount','UA-32129071-1']);window._gaq.push(['ads._setDomainName',document.location.hostname]);window._gaq.push(['ads._setCustomVar',1,'DBname',window.wgDBname,3],['ads._setCustomVar',2,'ContentLanguage',window.wgContentLanguage,3],['ads._setCustomVar',3,'Hub',window.cscoreCat,3],['ads._setCustomVar',4,'Skin',window.skin,3],['ads._setCustomVar',5,'LoginStatus',!!window.wgUserName?'user':'anon',3]);window._gaq.push(['ads._setCustomVar',8,'PageType',window.wikiaPageType,3],['ads._setCustomVar',9,'CityId',window.wgCityId,3],['ads._setCustomVar',14,'HasAds',window.wgGaHasAds?'Yes':'No',3],['ads._setCustomVar',15,'IsCorporatePage',window.wikiaPageIsCorporate?'Yes':'No',3],['ads._setCustomVar',16,'Krux Segment',getKruxSegment(),3],['ads._setCustomVar',17,'Vertical',window.wgWikiVertical,3],['ads._setCustomVar',18,'Categories',window.wgWikiCategories.join(','),3]);if(window.Wikia&&window.Wikia.AbTest){if(abCustomVarsForAds.length){window._gaq.push.apply(window._gaq,abCustomVarsForAds);}}
window.gaTrackAdEvent=function(category,action,opt_label,opt_value,opt_noninteractive){var args,ad_hit_sample=1;if(Math.random()*100<=ad_hit_sample){args=Array.prototype.slice.call(arguments);args.unshift('ads._trackEvent');try{window._gaq.push(args);}catch(e){}}};window.gaTrackEvent=function(category,action,opt_label,opt_value,opt_noninteractive){var args=Array.prototype.slice.call(arguments);args.unshift('_trackEvent');try{_gaqWikiaPush(args);}catch(e){}};window.gaTrackPageview=function(fakePage,opt_namespace){var nsPrefix=(opt_namespace)?opt_namespace+'.':'';_gaqWikiaPush([nsPrefix+'_trackPageview',fakePage]);};}(window));(function(){if(!window.wgNoExternals){var ga=document.createElement('script');ga.type='text/javascript';ga.async=true;ga.src=('https:'==document.location.protocol?'https://ssl':'http://www')+'.google-analytics.com/ga.js';var s=document.getElementsByTagName('script')[0];s.parentNode.insertBefore(ga,s);}})();;


define('ext.wikia.adEngine.adTracker',['wikia.tracker','wikia.window'],function(tracker,window){'use strict';var timeBuckets=[0.0,0.5,1.0,1.5,2.0,2.5,3.5,5.0,8.0,20.0,60.0];function encodeAsQueryString(extraParams){var out=[],key,keys=[],i,len;for(key in extraParams){if(extraParams.hasOwnProperty(key)){keys.push(key);}}
keys.sort();for(i=0,len=keys.length;i<len;i+=1){key=keys[i];out.push(key+'='+extraParams[key]);}
return out.join(';');}
function getTimeBucket(time){var i,len=timeBuckets.length,bucket;for(i=0;i<len;i+=1){if(time>=timeBuckets[i]){bucket=i;}}
if(bucket===len-1){return timeBuckets[bucket]+'+';}
if(bucket>=0){return timeBuckets[bucket]+'-'+timeBuckets[bucket+1];}
return'invalid';}
function track(eventName,data,value,forcedLabel){var category='ad/'+eventName,action=typeof data==='string'?data:encodeAsQueryString(data||{}),gaLabel=forcedLabel,gaValue;if(!gaLabel){if(value===undefined){gaLabel='';value=0;}else{gaLabel=getTimeBucket(value/1000);if(/\+$|invalid/.test(gaLabel)){category=category.replace('ad','ad/error');}}}
gaValue=Math.round(value);tracker.track({ga_category:category,ga_action:action,ga_label:gaLabel,ga_value:isNaN(gaValue)?0:gaValue,trackingMethod:'ad'});}
function measureTime(eventName,eventData,eventType){var timingValue=window.wgNow&&new Date().getTime()-window.wgNow.getTime();eventType=eventType?'/'+eventType:'';return{measureDiff:function(diffData,diffType){eventType='/'+diffType;eventData=diffData;timingValue=window.wgNow&&new Date().getTime()-window.wgNow.getTime()-timingValue;return{track:this.track};},track:function(){if(timingValue){track('timing/'+eventName+eventType,eventData,timingValue);}}};}
return{track:track,measureTime:measureTime};});;


define('ext.wikia.adEngine.rubiconRtp',['ext.wikia.adEngine.adTracker','wikia.document','wikia.log','wikia.window'],function(adTracker,document,log,win){'use strict';var logGroup='ext.wikia.adEngine.rubiconRtp',timingEventData={},rtpTiming,rubiconCalled=false,rtpResponse,rtpTier,rtpConfig;function trackState(trackEnd){log(['trackState',rtpResponse],'debug',logGroup);var e='(unknown)',eventName,data={},label;data.ozCachedOnly=!!rtpConfig.oz_cached_only;data.response=!!rtpResponse;data.size=(rtpResponse&&rtpResponse.estimate&&rtpResponse.estimate.size)||e;data.pmpEligible=(rtpResponse&&rtpResponse.pmp&&rtpResponse.pmp.eligible)||e;data.tier=rtpTier||e;if(trackEnd){eventName='lookupEnd';}else if(rtpTier){eventName='lookupSuccess';}else{eventName='lookupError';}
if(rtpResponse&&rtpResponse.pmp&&rtpResponse.pmp.deals){label='pmpDeals='+rtpResponse.pmp.deals.join(',');}else{label='noPmpDeals';}
adTracker.track(eventName+'/rubicon',data,0,label);}
function onRubiconResponse(response){rtpTiming.measureDiff(timingEventData,'end').track();log(['onRubiconResponse',response],'debug',logGroup);rtpResponse=response;rtpTier=response&&response.estimate&&response.estimate.tier;trackState(true);}
function call(config){log('call','debug',logGroup);rtpConfig=config;win.oz_async=true;win.oz_cached_only=config.oz_cached_only;win.oz_api=config.oz_api||"valuation";win.oz_ad_server=config.oz_ad_server||"dart";win.oz_site=config.oz_site;win.oz_zone=config.oz_zone;win.oz_ad_slot_size=config.oz_ad_slot_size;rubiconCalled=true;rtpTiming=adTracker.measureTime('rubicon',timingEventData,'start');rtpTiming.track();win.oz_callback=onRubiconResponse;var s=document.createElement('script');s.id=logGroup;s.src='//tap-cdn.rubiconproject.com/partner/scripts/rubicon/dorothy.js?pc='+win.oz_site;s.async=true;document.body.appendChild(s);}
function wasCalled(){log(['wasCalled',rubiconCalled],'debug',logGroup);return rubiconCalled;}
function getTier(){log(['getTier',rtpTier],'debug',logGroup);return rtpTier;}
return{call:call,getConfig:function(){return rtpConfig;},getTier:getTier,trackState:function(){trackState();},wasCalled:wasCalled};});;


define('ext.wikia.adEngine.amazonMatch',['ext.wikia.adEngine.adTracker','wikia.document','wikia.log','wikia.window'],function(adTracker,doc,log,win){'use strict';var logGroup='ext.wikia.adEngine.amazonMatch',amazonId='3115',amazonResponse,amazonTiming,amazonCalled=false,targetingParams=[];function trackState(trackEnd){log(['trackState',amazonResponse],'debug',logGroup);var eventName,m,key,data={};if(amazonResponse){eventName='lookupSuccess';for(key in amazonResponse){if(amazonResponse.hasOwnProperty(key)){targetingParams.push(key);m=key.match(/^a([0-9]x[0-9])(p[0-9]+)$/);if(m){if(!data[m[2]]){data[m[2]]=[];}
data[m[2]].push(m[1]);}}}}else{eventName='lookupError';}
if(trackEnd){eventName='lookupEnd';}
adTracker.track(eventName+'/amazon',data||'(unknown)',0);}
function onAmazonResponse(response){amazonTiming.measureDiff({},'end').track();log(['onAmazonResponse',response],'debug',logGroup);if(response.status==='ok'){amazonResponse=response.ads;}
trackState(true);}
function renderAd(doc,adId){log(['getPageParams',doc,adId,'available: '+!!amazonResponse[adId]],'debug',logGroup);doc.write(amazonResponse[adId]);}
function call(){log('call','debug',logGroup);amazonCalled=true;amazonTiming=adTracker.measureTime('amazon',{},'start');amazonTiming.track();win.amznads={updateAds:onAmazonResponse,renderAd:renderAd};var url=encodeURIComponent(doc.location),s=doc.createElement('script'),cb=Math.round(Math.random()*10000000);try{url=encodeURIComponent(win.top.location.href);}catch(ignore){}
s.id=logGroup;s.async=true;s.src='//aax.amazon-adsystem.com/e/dtb/bid?src='+amazonId+'&u='+url+'&cb='+cb;doc.body.appendChild(s);}
function wasCalled(){log(['wasCalled',amazonCalled],'debug',logGroup);return amazonCalled;}
function getPageParams(){log(['getPageParams',targetingParams],'debug',logGroup);return{amznslots:targetingParams};}
return{call:call,getPageParams:getPageParams,trackState:function(){trackState();},wasCalled:wasCalled};});;define('ext.wikia.adEngine.amazonMatchOld',['ext.wikia.adEngine.adTracker','wikia.document','wikia.log','wikia.window'],function(adTracker,doc,log,w){'use strict';var logGroup='ext.wikia.adEngine.amazonMatchOld',amazonId='3006',amazonTargs,amazonTiming,amazonCalled=false;function trackState(trackEnd){log(['trackState',amazonTargs],'debug',logGroup);var eventName,i,j,data,matches;if(amazonTargs){eventName='lookupSuccess';matches=amazonTargs.replace('amzn_','').match(/[\dx]+_tier\d/g);if(matches){data={};for(i=matches.length-1;i>-1;i-=1){j=matches[i].split('_');data[j[1]]=data[j[1]]||[];data[j[1]].push(j[0]);}}}else{eventName='lookupError';}
if(trackEnd){eventName='lookupEnd';}
adTracker.track(eventName+'/amazon',data||'(unknown)',0);}
function onAmazonResponse(response){amazonTiming.measureDiff({},'end').track();log(['onAmazonResponse',response],'debug',logGroup);amazonTargs=w.amzn_targs;trackState(true);}
function call(){log('call','debug',logGroup);amazonCalled=true;amazonTiming=adTracker.measureTime('amazon',{},'start');amazonTiming.track();var url=encodeURIComponent(doc.location),s=doc.createElement('script');try{url=encodeURIComponent(w.top.location.href);}catch(e){}
s.id=logGroup;s.async=true;s.onload=onAmazonResponse;s.src='//aax.amazon-adsystem.com/e/dtb/bid?src='+amazonId+'&u='+url+"&cb="+Math.round(Math.random()*10000000);doc.body.appendChild(s);}
function wasCalled(){log(['wasCalled',amazonCalled],'debug',logGroup);return amazonCalled;}
return{call:call,trackState:function(){trackState();},wasCalled:wasCalled};});;


(function(window,document){'use strict';window.optimizelyUniqueExperiment=function(currentExperiment,mutuallyExclusiveExperiments){if(window.optimizelyCachedExperiment){return false;}
var active,currentInCookie,key,allExperiments,result;if(mutuallyExclusiveExperiments){active=mutuallyExclusiveExperiments;}else{active=[];allExperiments=window.optimizely.allExperiments;for(key in allExperiments){if(allExperiments.hasOwnProperty(key)&&('enabled'in allExperiments[key])&&allExperiments[key]){active.push(key);}}}
for(key=0;key<active.length;key++){if(document.cookie.indexOf(active[key])>-1){currentInCookie=active[key];break;}}
currentInCookie=currentInCookie||active[Math.floor(Math.random()*active.length)];result=parseInt(currentInCookie,10)===parseInt(currentExperiment,10);if(result){window.optimizelyCachedExperiment=currentExperiment;}
return result;};})(window,document);;


window.visitorType=(document.cookie.indexOf('__utma')>-1)?'Returning':'New';;


(function(window,document){'use strict';window.isFromSearch=function(){var ref=document.referrer;if(document.cookie.replace(/(?:(?:^|.*;\s*)fromsearch\s*\=\s*([^;]*).*$)|^.*$/,"$1")==="1"){return true;}else if(ref.match(/^https?:\/\/(www\.)?google(\.com?)?(\.[a-z]{2}t?)?\//i)){return true;}else if(ref.indexOf('bing.com')!==-1&&ref.indexOf('q=')!==-1){return true;}else if(ref.match(/^https?:\/\/r\.search\.yahoo\.com\/[^?]*$/i)){return true;}else if(ref.indexOf('ask.com')!==-1&&ref.indexOf('q=')!==-1){return true;}else if(ref.indexOf('aol.com')!==-1&&ref.indexOf('q=')!==-1){return true;}else if(ref.indexOf('baidu.com')!==-1&&ref.indexOf('wd=')!==-1){return true;}else if(ref.indexOf('yandex.com')!==-1&&ref.indexOf('text=')!==-1){return true;}
return false;};window.fromsearch=window.isFromSearch();if(window.fromsearch){var date=new Date();date.setTime(date.getTime()+(30*60*1000));document.cookie='fromsearch=1; expires='+date.toGMTString()+'; path=/';}
return window.fromsearch;})(window,document);;