/* ###########################################################################

GLOBAL ASSETS RELEASE v6.0.2

BUILD DATE: 20100224

########################################################################### */

// TEXT TO LOCALIZE
var ltxt = {
	showDetails: 'Show Details',
	hideDetails: 'Hide Details',
	seeall: 'See All',
	processingRequest: 'Processing Request',
	maxCheckedPart1: 'Sorry. Only',
	maxCheckedPart2: 'items may be selected for comparison.',
	expandAll: 'expand all',
	collapseAll: 'collapse all'
};


// SHARE THIS PAGE
// Turn off share page widget for all pages linking to this file by commenting out the "sharetxt" var

var sharetxt = [
'Java Documentation Page: ',
'Check out this page: ',
'Email this page to a friend',
'See who links to this page on Technorati',
'Bookmark this page in del.icio.us',
'Submit this page to Digg',
'Submit this page to Slashdot',
'Show available feeds'
];

// calendar names and default date format
var monthNamesFull = ["January","February","March","April","May","June","July","August","September","October","November","December"];
var monthNames3 = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
var dayNamesFull = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
var dayNames3 = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
var dayNames2 = ['Su','Mo','Tu','We','Th','Fr','Sa'];
var dayNames1 = ['S','M','T','W','T','F','S'];
var defaultDateFormat = "Mon D, YYYY";

// LOCATION OF YOUR LOCAL IM & CSS DIRECTORIES
var imdir = "/im";
var cssdir = "/css";
var jsdir = "/js";

var shutoff = {
	global: false, // true disables global menus
	share: false, // true disables share page
	pop: false, // true disables k2
	misc: false
};


// A2 MENU ITEMS
a2['Downloads'] = '\
<li><a href="http://www.sun.com/download/index.jsp?tab=5">Top Downloads</a></li>\
<li><a href="http://download.openoffice.org/">OpenOffice</a></li>\
<li><a href="http://java.sun.com/j2se/downloads/">Java Standard Edition</a></li>\
<li><a href="http://www.netbeans.org/downloads/index.html">NetBeans IDE</a></li>\
';

a2['Downloads &amp; Trials'] = a2['Downloads'];

a2['Products'] = '\
<li><a href="http://www.sun.com/software/">Software</a></li>\
<li><a href="http://www.sun.com/servers/">Servers</a></li>\
<li><a href="http://www.sun.com/storage/">Storage</a></li>\
<li><a href="http://www.sun.com/networking">Networking</a></li>\
<li><a href="http://www.sun.com/desktop/">Desktop Systems</a></li>\
<li><a href="http://www.sun.com/optionsandspares/">Options &amp; Spares</a></li>\
<li><a href="http://www.sun.com/tradeins/">Trade-In Programs</a></li>\
<li><a href="http://www.sun.com/ibb/remanufactured/">Remanufactured Systems</a></li>\
';

a2['Services'] = '\
<li><a href="http://www.sun.com/service/serviceplans/index.jsp">Service Plans</a></li>\
<li><a href="http://www.sun.com/service/assess/">Assess</a></li>\
<li><a href="http://www.sun.com/service/architect/">Architect</a></li>\
<li><a href="http://www.sun.com/service/implement/">Implement &amp; Migrate</a></li>\
<li><a href="http://www.sun.com/service/install/">Install</a></li>\
<li><a href="http://www.sun.com/service/managedservices/offerings.jsp">Manage</a></li>\
<li><a href="http://www.sun.com/service/warranty/index.xml">Warranties</a></li>\
';

a2['Solutions'] = '\
<li><a href="http://www.sun.com/solutions/cloudcomputing/index.jsp">Cloud Computing</a></li>\
<li><a href="http://www.sun.com/solutions/eco_innovation/index.jsp">Eco-Efficient Computing</a></li>\
<li><a href="http://www.sun.com/servers/hpc/">High Performance Computing</a></li>\
<li><a href="http://www.sun.com/software/products/identity/index.jsp">Identity Management</a></li>\
<li><a href="http://www.sun.com/storage/openstorage/solutions.jsp">Open Storage</a></li>\
<li><a href="http://www.sun.com/solutions/virtualization/index.jsp">Virtualization</a></li>\
<li><a href="http://www.sun.com/solutions/enterprise_web/">Enterprise Web</a></li>\
<li><a href="http://www.sun.com/solutions/alpha.jsp">Solutions A-Z</a></li>\
<li class="newgroup"><a href="http://www.sun.com/servicessolutions/industries/">Industry Solutions</a></li>\
<li><a href="http://www.sun.com/solutions/midsize/">Midsize Companies</a></li>\
<li><a href="http://www.sun.com//solutions/enterprise/index.jsp">Large Enterprise Business</a></li>\
<li class="newgroup"><a href="http://www.sun.com/third-party/global/index.jsp">Global Partner Solutions</a></li>\
<li><a href="http://www.sun.com/solutions/rapidsolutions/index.html">Rapid Solutions</a></li>\
<li><a href="http://www.sun.com/solutioncenters/index.jsp">Sun Solution Centers</a></li>\
';

