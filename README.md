#In my time API

The API is very straight forward and follows the following simple parameters.

#Widget

You can create a widget that will automatically convert time on a website to what ever the client's timezone is viewing the page.

Simply add this javascript to the end of your `<body>`

```js
<script>
(function(t,n){e=t.getElementsByClassName("inmytime");for(var i in e){a=new XMLHttpRequest||new ActiveXObject("Microsoft.XMLHTTP");e[i].href="http://inmyti.me/"+e[i].innerHTML;e[i].title=e[i].innerHTML;a.open("GET",e[i].href+".json",false);a.setRequestHeader("X-Timezone",""+ -(new Date).getTimezoneOffset());a.send();r=JSON.parse(a.responseText);e[i].innerHTML=r.out_time+" "+r.out_timezone}})(document)
</script>
```

and wrap your times around the following tag

`<a class="inmytime"></a>`

For example:

`<a class="inmytime">12:00 EST</a>`

This will automatically replace the contents inside the link, make it linkable to http://inmyti.me and also have the original time as a mouse over hint.

Note: the times have to be in a recognisable format such as below.

#Possible calls

The following calls would be vaild, all base URLs are `http://inmyti.me`

1. `5pm<timezone>`
1. `5am<timezone>`
1. `16<timezone>`
1. `5:30pm<timezone>`
1. `5:30am<timezone>`
1. `16:30<timezone>`
1. `16:30<timezone>`
1. `1600<timezone>`
1. `0500<timezone>`

Will count as AM

`5<timezone>`

Will count as PM

`16<timezone>`

All of the above calls with either `.json`, `.xml` or `.yaml` appened to the end. Will return the relevant format.

Using the API you can specify the user's timezone in either offset to UTC in minutes, or textual timezone using query parameter `?timezone` or header `x-timezone`. If timezone is left blank, the request IP address is used to approximate the timezone, **warning** results can be inaccurate.

Note: using javascript to get the timezone needs to be inverted. Javascript returns the inverse time in minutes. When supplying a timezone with hour modifier E.G. `utc+5` you can either use `utc+5` or `utc5`, but to specify a negative modifier, you must use the `-` symbol.

#Example

[http://inmyti.me/1600pmEST.json?timezone=UTC](http://inmyti.me/1600pmEST.json?timezone=UTC)

Example Response: 

```
{
  "in_time":"16:00",
  "in_timezone":"EST",
  "out_time":"21:00",
  "out_timezone":"UTC+0",
  "out_date":"11/01"
}
```

```
---
  in_time: '16:00'
  in_timezone: EST
  out_time: '21:00'
  out_timezone: UTC+0
  out_date: 11/01
```

```
<time>
  <in-time>16:00</in-time>
  <in-timezone>EST</in-timezone>
  <out-time>21:00</out-time>
  <out-timezone>UTC+0</out-timezone>
  <out-date>11/01</out-date>
</time>
```
