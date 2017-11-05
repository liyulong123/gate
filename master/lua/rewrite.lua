
local function get_agent_ip()
    return "115.28.55.40"
end

local function rewrite()
    local uri = ngx.var.scheme .. "://".. get_agent_ip() .. "/" .. ngx.req.get_headers()["Host"] ..ngx.var.uri.."?"..ngx.var.query_string
    return ngx.redirect(uri)
end

rewrite()