a2['Support'] = '\
<li><a href="http://sunsolve.sun.com/handbook_pub/">Sun System Handbook</a></li>\
<li><a href="http://www.sun.com/support/membersupportcenter/index.jsp">Member Support Center</a></li>\
<li><a href="http://www.sun.com/support/knowledge/index.jsp">Knowledge Resources</a></li>\
<li><a href="http://sunsolve.sun.com/show.do?target=patchpage">Patches &amp; Updates</a></li>\
<li><a href="http://www.sun.com/documentation/index.html">Product Documentation</a></li>\
<li><a href="http://www.sun.com/support/communities/index.jsp">Community Resources</a></li>\
<li><a href="http://www.sun.com/support/tools/index.jsp">Proactive &amp; Diagnostic Tools</a></li>\
<li><a href="http://sunsolve.sun.com/">SunSolve Knowledgebase</a></li>\
';

a2['Training'] = '\
<li><a href="http://www.sun.com/training/catalog/">Course Catalog</a></li>\
<li><a href="http://www.sun.com/training/certification/">Certification</a></li>\
<li><a href="http://www.sun.com/training/team/consulting/index.html">Consulting Solutions</a></li>\
<li><a href="http://www.sun.com/webinars">Webinars</a></li>\
';

a2['Sun For...'] = '\
<li><a href="http://www.sun.com/students/">Students</a></li>\
<li><a href="http://developers.sun.com/">Developers</a></li>\
<li><a href="http://www.sun.com/partners/">Partners</a></li>\
<li><a href="http://www.sun.com/startup/">Startups</a></li>\
<li><a href="http://www.sun.com/solutions/midsize/">Midsize Companies</a></li>\
<li><a href="http://www.sun.com/solutions/enterprise_computing/index.jsp">Enterprise</a></li>\
<li><a href="http://www.sun.com/oem">OEM</a></li>\
<li><a href="http://www.sun.com/aboutsun/sunfederal/">Federal</a></li>\
<li><a href="http://www.sun.com/edu/">Education</a></li>\
<li><a href="http://www.sun.com/bigadmin/home/index.html">System Administrators</a></li>\
';

// A1 MENU ITEMS
a1['Sun and Oracle'] = '\
<ul class="bluearrows">\
<li><a href="http://www.sun.com/third-party/global/oracle/">Oracle to Buy Sun</a></li>\
<li><a href="http://www.sun.com/third-party/global/oracle/overview.jsp">Sun and Oracle Partnership</a></li>\
</ul>\
';

a1['Channel Sun'] = '\
<ul class="bluearrows">\
<li><a href="http://blogs.sun.com/">Sun Blogs</a></li>\
<li><a href="http://forums.sun.com/">Sun Forums</a></li>\
<li><a href="http://wikis.sun.com/">Sun Wikis</a></li>\
<li><a href="http://www.sun.com/communityvoices/">Community Voices</a></li>\
</ul>\
';

a1['How to Buy'] = '\
<ul class="bluearrows">\
<li><a href="http://store.sun.com/viewcart.htm">Shopping Cart</a></li>\
<li><a href="https://store.sun.com/vieworderlist.htm">Order History</a></li>\
<li><a href="http://partneradvantage.sun.com/catalog/search/home.jsf">Find a Partner</a></li>\
<li><a href="http://www.sun.com/sales/leasing/index.jsp">Financing</a></li>\
<li><a href="http://java.com/en/store/index.jsp">Java Store</a></li>\
<li><a href="http://www.sun.com/training">Training Store</a></li>\
</ul>\
';

a1['Log In'] = '\
<ul class="bluearrows">\
<li><a href="https://portal.sun.com/portal/dt/">My Sun Connection</a></li>\
<li><a href="https://portal.sun.com/portal/dt?JSPTabContainer.setSelected=MyAccountTabContainer&last=false">My Account</a></li>\
<li><a href="https://portal.sun.com/portal/dt?JSPTabContainer.setSelected=PartnersTabContainerProvider&last=false">Channel Partner Member Center</a></li>\
<li><a href="http://partneradvantage.sun.com">ISV Partner Member Center</a></li>\
<li><a href="http://ibis.sun.com/support">SunSpectrum Member Support Center</a></li>\
<li><a href="https://identity.sun.com/amserver/UI/Login?org=self_registered_users&goto=http://sunsolve.sun.com/cwpGoto.do?target=home">SunSolve</a></li>\
<li><a href="http://developers.sun.com/global/my_profile.html">My SDN Account</a></li>\
<li><a href="https://identity.sun.com/amserver/UI/Login?org=self_registered_users&goto=http%3A%2F%2Fwikis.sun.com%2Fdashboard.action&os_destination=%2Fdashboard.action">Sun Wikis</a></li>\
<li><a href="https://reg.sun.com/register?goto='+encodeURIComponent(document.location)+'">Create a Sun Online Account</a></li>\
</ul>\
';

