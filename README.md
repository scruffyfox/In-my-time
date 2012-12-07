#Possible calls

`http://inmyti.me/5pm<timezone>`

`http://inmyti.me/5am<timezone>`

`http://inmyti.me/16<timezone>`

`http://inmyti.me/5:30pm<timezone>`

`http://inmyti.me/5:30am<timezone>`

`http://inmyti.me/16:30<timezone>`

`http://inmyti.me/16:30<timezone>`

`http://inmyti.me/1600<timezone>`

`http://inmyti.me/0500<timezone>`

Will count as AM

`http://inmyti.me/5<timezone>`

Will count as PM

`http://inmyti.me/16<timezone>`

Will show user's current time

`http://inmyti.me/`

Will show the time in this timezone

`http://inmyti.me/<timezone>`

#API

All of the above calls with either `.json` or `.xml` appened to the end. Will return

Using the API you must specify the user's timezone in either offset to UTC in minutes, or textual timezone using query parameter `?timezone=` or header `x-timezone`

Note: using javascript to get the timezone needs to be inverted. Javascript returns the inverse time in minutes. When supplying a timezone with hour modifier E.G. `utc+5` you can either use `utc+5` or `utc5`, but to specify a negative modifier, you must use the `-` symbol.

Example:

`http://inmyti.me/1600pmEST?timezone=UTC`

Example Response: 

```
{
  "in_time": "5",
  "in_timezone": "<timezone>",
  "out_time": "4",
  "out_timezone": "GMT-1",
  "iso": ""
}
```

```
<xml>
  <in-time>5</in-time>
  <in-timezone>timezone</in-timezone>
  <out-time>4</out-time>
  <out-timezone>GMT-1</out-timezone>
  <iso></iso>
</xml>
```