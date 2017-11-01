
local function get_agent_ip()
    return "47.254.20.111"
end

local function rewrite()
    local uri = ngx.var.scheme .. "://".. get_agent_ip() .. "/" .. ngx.req.get_headers()["Host"] .."/"..ngx.var.uri
    return ngx.redirect(uri)
end

rewrite()