// A5 MENU ITEMS
a5['News Center'] = '\
<ul class="bluearrows">\
<li><a href="http://www.sun.com/events/index.jsp">Global Events</a></li>\
<li><a href="http://www.sun.com/newsletter">eNewsletter Subscriptions</a></li>\
<li><a href="http://www.sun.com/rss/">Sun Feeds</a></li>\
</ul>\
';

a5['About Sun'] = '\
<ul class="bluearrows">\
<li><a href="http://www.sun.com/aboutsun/company/index.jsp">Our Company</a></li>\
<li><a href="http://www.sun.com/customers/index.xml">Sun Customers</a></li>\
<li><a href="http://www.sun.com/aboutsun/investor/">Investor Relations</a></li>\
<li><a href="http://www.sun.com/aboutsun/csr/index.jsp">Corporate Responsibility</a></li>\
<li><a href="http://www.sun.com/aboutsun/executives/">Executive Perspectives</a></li>\
<li><a href="http://research.sun.com/">Sun Labs</a></li>\
<li><a href="http://www.sun.com/aboutsun/openwork/index.jsp">Sun Open Work</a></li>\
<li><a href="http://sunwear.sun.com/">Sun Wear</a></li>\
<li><a href="http://www.sun.com/corp_emp/">Employment</a></li>\
</ul>\
';

a5['Contact Sun'] = '\
<ul class="bluearrows">\
<li><a href="http://partneradvantage.sun.com/catalog/search/home.jsf">Find a Partner</a></li>\
<li><a href="http://www.sun.com/partners/types.jsp">Become a Partner</a></li>\
<li><a href="http://www.sun.com/contact/sales.jsp">Sales</a></li>\
<li><a href="https://ssl1.taggingserver.netmining.com/script/sun/call/" class="popup 335x370">Call Me Now</a></li>\
<li><a href="https://ssl1.taggingserver.netmining.com/script/sun/chat/" class="popup 335x370">Chat Now</a></li>\
<li><a href="http://www.sun.com/secure/contact/feedback/index.jsp?refurl='+encodeURIComponent(document.location)+'">Inquiries and Feedback</a></li>\
</ul>\
';

a5['Terms of Use'] = '\
<ul class="bluearrows">\
<li><a href="http://www.sun.com/suntrademarks/">Trademarks</a></li>\
</ul>\
';



// A1,A2 LEGACY
a2['Services &amp; Solutions'] = '\
<li><a href="http://www.sun.com/service/serviceplans/index.jsp">Service Plans</a></li>\
<li><a href="http://www.sun.com/service/warranty/index.xml">Warranties</a></li>\
<li><a href="http://www.sun.com/service/consulting/">Consulting &amp; IT Services</a></li>\
<li><a href="http://www.sun.com/servers/hpc/index.jsp">High Performance Computing</a></li>\
<li><a href="http://www.sun.com/service/sungrid/overview.jsp">Utility Computing</a></li>\
<li><a href="http://www.sun.com/service/managedservices/">Managed Services</a></li>\
<li><a href="http://www.sun.com/service/sunconnection/">Secure IT Network Services</a></li>\
<li><a href="http://www.sun.com/servicessolutions/infrastructure/">Sun Solutions Portfolio</a></li>\
';

a2['Developer'] = '\
<li><a href="https://reg.sun.com/register?program=sdn">Join Sun Developer Network</a></li>\
<li><a href="http://java.sun.com/reference/api/index.html">APIs &amp; Docs</a></li>\
<li><a href="http://developers.sun.com/forums/">Forums</a></li>\
<li><a href="http://java.sun.com/">Java For Developers</a></li>\
<li><a href="http://developers.sun.com/prodtech/solaris/index.html">Solaris For Developers</a></li>\
<li><a href="http://developers.sun.com/prodtech/index.html">Technologies</a></li>\
<li><a href="http://developers.sun.com/services/">Developer Services</a></li>\
';

