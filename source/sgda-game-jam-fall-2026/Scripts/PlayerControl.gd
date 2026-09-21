extends CharacterBody2D

@export var MovementSpeed: float = 100;
@export var SpriteScale: float = 2.5;
@onready var Sprite: AnimatedSprite2D = get_node("PlayerSprite");

var pathfinding = false
var lastLocation: Vector2
var timeStuck = 0
var patience = 3
var distanceToFind = 50
var toleranceDistance = 150
var onReachFunc: Callable = func(): pass
var proximityRay: RayCast2D
var pathfindTarget

var facingLeft = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sprite.scale = Vector2(1/SpriteScale, 1/SpriteScale)
	add_to_group("player")

func playAnimation(anim: String): 
	if(anim == "idle" or anim == "walk"): 
		if(facingLeft): 
			anim = anim + "left"
		else: 
			anim = anim + "right"
	if(Sprite.animation == "stuck" or Sprite.animation == anim): 
		return
	Sprite.play(anim)

func setupPathfinding(callback: Callable, target: Node2D) -> void: 
	pathfinding = true
	onReachFunc = callback
	pathfindTarget = target

func pathfind(delta: float): 
	var direction = (pathfindTarget.global_position - global_position).normalized() 
	velocity = direction * MovementSpeed
	var pos_before_move = global_position
	if (pathfindTarget.global_position.distance_to(global_position) <= toleranceDistance):
		pathfinding = false
		timeStuck = 0
		onReachFunc.call()
		return
	move_and_slide()
	var distance_moved = pos_before_move.distance_to(global_position)
	if distance_moved < (MovementSpeed * delta) * 0.5:
		timeStuck += delta
	else:
		timeStuck = 0.0
	if(timeStuck > 0.5): 
		if(pathfindTarget.global_position.distance_to(global_position) > toleranceDistance): 
			pathfinding = false
			playAnimation("stuck")
		else: 
			pathfinding = false
			timeStuck = 0
			onReachFunc.call()
			return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# handle player movement input
	if(pathfinding): 
		pathfind(delta)
	else: 
		var direction: Vector2 = Input.get_vector("game_left", "game_right", "game_up", "game_down")
		var motion: Vector2 = direction * MovementSpeed;
		velocity = motion;
		move_and_slide()
	if(velocity.length() > 0):
		if(velocity.x > 0): 
			facingLeft = false
		elif(velocity.x < 0): 
			facingLeft = true
		playAnimation("walk")
	if 1:#This should be an else, but I am changing this to if 1 as walk animations dont exist yet 
		playAnimation("idle")
	
	# prevent from exiting the borders of the screen
	var sprite_size = Sprite.sprite_frames.get_frame_texture(Sprite.animation, Sprite.frame).get_size()/(2*SpriteScale);
	if (global_position.x - sprite_size.x < 0):
		global_position.x = 0 + sprite_size.x
	if (global_position.y - sprite_size.y < 0):
		global_position.y = 0 + sprite_size.y
	if (global_position.x + sprite_size.x > GlobalPersistant.screen_size.x):
		global_position.x = GlobalPersistant.screen_size.x - sprite_size.x
	if (global_position.y + sprite_size.y > GlobalPersistant.screen_size.y):
		global_position.y = GlobalPersistant.screen_size.y - sprite_size.y
	

func off_screen_side():
	var sprite_size = Sprite.sprite_frames.get_frame_texture(Sprite.animation, Sprite.frame).get_size()/(2*SpriteScale);
	if (global_position.x - sprite_size.x <= 0):
		return "left"
	if (global_position.y - sprite_size.y <= 0):
		return "top"
	if (global_position.x + sprite_size.x >= GlobalPersistant.screen_size.x):
		return "right"
	if (global_position.y + sprite_size.y >= GlobalPersistant.screen_size.y):
		return "bottom"
	return "none"
