extends CharacterBody2D

@export var MovementSpeed: float = 100;
@onready var Sprite: Sprite2D = get_node("Player Sprite");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# handle player movement input
	var direction: Vector2 = Input.get_vector("game_left", "game_right", "game_up", "game_down")
	var motion: Vector2 = direction * MovementSpeed * delta;
	move_and_collide(motion)
	
	# prevent from exiting the borders of the screen
	var sprite_size = Sprite.texture.get_size()/2;
	if (global_position.x - sprite_size.x < 0):
		global_position.x = 0 + sprite_size.x
	if (global_position.y - sprite_size.y < 0):
		global_position.y = 0 + sprite_size.y
	if (global_position.x + sprite_size.x > GlobalPersistant.screen_size.x):
		global_position.x = GlobalPersistant.screen_size.x - sprite_size.x
	if (global_position.y + sprite_size.y > GlobalPersistant.screen_size.y):
		global_position.y = GlobalPersistant.screen_size.y - sprite_size.y

func off_screen_side():
	var sprite_size = Sprite.texture.get_size()/2;
	if (global_position.x - sprite_size.x <= 0):
		return "left"
	if (global_position.y - sprite_size.y <= 0):
		return "top"
	if (global_position.x + sprite_size.x >= GlobalPersistant.screen_size.x):
		return "right"
	if (global_position.y + sprite_size.y >= GlobalPersistant.screen_size.y):
		return "bottom"
	return "none"
