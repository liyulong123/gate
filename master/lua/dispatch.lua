
local function get_agent_ip()
    return "115.28.55.40"
end

local function dispatch()
    local headers = ngx.req.get_headers()
    local host = headers["Host"]
    if not host then
        host = ngx.var.server_name
    end

    local uri = ngx.var.scheme .. "://" .. get_agent_ip() .. "/" .. host .. ngx.var.uri
    local tag = "_fnode=" .. ngx.var.server_addr .. "&_ts=" .. ngx.utctime()
    if ngx.var.query_string then
        uri = uri .. "?" .. ngx.var.query_string .. "&" .. tag
    else
        uri = uri .. "?" .. tag
    end
    return ngx.redirect(uri)
end

dispatch()