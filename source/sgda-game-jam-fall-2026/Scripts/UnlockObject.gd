extends Node

@export var unlock_flag_id: String = "";
@export var only_disable_collision: bool = false;
@export_group("Alternate Unlock Criteria")
@export var unlock_via_flag_count: bool = false;
@export var unlock_flag_count_required: int = -1;

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if (GlobalPersistant.hasFlag(unlock_flag_id) || (unlock_via_flag_count && GlobalPersistant.flags.size() >= unlock_flag_count_required)):
		var collision_areas = find_children("*", "StaticBody2D", true, false)
		for area in collision_areas:
			area.queue_free()

		if (!only_disable_collision):
			queue_free()
