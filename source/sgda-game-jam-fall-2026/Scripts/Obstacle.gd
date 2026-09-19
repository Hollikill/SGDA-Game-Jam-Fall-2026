extends Sprite2D

@export var min_transparency: float = 0.3;
var seconds_to_fade: float = 0.2;

var player: CharacterBody2D = null;

var mouse_on = false;

var base_texture_scale;
var base_texture_rotation;
var sprite_scale_offset = 1;

func _ready():
	var collision_areas = find_children("*", "Area2D", true, false)
	for area in collision_areas:
		area.input_pickable = true
		area.mouse_entered.connect(_on_mouse_enter)
		area.mouse_exited.connect(_on_mouse_exit)
	base_texture_scale = scale;
	base_texture_rotation = rotation;
	sprite_scale_offset = max((texture.get_size().x + texture.get_size().y)/80,1);

func _on_mouse_enter():
	mouse_on = true;
	print("obstacle enter")
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", base_texture_scale * (1 + (.05/sprite_scale_offset)), 0.15)
	tween.tween_property(self, "rotation", base_texture_rotation + deg_to_rad(5/sprite_scale_offset), 0.15)

func _on_mouse_exit():
	mouse_on = false;
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", base_texture_scale, 0.15)
	tween.tween_property(self, "rotation", base_texture_rotation, 0.15)

func _process(delta: float) -> void:
	if (player == null):
		player = get_tree().get_first_node_in_group("player");
	# fade when player in front
	else: if (z_index > player.z_index):
		var collision_areas = find_children("*", "Area2D", true, false)
		var behind_obstacle = false
		for area in collision_areas:
			if area.overlaps_body(player):
				behind_obstacle = true;
		if behind_obstacle:
			modulate.a = max(modulate.a-(((1-min_transparency)/seconds_to_fade)*delta), min_transparency)
		else:
			modulate.a = min(modulate.a+(((1-min_transparency)/seconds_to_fade)*delta), 1)
