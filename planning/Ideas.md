# Ideas

## ANOMALY GAUNTLET

anomaly gauntlet, where tens of anomaly variations of a room are created in development, but a person only sees 4-5 in the normal course of completing a room. However, the last anomaly is a non-random variation which is more obvious. Fighting this anomaly will launch you into a bunch of variations of the room in a row, where you fight a timer in order to kill all the anomalies.

Serves purpose:

1. proves player actually paid attention to what is the normal level and what is not, and didn't just hit everything
2. provides a small test of mechanical skill to add variation to the game loop
3. provides tension and challenge to prevent walking-simulator type gameplay

Feature notes:

1. player quick attack to find anomalies should have some sort of cooldown (ie the player is slowed briefly and cannot attack for short time ~1.5 seconds) to prevent click spam to find anomaly
2. anomalies should be subtle in form, maybe only a slight different object, and their true wildy different form (eg. different colors, artstyle, drastically differnet shape) should only be revealed in a dramatic hitstop-pause as the attack completes
3. time limits get quicker as the gauntlet proceeds
4. the alt-versions of the room that the player is left with not in the gauntlet should shuffle each time it runs and fails

Variations to prevent players from just looking at what changed:

1. possibly pull in variations of surrounding rooms as well, eg. 1 room will also have a couple of alt-neighbor rooms in the gauntlet as well
2. add effects to the screen such as flipping/mirroring/rotating the camera, shifting the color palette, or adding a (looping) slide effect to the camera

## NORMAL ROOM SHUFFLING

the normal room should not necessarially be the first instance of a room the player sees. Might be better to randomly arrange it among the variations so players receive less meta-game information about whether to search a room

## WALKING BEHIND OBJECTS

add a component for dithering and making an object transparent when a player walks into an area where the sprite covers them, but they are not blocked by a collision box.

Serves purpose:

1. allows for more freedom in room creation
2. allows for better hiding of anomalies

## HIGHLIGHTED OBJECT TWEEN

when the player mouses over an object (ie. clicking would interact with it) play a small rotate and enlarge animation.

Serves purpose:

1. signals to the player which object is selected if multiple are close
2. makes second-to-second game loop feel more interactive
3. leaves room for hiding extra hard to find anomalies, by playing different sound cues when a hidden anomaly is moused over

## LIMITED ANOMALY FINDING

Player attack to find anomalies should be limited to prevent spamming or circumvention of the difficulty of the game. Player should not be able to attack anomalies that are too far away from them in the room. Player quick attack to find anomalies should have some sort of cooldown (ie the player is slowed briefly and cannot attack for short time ~1.5 seconds) to prevent click spam to find anomaly. Anomalies should be subtle in form, maybe only a slight different object, and their true wildy different form (eg. different colors, artstyle, drastically differnet shape) should only be revealed in a dramatic hitstop-pause as the attack completes.

Serves Purpose:

1. Allows re-use of rooms by gating certain areas behind accessing a room from another side. Players love backtracking!
2. Keeps the main game loop challenging for the player, encouraging them to look and memorize details more than just spam attacks
