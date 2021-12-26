---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by dieterstockhausen.
--- DateTime: 26.12.21 10:47
---

local stringutil = {}
--[[---------------------------------------------------------------------------
Split
-----------------------------------------------------------------------------]]
function stringutil.split (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

--[[---------------------------------------------------------------------------
string.starts
-----------------------------------------------------------------------------]]
function stringutil.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

return stringutil
