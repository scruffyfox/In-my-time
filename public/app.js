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
  parts = document.URL.split("/")
  document.getElementById("time").innerHTML = decodeURI(parts[parts.length - 1]) + " = " + time.out_time + " " + time.out_timezone;
}

var time = getTime();