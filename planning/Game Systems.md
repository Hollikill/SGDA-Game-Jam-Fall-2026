# Code Systems

## Scene system

1. rooms + anomaly variations are single scene
   1. anomaly variation component, which enables/disables object if the correct anomaly number is shown. (eg. `anomaly (boolean): false, id: 7` will show up in all rooms but anomaly variation 7, `anomaly (boolean): true, id: 3` will only show up in anomaly variation 3)
2. data about what connections room has
   1. connection data: room coordinates, anomaly version id

## Tile grid

1. controls character movement, collision, room transition triggers
   1. collision: mark non-traversable tiles, traversable tiles, and tiles which become traversable after a global flag is true

## Animation component

1. Controls the images an object displays (called nodes in Godot).
   1. Should handle default cycling through a list of images (an animation), as well as taking triggers to switch to a different animation.
   2. Animation ids and images should be defined in the inspect panel of the game engine.

## Persistent Game Data

1. save game data between scenes
   1. which anomaly versions have been completed
   2. which global flags have been unlocked (eg. dungeon gate opened, rock wall 5 destroyed, etc.)
      1. item trigger and unlock systems should hook into a system that allows automatic creation of flags. (eg. rock wall number whatever doesn't directly specify `rock_wall_broken_7` but instead `id: rock_wall_broken, type: instanced`). Still allow further specifying which id manually for multiple-room flags.

## Input handling

1. handle player inputs:
   1. movement keys
   2. mouse controls for clicking on objects in room
   3. unlockable ability keys (eg. flip, go the special anomaly version of a room)

## Inventory System

1. hold items
2. provide info about items through UI
3. give option to use items

## Dialogue triggers

1. trigger dialogue from the character when the player does:
   1. moves into a certain area
   2. attempts to use an item
   3. triggers a global flag for the first time
   4. ?? possibly more

## Zoom out feature

1. provided a zoom out low-detail view of the room and surrounding 8 rooms
   1. borders around rooms as described in the GDD
   2. arrange rooms on screen as to match the flip-state of the room connections

## Cutscene system

1. play a simple animation using the character and a given object
   1. used for player fighting anomalies animation
   2. disable player controls while cutscene is playing

## In-Game UI

1. keep track of total player progress somehow?

## Main Menu

1. allow player to go back/forth from main menu with a simple keypress
   1. button to start/continue game (returns player to same position and same global flags)
   2. button to reset save
   3. settings page
      1. volume controls
         1. master volume
         2. sfx volume
         3. music volume
      2. fullscreen controls
      3. speedrun mode toggle (shows timer on screen at all times, not just on end screen)

## Audio system

1. loop music, select track depending on rooms completed, fade between tracks
2. allow other systems to play sfx

## Room background loader

1. load room backgrounds from 1280x720 png files and attach them to room scene roots
2. allow other scripts to queury a room ID to get the room background .png
