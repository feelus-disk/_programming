/* ###########################################################################

GLOBAL ASSETS RELEASE v6.0.2

BUILD DATE: 20100224

########################################################################### */

// init values
hele = new Array();
newspause = 4; // time to pause news items in seconds
fx = op = ni = 0;
tp = ns = 1;
nop = .1;
nextf = -1;
mout = "mout";
done = false;
newspause = newspause * 1000;

function featurefade(selectedf){
	if (is.docom){
		if (done){
			done = false;
			if (selectedf != 0){
				hele['subhover'+selectedf].style.visibility = "visible";
				hele['mout'].style.visibility = "visible";
				if (fx != 0){
					hele['feature'+fx].style.zIndex = 10;
					hele['subhover'+fx].style.visibility = "hidden";
				}
				hele['feature'+selectedf].style.zIndex = 20;
				hele['feature'+selectedf].style.visibility = "visible";
				fc = fx; 
				fx = selectedf; 
					setTimeout('fadein();',1);
			}else{
				hele['mout'].style.visibility = "hidden";
				hele['subhover'+fx].style.visibility = "hidden";
				fc = fx; 
				fx = selectedf;
				op = 1; 
				setTimeout('fadeout();',1);
			}
		}else{
			nextf = selectedf;
		}
	}
}

function fadein(){
	if (!is.op && !is.iemac && !is.oldmoz){
		setopacity('feature'+fx,.99);
	}else{
		setopacity('feature'+fx,1);
	}
	if (fc != 0){
		hele['feature'+fc].style.visibility = "hidden";
	}
	op = 0;
	done = true;
	if (nextf != -1){
		featurefade(nextf);
		nextf = -1;
	}
}

function fadeout(){
	if (!is.op && !is.iemac && !is.oldmoz){
		op = op - .5;
		if (op <= 0){
			op = 0;
			hele['feature'+fc].style.visibility = "hidden";
			setopacity('feature'+fc,.99);
			done = true;
		}else{
			setopacity('feature'+fc,op);
			setTimeout('fadeout();',50);
		}
	}else{
		hele['feature'+fc].style.visibility = "hidden";
		done = true;
	}
}

function fadenews(){
	if (nop == .1){
		nx = ns + 1;
		if(nx > tp){
			nx = 1;
		}
		if (!is.safari && !is.oldmoz && !is.ns6 && !is.iemac){
			setopacity('newsitem'+nx,.1);
		}else{
			var nn = 1;
			while (hele['newsitem'+nn]){
				if (nn != nx){
					hele['newsitem'+nn].style.visibility = "hidden";
				}else{
					if (!is.oldmoz){
						setopacity('newsitem'+nn,.99);
					}
					hele['newsitem'+nn].style.visibility = "visible";
				}	
				nn++;
			}
		}
		hele['newsitem'+nx].style.visibility = "visible";
		hele['newsitem'+ns].style.zIndex = 3;
		hele['newsitem'+nx].style.zIndex = 5;
	}

	if (!is.safari && !is.oldmoz && !is.ns6){
		nop = nop + .2;
		if (nop >= .99){
			nop = .1;
			hele['newsitem'+ns].style.visibility = "hidden";
			setopacity('newsitem'+ns,.99);
			ns++;
			if(ns > tp){
				ns = 1;
			}
			setTimeout('fadenews();',newspause);
		}else{
			setopacity('newsitem'+nx,nop);
			setTimeout('fadenews();',130);
		}
	}else{
		ns++;
		if(ns > tp){
			ns = 1;
		}
		setTimeout('fadenews();',newspause);
	}
}

function setopacity(cobj,opac){
	if (document.all && !is.op && !is.iemac){ //ie
   		hele[cobj].filters.alpha.opacity = opac * 100;
	}else{
		hele[cobj].style.MozOpacity = opac;
		hele[cobj].style.opacity = opac;
	}
}

var rollNames=["",""];
function prephome(){
	if (is.docom && !hele['newsitem1']){
		while (document.getElementById('newsitem'+tp)){
			hele['newsitem'+tp] = document.getElementById('newsitem'+tp);
			hele['newsitem'+tp].style.left='10px';
			if (is.oldmoz){
				setopacity('newsitem'+tp,1);
				hele['newsitem'+tp].style.visibility = "hidden";
			}
			if (is.iewin){
				hele['newsitem'+tp].style.backgroundImage = 'url(/im/bg_home_b3_iewin.gif)';
			}
			if (tp == 1){
				hele['newsitem1'].style.zIndex = 3;
			}
			if (is.oldmoz && tp == 1){
				hele['newsitem'+tp].style.visibility = "visible";
			}

			tp++;
		}
		tp--;
		
		// get names for omniture
		if(rollNames[0] == "" && document.getElementById('ipfeature')){
			rollNames[0] = document.getElementById('ipfeature').src.replace(/.*\/b1_([^\/.]+_d).jpg/,"$1");;
			rollNames[1] = document.getElementById('ipsub1').src.replace(/.*\/b1_([^\/.]+)_p1.gif/,"$1_s");;
			rollNames[2] = document.getElementById('ipsub2').src.replace(/.*\/b1_([^\/.]+)_p2.gif/,"$1_s");;
			rollNames[3] = document.getElementById('ipsub3').src.replace(/.*\/b1_([^\/.]+)_p3.gif/,"$1_s");;
		}
		
		var sf = 1;
		while (document.getElementById('subhover'+sf)){
			hele['subhover'+sf] = document.getElementById('subhover'+sf);
			hele['feature'+sf] = document.getElementById('feature'+sf);
		if (!is.op && !is.iemac && !is.oldmoz){
				setopacity('feature'+sf,1);
			}
			sf++;
		}
		hele['mout'] = document.getElementById('mout');
		if (tp > 0){
			setTimeout('fadenews();',newspause);
		}
	}
	// for old code with new page
	if (!document.getElementById('mtopics')){
		movin();
	}
}

// omniture code
function customlink(thisfeature) {
	if(window.s_account){
		s_linkType='o';
		s_linkName=thisfeature;
		s_lnk=s_co(this);
		s_gs(s_account);
	}
}

// legacy function
var rollCount=[0,0,0,0];
function sendRollData() {}

