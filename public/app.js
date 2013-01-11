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
  if (time.error)
  {
   document.getElementById("time").innerHTML = "<h1>Error</h1><h2>You tried to convert an invalid time</h2>"; 
  }
  else
  {
    document.getElementById("time").innerHTML = "<h2>" + decodeURI(parts[parts.length - 1]) + " in your time is</h2><h1>" + time.out_time + " " + time.out_timezone + "</h1>";
  }
}

var time = getTime();