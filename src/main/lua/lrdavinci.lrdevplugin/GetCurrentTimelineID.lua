--[[----------------------------------------------------------------------------
SearchLastModified.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'

-- Logger
local logger = require("Logger")

-- Utilities
local stringutil = require('StringUtil')

--[[---------------------------------------------------------------------------
readfile
-----------------------------------------------------------------------------]]
local function readfile(path)
    logger.trace("read_file start")
    logger.trace("path=" .. path)

    local data = ""
    local f = assert(io.open(path, "r"))
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
    if (project or timeline) then
        if (LrDialogs.confirm(LOC("$$$/LRDavinci/Error/ProjectOrTimelineHaveValue=Either project or timeline property has already a value. Continue?", result)) == "cancel") then
            return
        end
    end
    local output_path = os.tmpname()
    logger.trace("Output=" .. output_path)
    local cmd
    cmd = '"' .. _PLUGIN.path .. '/drremote.sh' .. '"' .. ' -m gettimeline' .. ' -o ' .. output_path .. ' 2>/tmp/err.log'
    logger.trace(cmd)
    LrTasks.execute(cmd)
    local data = readfile(output_path)
    if (stringutil.starts(data, "Error")) then
        LrDialogs.message(LOC("$$$/LRDavinci/Error/GetIDsFromTimeline=Could not get IDs from current timeline."), data, 'critical')
        return
    end
    activeCatalog:withWriteAccessDo("Set timeline IDs", function()
        logger.trace("Set timeline IDs:")
        for line in string.gmatch(data, '[^\r\n]+') do
            logger.trace("Line: " .. line)
            if (string.find(line, '\=')) then
                local tokens = stringutil.split(line, "=")
                local property=tokens[1]
                logger.trace("property=" .. property)
                local value=tokens[2]
                logger.trace("value=" .. value)
                logger.trace("Photo: " .. tostring(photo))

                if ( property == "project") then
                    logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciProject", value))
                else
                    if ( property == "timeline") then
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciTimeline", value))
                    else
                        if ( property == "database") then
                            logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciDatabase", value))
                        end
                    end
                end
            end
        end
    end)
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("getIDsCurrentTimeline", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Get IDs of current timeline", TaskFunc)
end) -- end main function



