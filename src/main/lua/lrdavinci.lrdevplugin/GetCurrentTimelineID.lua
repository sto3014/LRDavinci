--[[----------------------------------------------------------------------------
SearchLastModified.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrProgressScope = import 'LrProgressScope'

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
set properties
-----------------------------------------------------------------------------]]
function setProperties(data)
    logger.trace("setProperties start")
    local activeCatalog = LrApplication.activeCatalog()

    local photo = activeCatalog:getTargetPhoto()
    local projectOld = (photo:getPropertyForPlugin(PluginInit.pluginID, 'DavinciProject'))
    local timelineOld = (photo:getPropertyForPlugin(PluginInit.pluginID, 'DavinciTimeline'))
    local databaseOld = (photo:getPropertyForPlugin(PluginInit.pluginID, 'DavinciDatabase'))

    activeCatalog:withWriteAccessDo("Set timeline IDs", function()
        local projectNew
        local timelineNew
        local databaseNew

        logger.trace("Set timeline IDs:")
        for line in string.gmatch(data, '[^\r\n]+') do
            logger.trace("Line: " .. line)
            if (string.find(line, '\=')) then
                local tokens = stringutil.split(line, "=")
                local property = tokens[1]
                logger.trace("property=" .. property)
                local value = tokens[2]
                logger.trace("value=" .. value)
                logger.trace("Photo: " .. tostring(photo))

                if (property == "project") then
                    projectNew = value
                else
                    if (property == "timeline") then
                        timelineNew = value
                    else
                        if (property == "database") then
                            databaseNew = value
                        end
                    end
                end
            end
        end
        if (databaseOld ~= nil and databaseOld ~= databaseNew) then
            if (projectOld ~= nil and projectOld ~= projectNew) then
                if (timelineOld ~= nil and timelineOld ~= timelineNew) then
                    -- all different
                    if (LrDialogs.confirm(LOC("$$$/LRDavinci/Error/PropertiesExist3="..
                            "All properties already exist and will be overwritten:^n^1^n^2^n->^n^3^n^4^n^5^n->^n^6^n^7^n^8^n->^n^9^n^nContinue?",
                            "Database", databaseNew, databaseOld, "Project", projectNew, projectOld, "Timeline", timelineNew, timelineOld, result)) == "cancel") then
                        return
                    else
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciProject", projectNew))
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciTimeline", timelineNew))
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciDatabase", databaseNew))
                    end
                else
                    -- database and project
                    if (LrDialogs.confirm(LOC("$$$/LRDavinci/Error/PropertiesExist2="..
                            "Two properties already exist and will be overwritten:^n^1^n^2^n->^n^3^n^4^n^5^n->^n^6^n^nContinue?",
                            "Database", databaseNew, databaseOld, "Project", projectNew, projectOld, result)) == "cancel") then
                        return
                    else
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciProject", projectNew))
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciDatabase", databaseNew))
                    end
                end
            else
                if (timelineOld ~= nil and timelineOld ~= timelineNew) then
                    -- database and timeline
                    if (LrDialogs.confirm(LOC("$$$/LRDavinci/Error/PropertiesExist2="..
                            "Two properties already exist and will be overwritten:^n^1^n^2^n->^n^3^n^4^n^5^n->^n^6^n^nContinue?",
                            "Database", databaseNew, databaseOld, "Timeline", timelineNew, timelineOld, result)) == "cancel") then
                        return
                    else
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciTimeline", timelineNew))
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciDatabase", databaseNew))
                    end
                else
                    -- database
                    if (LrDialogs.confirm(LOC("$$$/LRDavinci/Error/PropertiesExist1="..
                            "One property already exists and will be overwritten:^n^1^n^2^n->^n^3^n^nContinue?",
                            "Database", databaseNew, databaseOld, result)) == "cancel") then
                        return
                    else
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciDatabase", databaseNew))
                    end
                end
            end
        else
            if (projectOld ~= nil and projectOld ~= projectNew) then
                if (timelineOld ~= nil and timelineOld ~= timelineNew) then
                    -- project and timeline
                    if (LrDialogs.confirm(LOC("$$$/LRDavinci/Error/PropertiesExist2="..
                            "Two properties already exist and will be overwritten:^n^1^n^2^n->^n^3^n^4^n^5^n->^n^6^n^nContinue?",
                            "Project", projectNew, projectOld, "Timeline", timelineNew, timelineOld, result)) == "cancel") then
                        return
                    else
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciProject", projectNew))
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciTimeline", timelineNew))

                    end
                else
                    -- project
                    if (LrDialogs.confirm(LOC("$$$/LRDavinci/Error/PropertiesExist1="..
                            "One property already exists and will be overwritten:^n^1^n^2^n->^n^3^n^nContinue?",
                            "Project", projectNew, projectOld, result)) == "cancel") then
                        return
                    else
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciProject", projectNew))
                    end
                end
            else
                if (timelineOld ~= nil and timelineOld ~= timelineNew) then
                    -- timeline
                    if (LrDialogs.confirm(LOC("$$$/LRDavinci/Error/PropertiesExist1="..
                            "One property already exists and will be overwritten:^n^1^n^2^n->^n^3^n^nContinue?",
                            "Timeline", timelineNew, timelineOld, result)) == "cancel") then
                        return
                    else
                        logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciTimeline", timelineNew))
                    end
                else
                    -- all equal
                end
            end
        end
        -- Now update just empty once
        if (databaseOld == nil) then
            logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciDatabase", databaseNew))
        end
        if (projectOld == nil) then
            logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciProject", projectNew))
        end
        if (timelineOld == nil) then
            logger.trace(photo:setPropertyForPlugin(_PLUGIN, "DavinciTimeline", timelineNew))
        end
    end)

end
--[[---------------------------------------------------------------------------
Async task
-----------------------------------------------------------------------------]]
function TaskFunc(context)
    logger.trace("TaskFunc")
    local Progress = LrProgressScope({
        title = LOC "$$$/LRDavinci/Progress/SyncIDs=Sync IDs from Davinci Resolve",
        functionContext = context
    })

    local output_path = os.tmpname()
    logger.trace("Output=" .. output_path)
    local cmd
    cmd = '"' .. _PLUGIN.path .. '/drremote.sh' .. '"' .. ' -m gettimeline' .. ' -o ' .. output_path
    logger.trace(cmd)
    LrTasks.execute(cmd)
    local data = readfile(output_path)
    if (stringutil.starts(data, "Error")) then
        LrDialogs.message(LOC("$$$/LRDavinci/Error/GetIDsFromTimeline=Could not get IDs from current timeline."), 'critical')
        return
    end

    setProperties(data)

    Progress:Done()
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("getIDsCurrentTimeline", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Get IDs of current timeline", TaskFunc)
end) -- end main function



