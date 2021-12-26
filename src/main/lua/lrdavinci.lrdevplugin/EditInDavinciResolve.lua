--[[----------------------------------------------------------------------------
SearchLastModified.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrLogger = import 'LrLogger'
local LrApplication = import 'LrApplication'
local LrProgressScope = import("LrProgressScope")
local LrPrefs = import("LrPrefs")
local LrTasks = import 'LrTasks'




-- Logger
local logger = require("Logger")
function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

local function read_file(path)
    logger.trace("read_file start")
    logger.trace("path=" .. path)

    local data=""
    local f = assert(io.open(path , "r"))
    for line in f:lines() do
        logger.trace("line=" .. line)
        data = data .. line .. "\n"
    end
    f:close()
    logger.trace("read_file end")
    return data
end

--[[---------------------------------------------------------------------------
Async task
-----------------------------------------------------------------------------]]
function TaskFunc(context)
    logger.trace("TaskFunc")

    local activeCatalog = LrApplication.activeCatalog()
    local photo = activeCatalog:getTargetPhoto()
    local result
    if (not photo) then
        LrDialogs.message(LOC("$$$/LRDavinci/Error/NoTargetPhoto=No photo is selected."), result, 'critical')
        return
    end

    local project = (photo:getPropertyForPlugin(PluginInit.pluginID, 'DavinciProject'))
    local timeline = (photo:getPropertyForPlugin(PluginInit.pluginID, 'DavinciTimeline'))
    local database = (photo:getPropertyForPlugin(PluginInit.pluginID, 'DavinciDatabase'))
    if ( not project or not timeline) then
        LrDialogs.message(LOC("$$$/LRDavinci/Error/NoProjectOrTimeline=Eiter project or timeline property is not set."), result, 'critical')
        return
    end
    local output_path = os.tmpname()
    logger.trace("Output=" .. output_path)
    local cmd
    if ( database) then
        cmd = '"' .. _PLUGIN.path .. '/drremote.sh' .. '"' .. ' -m settimeline -p ' .. '"' .. project .. '"' .. ' -t ' .. '"' .. timeline .. '"' .. ' -d ' .. '"' .. database ..'"' ..' -o ' .. output_path .. ' 2>/tmp/err.log'
    else
        cmd = '"' .. _PLUGIN.path .. '/drremote.sh' .. '"' .. ' -m settimeline -p ' .. '"' .. project .. '"' .. ' -t ' .. '"' .. timeline .. '"' .. ' -o ' .. output_path .. ' 2>/tmp/err.log'
    end
    logger.trace(cmd)
    LrTasks.execute(cmd)
    local data = read_file(output_path)
    if ( string.starts(data, "Error")) then
        LrDialogs.message(LOC("$$$/LRDavinci/Error/EditInDavinci=Video could not be opened in Davinci Resolve."), data, 'critical')
    end
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("editInDavinci", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Edit in Davinci Resolve", TaskFunc)
end) -- end main function



