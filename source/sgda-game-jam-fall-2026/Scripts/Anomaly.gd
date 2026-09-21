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

func complete_anamoly(): 
	GlobalPersistant.complete_anomaly();
	get_parent().queue_free()

func _process(_delta: float) -> void:
	if mouse_on and Input.is_action_just_pressed("game_attack"):
		var player = get_tree().get_first_node_in_group("player")
		player.setupPathfinding(get_global_mouse_position(), complete_anamoly)
