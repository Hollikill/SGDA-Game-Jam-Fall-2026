extends Sprite2D

@export var min_transparency: float = 0.3;
var seconds_to_fade: float = 0.2;

var player: CharacterBody2D = null;

func _process(delta: float) -> void:
	if (player == null):
		player = get_tree().get_first_node_in_group("player");
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
