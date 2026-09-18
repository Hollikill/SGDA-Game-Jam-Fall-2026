class_name AnomalyVersion
extends Node

@export var anomaly_version = -1;
@export var is_normal = true;

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ((GlobalPersistant.scene_transition_info.version_id == anomaly_version) == is_normal):
		parent.queue_free()
