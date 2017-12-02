--
-- Created by IntelliJ IDEA.
-- User: liyulong
-- Date: 2017/12/2
-- Time: 上午8:50
-- To change this template use File | Settings | File Templates.
--
local cjson = require("cjson.safe")


local function get_content_from_remote()
    local options = {
        --method = ngx.req.get_method(),
        method = ngx.HTTP_GET,
        args = ngx.req.get_uri_args(),
        body = ngx.req.get_body_data(),
        always_forward_body = true,
        proxy_pass_request_headers = true
    }
    ngx.log(ngx.ERR,cjson.encode(options))
    local response,error = ngx.location.capture("/@oa/"..ngx.var.uri,options)
    if not response then
        ngx.log(ngx.ERR,"failed req from remote , uri: ",ngx.var.uri," options ",cjson.encode(options)," error: ",error)
        return false, error
    end

    if response.status < 400 then
        return response.body
    end
    ngx.log(ngx.ERR,"failed req from remote , uri: ",ngx.var.uri," status not 200 is: ", response.status)
    if response.status >=400 then
        return false, ngx.exit(response.status)
    end
    if response.status < 200 then
        ngx.print(response.body)
        return false, ngx.exit(response.status)
    end
    return false, error
end


local function process_src_list(src_it, data,pattern)
    ngx.log(ngx.ERR,"process")
    while true do

        local src, err = src_it()
        if err then
            ngx.log(ngx.ERR, pattern, " error: ", err)
            return
        end
        if not src then
            -- no match found (any more)
            ngx.log(ngx.ERR,pattern,"  process no match ")
            break
        end
        src = src[2]
        ngx.log(ngx.ERR,cjson.encode(src))
        while true do
            if src == "#" then
                break
            end
            local m, err = ngx.re.match(src, "^http")
            if m then
                break
            end
            local m, err = ngx.re.match(src, "^javascript")
            if m then
                break
            end
            ngx.log(ngx.ERR,pattern," | ",src, " | ",data)
            data = ngx.re.gsub(data, src, "http://oa.xiaozhu.work/" .. src)
            break;
        end
    end
    return data
end

local function process_path(path)
    local first_char = string.sub(path,1,1)
    local second_char = string.sub(path,2,1)
    if first_char == '/' then
        return path
    end
    local m = ngx.re.match(ngx.var.uri,"(/[^/]+/)+.+")
    ngx.log(ngx.ERR,"==============++++++++====",cjson.encode(m))
    if m then
        return m[1] .. path
    end
    return path
end

local function process_content(content)
    local result = ngx.re.gsub(content, "https?://59.173.21.163(:8882)?", "http://oa.xiaozhu.work", "i")
    local func = function (m)
        ngx.log(ngx.ERR,"============================",cjson.encode(m))
        local path = m[3]
        path = process_path(path)
        local res = string.format(' %s=%shttp://oa.xiaozhu.work/%s%s' , m[1], m[2],path,m[4])
        ngx.log(ngx.ERR,res)
        return res
    end
    --result = ngx.re.gsub(result,' (src|href)=(\\\\?")([^#"]+)(")'," $1=$2http://oa.xiaozhu.work$3$4","m")
    result = ngx.re.gsub(result,' (src|href)=(\\\\?")([^#"]+)(")',func,"m")
    --result = ngx.re.gsub(result,'http://oa.xiaozhu.workjavascript',"javascript","m")
    --result = ngx.re.gsub(result,'http://oa.xiaozhu.work..',"http://oa.xiaozhu.work","m")
    return result
end
ngx.log(ngx.ERR,ngx.var.uri)
local content = get_content_from_remote()
if content then
    content = process_content(content)
    ngx.print(content)
end