
Scene system
	rooms + anomaly variations are single scene
		anomaly variation component, which enables/disables object if the correct anomaly number is shown. (eg. `anomaly (boolean): false, id: 7` will show up in all rooms but anomaly variation 7, `anomaly (boolean): true, id: 3` will only show up in anomaly variation 3)
	data about what connections room has
		connection data: room coordinates, anomaly version id

Tile grid
	controls character movement, collision, room transition triggers
		collision: mark non-traversable tiles, traversable tiles, and tiles which become traversable after a global flag is true

Animation component
	Controls the images an object displays (called nodes in Godot).
		Should handle default cycling through a list of images (an animation), as well as taking triggers to switch to a different animation.
		Animation ids and images should be defined in the inspect panel of the game engine.

Persistent Game Data
	save game data between scenes
		which anomaly versions have been completed
		which global flags have been unlocked (eg. dungeon gate opened, rock wall 5 destroyed, etc.)
			item trigger and unlock systems should hook into a system that allows automatic creation of flags. (eg. rock wall number whatever doesn't directly specify `rock_wall_broken_7` but instead `id: rock_wall_broken, type: instanced`). Still allow further specifying which id manually for multiple-room flags.

Input handling
	handle player inputs:
		movement keys
		mouse controls for clicking on objects in room
		unlockable ability keys (eg. flip, go the special anomaly version of a room)

Inventory System
	hold items
	provide info about items through UI
	give option to use items

Dialogue triggers
	trigger dialogue from the character when the player does:
		moves into a certain area
		attempts to use an item
		triggers a global flag for the first time
		?? possibly more

Zoom out feature
	provided a zoom out low-detail view of the room and surrounding 8 rooms
		borders around rooms as described in the GDD
		arrange rooms on screen as to match the flip-state of the room connections

Cutscene system
	play a simple animation using the character and a given object
		used for player fighting anomalies animation
		disable player controls while cutscene is playing

In-Game UI
	keep track of total player progress somehow?

Main Menu
	allow player to go back/forth from main menu with a simple keypress
		button to start/continue game (returns player to same position and same global flags)
		button to reset save
		settings page
			volume controls
				master volume
				sfx volume
				music volume
			fullscreen controls
			speedrun mode toggle (shows timer on screen at all times, not just on end screen)

Audio system
	loop music, select track depending on rooms completed, fade between tracks
	allow other systems to play sfx