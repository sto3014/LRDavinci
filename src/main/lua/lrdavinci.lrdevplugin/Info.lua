return {

	LrSdkVersion = 3.0,
	LrSdkMinimumVersion = 2.0,
	LrToolkitIdentifier = 'at.homebrew.lrdavinci',

	LrPluginName = LOC "$$$/Davinci/PluginName=Davinci Resolve",

	-- Add the Metadata Definition File
	LrMetadataProvider = 'DavinciMetadataDefinition.lua',
	
	-- Add the Metadata Tagset File
	LrMetadataTagsetFactory = {
		'DavinciMetadataTagset.lua',
	},
	LrLibraryMenuItems = {
		{
			title = LOC "$$$/Davinci/Menu/Library/EditInDR=Edit in Davinci Resolve…",
			file = "EditInDavinciResolve.lua",
			enabledWhen = "videosSelected",
		},
		{
			title = LOC "$$$/Davinci/Menu/Library/GetID=Sync IDs from Davinci Resolve",
			file = "GetCurrentTimelineID.lua",
			enabledWhen = "videosSelected",
		},
	},

	LrInitPlugin = "InitPlugin.lua",

	VERSION = { major=1, minor=0, revision=0, build=0, },

}
