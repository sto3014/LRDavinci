local LrView = import("LrView")
local LrPrefs = import("LrPrefs")
local logger = require("Logger")
-------------------------------------------------------------------------------

local InfoProvider = {}

-------------------------------------------------------------------------------

function InfoProvider.sectionsForTopOfDialog(f, _)
    logger:trace("sectionsForTopOfDialog")
    local prefs = LrPrefs.prefsForPlugin()
    return {
        {
            title = LOC("$$$/Davinci/PluginSettings=Plug-in Settings"),
            bind_to_object = prefs,

            f:row {
                f:static_text {
                    title = LOC("$$$/Davinci/AnnotateOpen/Title=After Export"),
                    width_in_chars = 19,
                },
                f:checkbox {
                    title = LOC("$$$/Davinci/AnnotateOpen/Open=Open Annotate Page"),
                    value = LrView.bind("openAnnotateURL"),
                    --checked_value = true, -- this is the initial state
                    --unchecked_value = false,
                },
            },

            f:row {
                f:static_text {
                    title = LOC("$$$/Davinci/ShowWarnings=Show warnings:"),
                    width_in_chars = 19,
                },
                f:checkbox {
                    title = LOC("$$$/Davinci/TourNameWarnings/Show=Tour Names"),
                    value = LrView.bind("showTourNameWarnings"),
                    --checked_value = true, -- this is the initial state
                    --unchecked_value = false,
                },
                f:checkbox {
                    title = LOC("$$$/Davinci/TourURLWarnings/Show=Tour URLs"),
                    value = LrView.bind("showTourURLWarnings"),
                    --checked_value = true, -- this is the initial state
                    --unchecked_value = false,
                },
            },

        },
    }
end

-------------------------------------------------------------------------------

function InfoProvider.sectionsForBottomOfDialog(f, property_table)
   return {}
end

-------------------------------------------------------------------------------

return InfoProvider