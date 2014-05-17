-- -------------------------------------------------
-- BTC-E.com api for Luvit
-- -------------------------------------------------
-- @version	0.4
-- @author	Evandro <evandro.co>
-- @date	04 25 2014
-- @license	MIT <opensource.org/licenses/MIT>
-- -------------------------------------------------
-- Donations:
-- BTC:		13uujkFS7g5m3QEeFcg9Ya1oGrXzP1EcFs
-- LTC:		LZR8yy85K7UtHUFHLig3nPJwbp2uhtKfyq
-- -------------------------------------------------

local HTTPS = require("https")
local URL = require("url")
--local QUERYSTRING = require("querystring")
local OS = require("os")
local STRING = require("string")

local CRYPTO = nil
if pcall(require, "crypto") then
	CRYPTO = require("crypto")
else
	CRYPTO = require("_crypto")
end

local HTTPSget = function(url, callback)

	local header = URL.parse(url)
	header.method = "GET"

	local req = HTTPS.request(header, function(res)

		local data = ""

		res:on("data", function(chunk)
			data = data .. chunk
		end)

		res:on("end", function()
			res:destroy()
			callback(true, data)
		end)

	end)

	req:done()

	req:on("error", function(err)
		callback(false, err)
	end)

end

local BTCE = {}
BTCE.__index = BTCE

BTCE.new = function(key, secret, pair1, pair2, callback)
	local self = {}

	self.key = key or ""
	self.secret = secret or ""
	self.pair1 = pair1 or "btc"
	self.pair2 = pair2 or "usd"
	self.callback = callback or function(success, data) p(success, data) end

	return setmetatable(self, BTCE)
end

-- ticker: Get price and volume information
--
-- @param: {Function} callback(success, data) (optional)
-- @param: {String} pair1 (optional)
-- @param: {String} pair2 (optional)
BTCE.ticker = function(self, callback, pair1, pair2)

	callback = callback or self.callback
	pair1 = pair1 or self.pair1
	pair2 = pair2 or self.pair2

	local api = "https://btc-e.com/api/2/" .. STRING.lower(pair1) .. "_" .. STRING.lower(pair2) .. "/ticker"

	HTTPSget(api, callback)

end

-- fee: Get the fee for transactions
--
-- @param: {Function} callback(success, data) (optional)
-- @param: {String} pair1 (optional)
-- @param: {String} pair2 (optional)
BTCE.fee = function(self, callback, pair1, pair2)

	callback = callback or self.callback
	pair1 = pair1 or self.pair1
	pair2 = pair2 or self.pair2

	local api = "https://btc-e.com/api/2/" .. STRING.lower(pair1) .. "_" .. STRING.lower(pair2) .. "/fee"

	HTTPSget(api, callback)

end

-- depth: get asks and bids
--
-- @param: {Integer} count (optional)
-- @param: {Function} callback(success, data) (optional)
-- @param: {String} pair1 (optional)
-- @param: {String} pair2 (optional)
BTCE.depth = function(self, count, callback, pair1, pair2)

	count = count or ""
	callback = callback or self.callback
	pair1 = pair1 or self.pair1
	pair2 = pair2 or self.pair2

	local api = "https://btc-e.com/api/2/" .. STRING.lower(pair1) .. "_" .. STRING.lower(pair2) .. "/depth/" .. count

	HTTPSget(api, callback)

end

-- depth: get asks and bids
--
-- @param: {String} method
-- @param: {Table} options (optional)
-- @param: {Function} callback(success, data) (optional)
BTCE.query = function(self, method, options, callback)

	options = options or {}
	callback = callback or self.callback

	local api = "https://btc-e.com/tapi"

	options.method = method
	options.nonce = OS.time() + 1

	local post_data = ""

	for key, value in pairs(options) do
		if post_data ~= "" then
			post_data = post_data .. "&"
		end
		post_data = post_data .. key .. "=" .. value--QUERYSTRING.urlencode(value)
	end

	local sign = CRYPTO.hmac.digest("sha512", post_data, self.secret)

	local header = URL.parse(api)
	header.method = "POST"
	header.headers = {
		Sign = sign,
		Key = self.key,
		["Content-Type"] = "application/x-www-form-urlencoded",
		["Content-Length"] = #post_data,
	}

	local req = HTTPS.request(header, function(res)

		local data = ""

		res:on("data", function(chunk)
			data = data .. chunk
		end)

		res:on("end", function()
			if res.status_code == 200 then
				res:destroy()
				callback(true, data)
			else
				res:destroy()
				callback(false, res.status_code)
			end
		end)

	end)

	req:write(post_data)
	req:done()

	req:on("error", function(err)
		callback(false, err)
	end)

end

return BTCE
