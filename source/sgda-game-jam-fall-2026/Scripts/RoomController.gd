extends Node

@export var room_id: String = "";
@export var top: EntranceMethod
@export var bottom: EntranceMethod
@export var left: EntranceMethod
@export var right: EntranceMethod
@export var topleft: EntranceMethod
@export var topright: EntranceMethod
@export var bottomleft: EntranceMethod
@export var bottomright: EntranceMethod

var entrancesIDs: Array[String] = []

@onready var background: Sprite2D = $Background

var player_scene = preload("res://Prefabs/MainCharacter.tscn");
var player = null;

const room_enter_margin = 65;

var popup_layer: CanvasLayer
var popup_textures: Array[TextureRect] = []
var is_popup_open: bool = false

func _ready() -> void:
	GlobalPersistant.current_loaded_room = room_id;
	
	entrancesIDs = ["", "", "", "", room_id, "", "", "", ""]
	if(topleft != null): 
		entrancesIDs[0] = topleft.room_id
	if(top != null): 
		entrancesIDs[1] = top.room_id
	if(topright != null): 
		entrancesIDs[2] = topright.room_id
	if(left != null):  
		entrancesIDs[3] = left.room_id
	if(right != null): 
		entrancesIDs[5] = right.room_id
	if(bottomleft != null): 
		entrancesIDs[6] = bottomleft.room_id
	if(bottom != null): 
		entrancesIDs[7]= bottom.room_id
	if(bottomright != null): 
		entrancesIDs[8] = bottomright.room_id
	
	popup_layer = CanvasLayer.new();	
	add_child(popup_layer);
	popup_layer.visible = false;
	var grid = GridContainer.new()
	grid.columns = 3
	grid.size = GlobalPersistant.screen_size
	popup_layer.add_child(grid)
	for i in range(1, 10): 
		var tex = TextureRect.new()
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tex.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tex.visible = true
		grid.add_child(tex)
		popup_textures.append(tex)

	player = player_scene.instantiate();
	add_child(player)
	player.global_position = GlobalPersistant.scene_transition_info.player_position;
	
	load_room_background()
	
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

func load_room_background() -> void:
	var path: String = "res://Resources/Rooms/%s.png" % room_id
	
	if ResourceLoader.exists(path):
		background.texture = load(path)
	else:
		push_error("RoomController Error: Background image missing at " + path)

func toggle_popup() -> void:
	is_popup_open = !is_popup_open
	popup_layer.visible = is_popup_open
	
	if is_popup_open:
		set_process(false)
		player.set_physics_process(false)
		player.set_process(false)
		
		for i in range(9):
			var slot = popup_textures[i];
			if entrancesIDs[i] != "":
				var path = "res://Resources/Rooms/"+entrancesIDs[i]+".png"
				var img = load(path)
				slot.texture = img
			else:
				slot.texture = null
	else:
		set_process(true)
		player.set_physics_process(true)
		player.set_process(true)

func _process(_delta: float) -> void:
	if (player.off_screen_side() == "left" && left != null):
		_switch_room(left)
	if (player.off_screen_side() == "top" && top != null):
		_switch_room(top)
	if (player.off_screen_side() == "right" && right != null):
		_switch_room(right)
	if (player.off_screen_side() == "bottom" && bottom != null):
		_switch_room(bottom)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_M:
			toggle_popup()

func _switch_room(entrance_method: EntranceMethod):
	GlobalPersistant.scene_transition_info.player_position = player.global_position;
	GlobalPersistant.scene_transition_info.entrance_side = entrance_method.enter_side;
	GlobalPersistant.scene_transition_info.version_id = entrance_method.version_id;
	get_tree().change_scene_to_file("Scenes/Rooms/"+entrance_method.room_id+".tscn");
