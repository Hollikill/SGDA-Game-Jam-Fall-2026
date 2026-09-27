<<<<<<< HEAD
extends Label
=======
extends RichTextLabel
>>>>>>> 3c5989004360fcc41fc0fb34bb9c29177dab21d7

@export var unlock_flag_count_required: int = -1;
<<<<<<< HEAD
@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_theme_color_override("font_color", Color.RED)

func _process(delta: float) -> void:
	if (GlobalPersistant.hasFlag(unlock_flag_id) || (unlock_via_flag_count && GlobalPersistant.flags.size() >= unlock_flag_count_required)):
		visible = false
	else: 
		text = str(GlobalPersistant.flags.size()) + "/" + str(unlock_via_flag_count)
=======
@export var text_color: String = "f44";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add_theme_color_override("font_color", Color.RED)
	bbcode_enabled = true;

func _process(delta: float) -> void:
	if (GlobalPersistant.flags.size() >= unlock_flag_count_required):
		visible = false
	else: 
		text = "[color=#"+text_color+"]" + str(GlobalPersistant.flags.size()) + "/" + str(unlock_flag_count_required) + "[/color]"
>>>>>>> 3c5989004360fcc41fc0fb34bb9c29177dab21d7
