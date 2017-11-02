--
-- Created by IntelliJ IDEA.
-- User: liyulong
-- Date: 2017/11/2
-- Time: 9:55
-- To change this template use File | Settings | File Templates.
--


local cjson = require("cjson.safe")

local function run()
    local match = ngx.re.match(ngx.var.uri,[[^/([^/]+)/(.+)$]])
    if not match then
        ngx.log(ngx.ERR,cjson.encode(match)," ",ngx.var.uri)
        return ngx.redirect("/40x.html")
    end
    local host = match[1]
    local path = match[2]
    local uri = ngx.var.scheme .. "://".. host .. "/" .. path
    ngx.exec(uri)
end

run()