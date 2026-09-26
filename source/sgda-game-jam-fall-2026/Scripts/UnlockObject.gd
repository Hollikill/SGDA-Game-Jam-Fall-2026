extends Node

@export var unlock_flag_id: String = "";
@export var only_disable_collision: bool = false;

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if GlobalPersistant.hasFlag(unlock_flag_id):
		var collision_areas = find_children("*", "StaticBody2D", true, false)
		for area in collision_areas:
			area.queue_free()

		if (!only_disable_collision):
			queue_free()