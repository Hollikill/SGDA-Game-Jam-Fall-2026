extends CharacterBody2D

@export
var MovementSpeed: float = 100;
@export
var Sprite: Sprite2D = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# handle player movement input
	var direction: Vector2 = Input.get_vector("game_left", "game_right", "game_up", "game_down")
	var motion: Vector2 = direction * MovementSpeed * delta;
	print(motion)
	move_and_collide(motion)
	
	# TODO: prevent from exiting the borders of the screen
