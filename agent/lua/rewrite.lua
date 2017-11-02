
local cjson = require("cjson.safe")

local function rewrite()
    local match = ngx.re.match(ngx.var.uri,[[^/([^/]+)/(.+)$]])
    if not match then
        ngx.log(ngx.ERR,cjson.encode(match)," ",ngx.var.uri)
        return ngx.redirect("/40x.html")
    end
    local host = match[1]
    local path = match[2]
    ngx.location.capture()
end

rewrite()