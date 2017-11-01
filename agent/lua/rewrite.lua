

local function rewrite()
    local match = ngx.re.match(ngx.var.uri,[[^/\d+\.\d+\.\d+\.\d+/([^/]+)/(.+)$]])
    if not match then
        return ngx.redirect("/40x.html")
    end
    local host = match[1]
    local uri = match[2]
    if not uri then
        uri = ""
    end
    ngx.req.set_uri(match[2])
    ngx.req.set_header("Host",host)
end

rewrite()