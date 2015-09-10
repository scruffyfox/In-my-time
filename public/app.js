function getTime()
{
	if (window.XMLHttpRequest)
	{
		AJAX = new XMLHttpRequest();
	}
	else
	{
		AJAX = new ActiveXObject("Microsoft.XMLHTTP");
	}

	if (AJAX)
	{
		parts = document.URL.split("/")
		if (parts[parts.length - 1].length == 0) return
		AJAX.open("GET", document.URL + ".json", false);
		AJAX.setRequestHeader("X-Timezone", "" + (-new Date().getTimezoneOffset()));
		AJAX.send(null);
		return JSON.parse(AJAX.responseText);
	} 
	else
	{
		return false;
	}
}

function loadTime()
{
	var time = getTime();
	var d = new Date();
    var curr_date = d.getDate();
    var curr_month = d.getMonth() + 1; 
    var curr_year = d.getFullYear();
    var today = curr_year + "-" + curr_month + "-" + curr_date;

	if (time)
	{
		if (time.error)
		{
			document.getElementById("time").innerHTML = "<h1>Error</h1><h2>You tried to convert an invalid time</h2>"; 
		}
		else
		{
			if (time.current_time)
			{
				document.getElementById("time").innerHTML = "<h2>The current time in " + time.in_timezone.trim() + " (" + time.in_timezone_utc.trim() + ") is</h2><h1>" + time.out_time + " " + time.in_timezone.trim() + "</h1>";
			}
			else
			{
				document.getElementById("time").innerHTML = "<h2>" + time.in_time.trim() + " " + time.in_timezone.trim() + " (" + time.in_timezone_utc.trim() + ") in your time is</h2><h1>" + time.out_time + (today != time.out_date ? " (" + time.out_date + ") " : "") + " " + time.out_timezone + "</h1>";
			}

			document.getElementById("wrongtime").href = "mailto:callum@callumtaylor.net?subject=inmyti.me%20wrong%20conversion&body=" + encodeURI("This time converted wrong - " + JSON.stringify(time) + "\r\nBrowser timezone: " + (-new Date().getTimezoneOffset()));
		}
	}
}