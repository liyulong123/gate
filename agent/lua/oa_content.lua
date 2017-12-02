--
-- Created by IntelliJ IDEA.
-- User: liyulong
-- Date: 2017/12/2
-- Time: 上午8:50
-- To change this template use File | Settings | File Templates.
--
local cjson = require("cjson.safe")

local function process_src_list(src_it, data,pattern)

        ngx.log(ngx.ERR,"process")

    if not data or data  == nil or data == ngx.null then
        ngx.log(ngx.ERR,"no data")
        return data
    end
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
        ngx.log(ngx.ERR,cjson.encode(src))

        local m, err = ngx.re.match(src[1], "^http")
        if  not m and src[1] ~= "#" and src[1] ~= '{0}' then
            ngx.log(ngx.ERR,pattern," ---- ",src[1])
            data = ngx.re.gsub(data, src[1], "http://oa.xiaozhu.work/" .. src[1])
        end

    end

    return data
end

ngx.log(ngx.ERR,"=========")
local data, eof = ngx.arg[1], ngx.arg[2]
if data and not eof then


    local result = ngx.re.gsub(data, "https://59.173.21.163:8882", "http://oa.xiaozhu.work", "i")
    local spec = {
        '/com/xml2json.js',

    }
    for _, sp in pairs(spec) do
        result = ngx.re.gsub(data,sp,"http://oa.xiaozhu.work"..sp)

    end
    local patt = {
        ' src[ ]{0,4}=[^"]{0,4}"([^"]+)"',
        ' href[ ]{0,4}=[^"]{0,4}"([^"]+)"',
        ' src=\\\\"(/com/64sys.js)\\\\"',
        ' href[ ]{0,4}=[ ]{0,4}\\"([^"]+)\\"',
    }

    for _, pattern in pairs(patt) do
        if result == nil then
            ngx.log(ngx.ERR," result is nil  ------------")
            return
        end
        local list, err = ngx.re.gmatch(result, pattern)
        if list and list ~=nil and list ~= ngx.null then
            result = process_src_list(list, result,pattern)
        else
            ngx.log(ngx.ERR,"no match for : ",pattern)
        end
    end

    ngx.arg[1] = result

end

