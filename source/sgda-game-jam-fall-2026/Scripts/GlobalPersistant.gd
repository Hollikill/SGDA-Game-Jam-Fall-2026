extends Node

enum EnterSide {LEFT, RIGHT, TOP, BOTTOM, CENTER}

const screen_size = Vector2i(1280,720)

var scene_transition_info = {
	entrance_side = EnterSide.CENTER,
	version_id = 0,
	player_position = Vector2(0,0),
}
