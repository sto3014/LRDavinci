# LRDavinci
This plug-in provides an _Edit in Davinci Resolve_ functionality for Davinci Resolve Studio.

## Features
* Menu action to open the corresponding timeline in Davinci Resolve for a selected video in Lightroom.
* Menu action to synchronise the IDs of the current timeline to the Davinci Resolve properties in Lightroom.
* Add the new metadata set ```Davinci Resolve``` which contains 3 properties identifying a Davinci Resolve timeline

## Requirements
* [DRRemote](https://pypi.org/project/drremote/)
* Davinci Resolve Studio (i.e. license is needed)
* At the time, LRDavinci supports only macOS.


## Installation
* Download the zip archive from [GitHub](https://github.com/sto3014/LRDavinci/tree/main/target).
* Extract the archive into your 
  [home folder](https://www.cnet.com/tech/computing/how-to-find-your-macs-home-folder-and-add-it-to-finder/).
* Adopt drremote.sh  
  If you used the standard installation of Davinci Resolve Studio and Python 3.6 is the only version installed you 
  can skip this step.  
  Otherwise, you must adopt  
  ```
  ~/Library/Application Support/Adobe/Lightroom/Modules/LRDavinci.lrplugin/drremote.sh
  ```  
  * If you installed Davinci Resolve Studio in a different place, you must correct the settings for the Davinci
    Resolve variables (as you already did for Python module drremote), and the open command 
    ```
    ...
    export RESOLVE_SCRIPT_API="/Library/Application Support/Blackmagic Design/DaVinci Res`olve/Developer/Scripting"
    export RESOLVE_SCRIPT_LIB="/Applications/DaVinci Resolve/DaVinci Resolve.app/Contents/Libraries/Fusion/fusionscript.so"
    ...
    /Applications/DaVinci Resolve/DaVinci Resolve.app
    ...
    ```
  * If you installed Python 3.6 in none standard place (e.g., you use pyenv), or if you uses more than one Python 
    versions, you must adopt two lines  
    ```
    ...
    /usr/local/bin/drremote $* -w 15 2>/tmp/drremote.err
    ...
    /usr/local/bin/drremote $* 2>/tmp/drremote.err
    ...
    ``` 
    Replace ```/usr/local/bin/drremote``` with the correct path. This might be something like  
    ```
    /Library/Frameworks/Python.framework/Versions/3.6/bin/drremote
    ```
    if you have additional Python version installed and therefore, PIP does not create drremote in /usr/local/bin, 
    or, if using pyenv
    ```
    ~/.pyenv/versions/3.6.15/bin/drremote
    ```
* Restart Lightroom

## Usage

There are two new actions under the ```Library/Plug-in Extra``` menu:
* Edit in Davinci Resolve
* Sync IDs from Davinci Resolve  

The action ```Edit in Davinci Resolve```starts Davinci Resolve and set the current timeline to the corresponding timeline of the selected 
video in Lightroom. Before you can do so, the video must be "linked" to the timeline. 
To link a video to a timeline you must activate the wanted timeline in Davinci Resolve, select the video in Lightroom 
and push the ```Sync IDs from Davinci Resolve``` action.
  
The basic workflow for linking a video works as follows:
1. Render a timeline in Davinci Resolve
2. Import the video into Lightroom
3. Select the video and push ```Library/Plug-in Extras/Sync IDs from Davinci Resolve```  

Later you can open the corresponding timeline by:
1. Selecting the linked video in Lightroom
2. Push ```Library/Plug-in Extras/Edit in Davinci Resolve```


### New Metadata Set 
The new metadata set ```Davinci Resolve``` displays some standard properties and three new ones which 
appear under the ```Davinci Resolve``` header:
* Database
* Project
* Timeline

These properties link a video to a Davinci Resolve Timeline. Additionally, you may search or filter 
by these properties.

## Plug-in Settings
None

## Hints and known issues
* Open Davinci Resolve Studio  
  The menu action ```Edit in Davinci Resolve``` starts Davinci Resolve, if necessary. The action waits 15 seconds until
  it tries to connect to Davinci Resolve. In cases, where Davinci Resolve isn't already started yet, Davinci resolves 
  exits prematurely. In this case you should increase the amount of seconds. There adopt
  ```
  ~/Library/Application Support/Adobe/Lightroom/Modules/LRDavinci.lrplugin/drremote.sh
  ```  
  and change the line
  ```
   /usr/local/bin/drremote $* -w 15 2>/tmp/drremote.err
  ```
  by replacing _15_ by a higher value.
* Filename in render settings  
  If possible use the timeline name as filename for rendering. This helps to find the correct timeline if you 
  linked a wrong timeline before. See ```Deliver``` page, ```Render Settings-Custom```, ```File```, 
  ```Filename uses```, ```Timeline name```
* Video metadata after update  
  If you update a video in place - and don't re-import it - Lightroom does not update the video metadata, like 
  ```Duration``` or ```Video Dimenions```.  
  In contrast, the EXIF data and the video preview are updated.  
  

