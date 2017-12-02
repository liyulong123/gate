--
-- Created by IntelliJ IDEA.
-- User: liyulong
-- Date: 2017/12/2
-- Time: 上午8:50
-- To change this template use File | Settings | File Templates.
--
local cjson = require("cjson.safe")

local function process_src_list(src_it, data)

        ngx.log(ngx.ERR,"process")

    if not data or data  == nil or data == ngx.null then
        ngx.log(ngx.ERR,"no data")
        return data
    end
    while true do

        local src, err = src_it()
        if err then
            ngx.log(ngx.ERR, "error: ", err)
            return
        end

        if not src then
            -- no match found (any more)
            ngx.log(ngx.ERR,"process no match")
            break
        end
        ngx.log(ngx.ERR,cjson.encode(src))

        local m, err = ngx.re.match(src[1], "^http")
        if  not m and src[1] ~= "#" then
            ngx.log(ngx.ERR,src[1])
            data = ngx.re.gsub(data, src[1], "http://oa.xiaozhu.work/" .. src[1])
        end

    end

    return data
end

ngx.log(ngx.ERR,"=========")
local data, eof = ngx.arg[1], ngx.arg[2]
data = ngx.re.gsub(data, "https://59.173.21.163:8882", "http://oa.xiaozhu.work", "i")
local src_list, err = ngx.re.gmatch(data, 'src[ ]{0,4}=[ ]{0,4}\\?"([^"]+)"')
if src_list then
    data = process_src_list(src_list, data)
else
    ngx.log(ngx.ERR,"no match src")
end
local href_list, err = ngx.re.gmatch(data, 'href[ ]{0,4}=[ ]{0,4}\\?"([^"]+)"')
if href_list then
    data = process_src_list(href_list, data)
else
    ngx.log(ngx.ERR,"no match href")
end
ngx.arg[1] = data

