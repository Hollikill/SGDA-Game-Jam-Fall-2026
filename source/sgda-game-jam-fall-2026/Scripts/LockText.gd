extends Node

@export var unlock_flag_id: String = "";
@export var only_disable_collision: bool = false;
@export_group("Alternate Unlock Criteria")
@export var unlock_via_flag_count: bool = false;
@export var unlock_flag_count_required: int = -1;
@export_group("Label Target")
@export var label: Label

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.add_theme_color_override("font_color", Color.RED)

func _process(delta: float) -> void:
	if (GlobalPersistant.hasFlag(unlock_flag_id) || (unlock_via_flag_count && GlobalPersistant.flags.size() >= unlock_flag_count_required)):
		label.visible = false
	else: 
		label.text = str(GlobalPersistant.flags.size()) + "/" + str(unlock_via_flag_count)
