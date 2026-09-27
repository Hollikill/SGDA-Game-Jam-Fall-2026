extends RichTextLabel

@export var unlock_flag_count_required: int = -1;
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
