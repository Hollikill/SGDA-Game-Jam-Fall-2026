extends Area2D

var mouse_on = false;

func _ready():
	input_pickable = true
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)

func _on_mouse_enter():
	mouse_on = true;

func _on_mouse_exit():
	mouse_on = false;

func _process(delta: float) -> void:
	if mouse_on and Input.is_action_just_pressed("game_attack"):
		GlobalPersistant.complete_anomaly();
		get_parent().queue_free()
