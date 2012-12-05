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
		AJAX.open("GET", document.URL + ".json", false);
		AJAX.setRequestHeader("X-Timezone", "" + new Date().getTimezoneOffset());
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
  console.log(time.out_time);
  document.getElementById("time").innerHTML = time.out_time + " " + time.out_timezone;
}

var time = getTime();