a1['Java'] ='\
<ul class="bluearrows">\
<li><a href="http://www.sun.com/java/">Java at Sun</a></li>\
<li><a href="http://www.sun.com/software/opensource/java/">Free and Open Source Java</a></li>\
<li><a href="http://java.com/download/">Java for your computer</a></li>\
<li><a href="http://java.sun.com/javase/downloads/">Download the latest JDK</a></li>\
<li><a href="http://www.netbeans.org/downloads/index.html">Download NetBeans IDE</a></li>\
<li><a href="http://developers.sun.com/prodtech/javatools/">Java Developer Tools</a></li>\
<li><a href="http://java.sun.com/">Java Developer Resources</a></li>\
<li><a href="http://java.sun.com/javase/">Java Standard Edition</a></li>\
<li><a href="http://java.sun.com/javaee/">Java Enterprise Edition</a></li>\
<li><a href="http://java.sun.com/javame/">Java Micro Edition</a></li>\
<li><a href="http://java.sun.com/learning/training/">Java Training</a></li>\
<li><a href="http://developers.sun.com/services/">Java Support</a></li>\
</ul>\
';

a1['Solaris'] ='\
<ul class="bluearrows">\
<li><a href="http://www.sun.com/software/solaris/">Solaris</a><p>The free and open Solaris OS.</p></li>\
<li><a href="http://developers.sun.com/sunstudio/">Sun Studio</a><p>Optimizing compilers and tools for C/C++/Fortran for application development.</p></li>\
<li><a href="http://developers.sun.com/prodtech/solaris/">Solaris Developer Resources</a><p>Find what you need at the Solaris developers center.</p></li>\
<li><a href="http://developers.sun.com/services/">Solaris Developer Services</a><p>Get dedicated Solaris support and more with Sun Developer Services. </p></li>\
<li><a href="http://www.sun.com/bigadmin/apps/">Solaris 10 Applications Library</a><p>Third-party applications running on Solaris 10.</p></li>\
<li><a href="http://www.sun.com/bigadmin/home/index.html">Solaris System Administrator Resources</a><p>Get all the Solaris information you need. </p></li>\
<li><a href="http://www.opensolaris.com/">OpenSolaris</a><p>The OpenSolaris project is an open source community and a place for collaboration and conversation around OpenSolaris technology.</p></li>\
</ul>\
';

a1['Community Voices'] = '\
<ul class="bluearrows">\
<li><a href="http://blogs.sun.com/">Sun Blogs</a></li>\
<li><a href="http://forums.sun.com/">Sun Forums</a></li>\
<li><a href="http://wikis.sun.com/">Sun Wikis</a></li>\
<li><a href="http://channelsun.sun.com/">Channel Sun</a></li>\
</ul>\
';

a1['Communities'] = a1['Community Voices'];

a1['About Sun'] = a5['About Sun'];

a1['My Sun Connection'] = '\
<ul class="bluearrows">\
<li><a href="http://portal.sun.com/portal/dt?JSPTabContainer.setSelected=PartnersTabContainerProvider&last=false">Partners</a><p>Access the Sun Partner Advantage Membership Center.</p></li>\
<li><a href="https://portal.sun.com/portal/dt?JSPTabContainer.setSelected=MyAccountTabContainer&last=false">My Account</a><p>View and change profile and account information.</p></li>\
<li><a href="https://reg.sun.com/register?goto='+encodeURIComponent(document.location)+'">Register Now</a><p>Get a login to access Sun resources.</p></li>\
</ul>\
';

a1['My Account'] = '\
<ul class="bluearrows">\
<li><a href="https://portal.sun.com/portal/dt">My Sun Connection</a><p>Your personal portal to Sun products, services, and support.</p></li>\
<li><a href="https://reg.sun.com/register?goto='+encodeURIComponent(document.location)+'">Register Now</a><p>Get a login to access Sun resources.</p></li>\
</ul>\
';

a1['Cart'] = '\
<ul class="bluearrows">\
<li><a href="http://shop.sun.com/cart">My Cart</a></li>\
<li><a href="http://shop.sun.com/saved_items">Saved Items</a></li>\
<li><a href="http://shop.sun.com/quotes">Quotes</a></li>\
<li><a href="http://shop.sun.com/orders">Orders</a></li>\
</ul>\
';

a1['Innovating@Sun'] = '\
<ul class="bluearrows">\
<li><a href="http://www.sun.com/software/products/mysql/index.jsp">MySQL</a></li>\
<li><a href="http://www.sun.com/software/products/xvm/index.jsp">xVM</a></li>\
<li><a href="http://www.sun.com/solutions/virtualization/index.jsp">Virtualization</a></li>\
<li><a href="http://www.sun.com/storage/openstorage/">Open Storage</a></li>\
<li><a href="http://www.sun.com/servers/hpc/index.jsp">HPC</a></li>\
<li><a href="http://www.sun.com/software/solaris/">Solaris</a></li>\
<li><a href="http://www.sun.com/java/">Java</a></li>\
</ul>\
';


