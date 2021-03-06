# LRDavinci

---
This plug-in provides an _Edit in Davinci Resolve_ functionality for Davinci Resolve Studio.

## Features

---
* Menu action to open the corresponding timeline in Davinci Resolve for a selected video in Lightroom.
* Menu action to synchronise the IDs of the current timeline to the Davinci Resolve properties in Lightroom.
* Add the new metadata set ```Davinci Resolve``` which contains 3 properties identifying a Davinci Resolve timeline

## Requirements

---
* Python module [DRRemote](https://pypi.org/project/drremote/)
* Davinci Resolve Studio (i.e. license is needed)
* At the time, LRDavinci supports only macOS.


## Installation

---
1. Download the zip archive LRDavinci-1.0.0.0.zip from 
   [GitHub](https://github.com/sto3014/LRDavinci/archive/refs/tags/1.0.0.0.zip).
2. Extract the archive in the download folder 
3. Open a terminal window, change to Downloads/LRDavinci-1.0.0.0 and execute install.sh:
    ```
   -> ~ cd Downloads/LRDavinci-1.0.0.0
   -> ./install.sh 
    ```
    Install.sh extracts the plug-in into:
    ```
    ~/Library/Application Support/Adobe/Lightroom/Modules/LRDavinci.lrplugin
    ```
If you installed Davinci Resolve into the standard path ```/Applications``` and if you have only Python 3.6 on 
your computer you can proceed with step 5.

4. Adopt drremote.sh  
   The shell script may need some adoptions:  
   ```
    ~/Library/Application Support/Adobe/Lightroom/Modules/LRDavinci.lrplugin/drremote.sh
   ```
   1. If you installed Davinci Resolve Studio in a different place, you must correct the settings for the Davinci 
     Resolve variables (as you already did for Python module drremote), and the open command:  
     ```
      ...
      export RESOLVE_SCRIPT_API="/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting
      export RESOLVE_SCRIPT_LIB="/Applications/DaVinci Resolve/DaVinci Resolve.app/Contents/Libraries/Fusion/fusionscript.so"
      ...
      /Applications/DaVinci Resolve/DaVinci Resolve.app
      ...
      ```
   2. If you installed more than one Python versions, you must adopt two line:  
   ```
    ...
    /usr/local/bin/drremote $* -w 15 2>/tmp/drremote.err
    ...
    /usr/local/bin/drremote $* 2>/tmp/drremote.err
    ...
    ```
   Replace ```/usr/local/bin/drremote``` with the correct path. This might be something like:  
   ```
    /Library/Frameworks/Python.framework/Versions/3.6/bin/drremote
    ```
   or:
   ```
   ~/.pyenv/versions/3.6.15/bin/drremote
   ```
5. Restart Lightroom

## Usage

---
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

---
None

## Hints and known issues

---
* Open Davinci Resolve Studio  
  The menu action ```Edit in Davinci Resolve``` starts, if necessary, Davinci Resolve. The action waits 15 seconds until
  it tries to connect to Davinci Resolve. If Davinci Resolve is still starting after 15 seconds, it will 
  exit prematurely when the connection request occurs. In this case you must increase the amount of seconds by 
  editing the shell script:
  ```
  ~/Library/Application Support/Adobe/Lightroom/Modules/LRDavinci.lrplugin/drremote.sh
  ```  
  and change the line:
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
  

