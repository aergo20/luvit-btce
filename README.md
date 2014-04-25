luvit-btce
==========

BTC-E Trading API for Luvit

How to use
----------

[Download](https://github.com/evandro92/luvit-btce/archive/master.zip) and [extract](http://www.7-zip.org/) `btce.lua` inside your Luvit project (e. g. `modules` directory)

```
your-luvit-project
|--modules
|----btce.lua
...
```
    
In any file add:

``` lua
local BTCE = require("btce") -- edit the path to btce.lua here

local btce = BTCE.new(YOUR_API_KEY, YOUR_API_SECRET) -- does not?: access your btc-e.com profile and click "API keys"
-- YOUR_API_KEY and YOUR_API_SECRET are OPTIONAL. Add only if you will use the "query" function (see below)

-- set pairs
btce.pair1 = "btc"
btce.pair2 = "usd"

-- display price / NO KEY/SECRET required
btce:ticker(function(success, data)
  if success then
    p("Success!", data)
  else
    p("Error!", data)
  end
end)

-- display fee / NO KEY/SECRET required
btce:fee(function(success, data)
  if success then
      p("Success!", data)
  else
      p("Error!", data)
  end
end)

-- display bids / NO KEY/SECRET required
btce:depth(function(success, data)
  if success then
      p("Success!", data)
  else
    p("Error!", data)
  end
end)

-- Get account info / KEY/SECRET required
btce:query("getInfo", {}, function(success, data)
  if success then
      p("Success!", data)
  else
      p("Error!", data)
  end
end)

-- Buy 2 bitcoins for 200$ each / KEY/SECRET required
btce:query("getInfo", {
  "pair" = "btc_usd",
  "type" = "buy",
  "rate" = "200.0",
  "amount" = "2.0",
  }, function(success, data)
  if success then
      p("Success!", data)
  else
      p("Error!", data)
  end
end)
```
    
*Done!*

Donations
---------
*  BTC:		**13uujkFS7g5m3QEeFcg9Ya1oGrXzP1EcFs**
*  LTC:		**LZR8yy85K7UtHUFHLig3nPJwbp2uhtKfyq**


License
-------

The MIT License (MIT)

Copyright (c) 2014 evandro92

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
