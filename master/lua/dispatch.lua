
local function get_agent_ip()
    return "115.28.55.40"
end

local function rewrite()
    local uri = ngx.var.scheme .. "://".. get_agent_ip() .. "/" .. ngx.req.get_headers()["Host"] ..ngx.var.uri
    local tag = "_from_node=" .. ngx.var.server_addr .. "&_ts" .. ngx.localtime()
    if ngx.var.query_string then
        uri = uri .. "?" ..ngx.var.query_string .. "&" .. tag
    else
        uri = uri .. "?" .. tag
    end
    return ngx.redirect(uri)
end

rewrite()