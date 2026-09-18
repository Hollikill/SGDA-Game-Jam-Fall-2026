extends Node

@export var top: EntranceMethod
@export var bottom: EntranceMethod
@export var left: EntranceMethod
@export var right: EntranceMethod

var player_scene = preload("res://Prefabs/MainCharacter.tscn");
var player = null;

const room_enter_margin = 65;

func _ready() -> void:
	player = player_scene.instantiate();
	add_child(player)
	player.global_position = GlobalPersistant.scene_transition_info.player_position;
	match GlobalPersistant.scene_transition_info.entrance_side:
		GlobalPersistant.EnterSide.LEFT:
			player.global_position.x = room_enter_margin;
		GlobalPersistant.EnterSide.RIGHT:
			player.global_position.x = GlobalPersistant.screen_size.x - room_enter_margin;
		GlobalPersistant.EnterSide.TOP:
			player.global_position.y = room_enter_margin;
		GlobalPersistant.EnterSide.BOTTOM:
			player.global_position.y = GlobalPersistant.screen_size.y - room_enter_margin;
		GlobalPersistant.EnterSide.CENTER:
			player.global_position = Vector2(GlobalPersistant.screen_size.x / 2, GlobalPersistant.screen_size.y / 2);
		_:
			pass

func _process(_delta: float) -> void:
	if (player.off_screen_side() == "left" && left != null):
		_switch_room(left)
	if (player.off_screen_side() == "top" && top != null):
		_switch_room(top)
	if (player.off_screen_side() == "right" && right != null):
		_switch_room(right)
	if (player.off_screen_side() == "bottom" && bottom != null):
		_switch_room(bottom)

func _switch_room(entrance_method: EntranceMethod):
	GlobalPersistant.scene_transition_info.player_position = player.global_position;
	GlobalPersistant.scene_transition_info.entrance_side = entrance_method.enter_side;
	GlobalPersistant.scene_transition_info.version_id = entrance_method.version;
	get_tree().change_scene_to_file("Scenes/Rooms/"+entrance_method.id+".tscn");
