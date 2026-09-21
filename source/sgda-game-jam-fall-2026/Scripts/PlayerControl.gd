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
var walkPhase = 1
var animPlaying = false
var walkDirection: Vector2

var direction: Vector2
var interpVal = 0.1

var sprite_size = Vector2(300/(2*SpriteScale), 300/(2*SpriteScale))

func endAnim(): 
	animPlaying = false

func walking(): 
	if(isLowPriorityAnim(Sprite.animation) == 1): 
		return true
	return false

func isLowPriorityAnim(anim: String): 
	if(anim == "idleleft" or anim == "idleright"): 
		return 2
	if(anim == "walkleft1" or anim == "walkleft2" or anim == "walkright1" or anim == "walkright2"): 
		return 1
	return 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sprite.scale = Vector2(1/SpriteScale, 1/SpriteScale)
	Sprite.animation_finished.connect(endAnim)
	add_to_group("player")

func playAnimation(anim: String): 
	var anim_old = anim
	if(facingLeft): 
		anim = anim + "left"
	else: 
		anim = anim + "right"
	if(animPlaying and Sprite.animation == anim): 
		return
	if(animPlaying and anim_old == "walk" and (Sprite.animation == anim + "1" or Sprite.animation == anim + "2")): 
		return
	if(anim_old == "walk"): 
		anim = anim + str(walkPhase)
	if(animPlaying and isLowPriorityAnim(anim) > isLowPriorityAnim(Sprite.animation)): 
		return
	var current_base_anim = Sprite.animation
	current_base_anim = current_base_anim.replace("left", "").replace("right", "").replace("1", "").replace("2", "")
	var is_linked_variant = (current_base_anim == anim_old)
	if anim_old == "walk" and current_base_anim == "walk" and Sprite.animation != anim:
		var current_is_left = "left" in Sprite.animation
		if current_is_left == facingLeft:
			is_linked_variant = false
	var saved_frame = 0
	var saved_progress = 0.0
	if is_linked_variant:
		saved_frame = Sprite.frame
		saved_progress = Sprite.frame_progress
	var is_new_animation = (Sprite.animation != anim)
	Sprite.play(anim)
	animPlaying = true
	if is_linked_variant:
		var max_frames = Sprite.sprite_frames.get_frame_count(anim)
		Sprite.frame = clampi(saved_frame, 0, max_frames - 1)
		Sprite.frame_progress = saved_progress
	if(anim_old == "walk" and is_new_animation):
		if(walkPhase == 1):
			walkPhase = 2
		else:
			walkPhase = 1

func setupPathfinding(callback: Callable, target: Node2D) -> void: 
	pathfinding = true
	onReachFunc = callback
	pathfindTarget = target

func pathfind(delta: float): 
	playAnimation("walk")
	direction = (pathfindTarget.global_position - global_position).normalized() * interpVal + direction * (1-interpVal)
	if(!direction.is_zero_approx()):
		if(direction.x > 0): 
			facingLeft = false
		elif(direction.x < 0): 
			facingLeft = true
		walkDirection = direction
	velocity = direction * MovementSpeed
	var pos_before_move = global_position
	if (pathfindTarget.global_position.distance_to(global_position) <= toleranceDistance):
		pathfinding = false
		timeStuck = 0
		onReachFunc.call()
		playAnimation("find")
		return
	move_and_slide()
	var distance_moved = pos_before_move.distance_to(global_position)
	if distance_moved < (MovementSpeed * delta) * 0.5:
		timeStuck += delta
	else:
		timeStuck = 0.0
	if(timeStuck > patience): 
		if(pathfindTarget.global_position.distance_to(global_position) > toleranceDistance): 
			pathfinding = false
			playAnimation("stuck")
			timeStuck = 0
		else: 
			pathfinding = false
			timeStuck = 0
			onReachFunc.call()
			playAnimation("find")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# handle player movement input
	var rawDirection = Input.get_vector("game_left", "game_right", "game_up", "game_down")
	if(isLowPriorityAnim(Sprite.animation)): 
		direction = rawDirection * interpVal + direction * (1-interpVal)
	else: 
		direction = direction * (1-interpVal)
	if(pathfinding): 
		pathfind(delta)
	else: 
		if(!rawDirection.is_zero_approx()): 
			walkDirection = direction
			velocity = direction * MovementSpeed
		elif(walking()): 
			velocity = walkDirection * MovementSpeed
			walkDirection = walkDirection
		else: 
			velocity = direction * MovementSpeed
		move_and_slide()
	if(!rawDirection.is_zero_approx()):
		if(velocity.x > 0): 
			facingLeft = false
		elif(velocity.x < 0): 
			facingLeft = true
		playAnimation("walk")
	else: 
		playAnimation("idle")
	
	# prevent from exiting the borders of the screen
	if (global_position.x - sprite_size.x < 0):
		global_position.x = 0 + sprite_size.x
	if (global_position.y - sprite_size.y < 0):
		global_position.y = 0 + sprite_size.y
	if (global_position.x + sprite_size.x > GlobalPersistant.screen_size.x):
		global_position.x = GlobalPersistant.screen_size.x - sprite_size.x
	if (global_position.y + sprite_size.y > GlobalPersistant.screen_size.y):
		global_position.y = GlobalPersistant.screen_size.y - sprite_size.y
	

func off_screen_side():
	if (global_position.x - sprite_size.x <= 0):
		return "left"
	if (global_position.y - sprite_size.y <= 0):
		return "top"
	if (global_position.x + sprite_size.x >= GlobalPersistant.screen_size.x):
		return "right"
	if (global_position.y + sprite_size.y >= GlobalPersistant.screen_size.y):
		return "bottom"
	return "none"
