function f(n_title, n_url, n_date, n_time, n_descr)
{
	this.title = n_title;
	this.url = n_url;
	this.date = n_date;
	this.time = n_time;
	this.descr = n_descr;
}
function compareTime(a,b) {
	if(a.date == b.date) {	
		if (a.time < b.time )
			return 1
		if (a.time > b.time)
			return -1
		return 0
	}
	if (a.date < b.date )
		return 1
	if (a.date > b.date)
		return -1
}





