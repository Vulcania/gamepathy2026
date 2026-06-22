extends CharacterBody2D
class_name Player

var in_safe_room = true
var pause_menu_open = false

# movement
@export var base_speed: float = 300.0
@export var run_speed_factor: float = 1.67
@export var jump_speed_factor: float = -4
@export var gravity_speed_factor: float = 4
@export var acceleration: float = 20.0
@export var friction: float = 50.0

# dash
@export var dash_speed_factor: float = 4
@export var boost_duration: float = 0.2
@export var boost_cooldown: float = 1
@export var slide_speed_factor = 2.5
@export var slide_friction_factor = 0.25

# names
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

# input actions
var move_input: float = 0.0
var is_running: bool = false
var is_ducking: bool = false
var is_ducking_just_pressed:bool = false
var is_blocking: bool = false
var is_jumping: bool = false
var is_attacking: bool = false
var gravity_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

# dash
var boost_time_left: float = 0.0
var boost_cooldown_left: float = 0.0
var dash_direction:float = 1.0

enum State { IDLE, WALK, RUN, JUMP, FALL, DUCK, SLIDE, BLOCK, DASH, BRAKING, ATTACK }

var current_state: State = State.IDLE

var hit = false

signal state_updated(state:State)

func _on_ready():
	hit = false

func _physics_process(delta: float) -> void:
	move_input = Input.get_axis("move_left", "move_right")
	is_running = Input.is_action_pressed("run")
	is_ducking = Input.is_action_pressed("duck")
	is_ducking_just_pressed = Input.is_action_just_pressed("duck")
	is_blocking = Input.is_action_pressed("block")
	is_jumping = Input.is_action_pressed("jump")
	is_attacking = Input.is_action_pressed("attack")
	
	_update_state()
	flip()
		
	if current_state != State.DASH and boost_cooldown_left > 0:
		boost_cooldown_left = boost_cooldown_left - delta
	
	_apply_movement(delta)

func flip():
	if Input.is_action_pressed("move_left"):
		if !hit:
			sprite.scale.x = abs(sprite.scale.x) * -1
			$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
			$PlayerHitbox.scale.x = abs($PlayerHitbox.scale.x) * -1
			$MonitorArea.scale.x = abs($MonitorArea.scale.x) * -1
	if Input.is_action_pressed("move_right"):
		if !hit:
			sprite.scale.x = abs(sprite.scale.x) * 1
			$AttackArea.scale.x = abs($AttackArea.scale.x) * 1
			$PlayerHitbox.scale.x = abs($PlayerHitbox.scale.x) * 1
			$MonitorArea.scale.x = abs($MonitorArea.scale.x) * 1

func _update_state()->void:
	var previous_state = current_state
	current_state = _get_state()
	if previous_state != current_state:
		state_updated.emit(current_state)
		_update_animation()


func _get_state() -> State:
	if current_state == State.DASH and boost_time_left >= 0:
		return State.DASH
	if not is_on_floor():
		if is_blocking:
			return State.BLOCK
		return State.JUMP if velocity.y < 0 else State.FALL
	if is_jumping:
		return State.JUMP
	if is_blocking and is_running and move_input != 0.0 and not current_state == State.DASH and boost_cooldown_left <= 0.0:
		boost_time_left = boost_duration
		dash_direction = sign(move_input) if move_input != 0.0 else 1.0
		return State.DASH
	if is_ducking and is_running and move_input != 0.0:
		if is_ducking_just_pressed:
			boost_time_left = boost_duration
		return State.SLIDE
	if is_blocking:
		return State.BLOCK
	if is_ducking:
		return State.DUCK
	if sign(move_input) != sign(velocity.x):
		return State.BRAKING
	if is_running and move_input != 0.0:
		return State.RUN
	if move_input != 0.0:
		return State.WALK
	if is_attacking:
		return State.ATTACK
	return State.IDLE


func _update_animation()->void:
	rotation = 0
	match current_state:
		State.IDLE:
			animation.play("Idle")
			return
		State.WALK:
			animation.play("Run")
			return
		State.RUN:
			animation.play("Run")
			return
		State.JUMP:
			animation.play("Jump")
			return
		State.FALL:
			animation.play("Fall")
			return
		State.BLOCK:
			animation.play("Block")
			return
		#State.DUCK:
			#animation.play()
			#return
		#State.SLIDE:
			#animation.play()
			#return
		#State.BRAKING:
			#animation.play()
			#return
		State.DASH:
			animation.play("Dash")
			return
		State.ATTACK:
			animation.play("Attack")
			return

func _apply_movement(delta:float) -> void:
	var target_speed: float
	if not is_on_floor():
		velocity.y += gravity_vector.y * base_speed * gravity_speed_factor * delta
	match current_state:
		State.IDLE, State.BLOCK, State.DUCK:
			target_speed = 0.0
			velocity.x = move_toward(velocity.x, target_speed, friction)
		State.BRAKING:
			target_speed = move_input * base_speed
			velocity.x = move_toward(velocity.x, target_speed, friction)
		State.WALK:
			target_speed = move_input * base_speed
			velocity.x = move_toward(velocity.x, target_speed, acceleration)
		State.RUN:
			target_speed = move_input * base_speed * run_speed_factor
			velocity.x = move_toward(velocity.x, target_speed, acceleration)
		#State.SLIDE:
		#	if boost_time_left > 0:
		#		target_speed = move_input * base_speed * slide_speed_factor
		#		velocity.x = move_toward(velocity.x, target_speed, acceleration)
		#	else:
		#		target_speed = 0.0
		#		velocity.x = move_toward(velocity.x, target_speed, friction*slide_friction_factor)
		#	boost_time_left -= delta
		#	if boost_time_left <= 0.0:
		#		boost_cooldown_left = boost_cooldown
		State.JUMP:
			if is_on_floor():
				velocity.y = base_speed * jump_speed_factor
			target_speed = move_input * base_speed
			velocity.x = move_toward(velocity.x, target_speed, acceleration)
		State.DASH:
			velocity.x = dash_direction * base_speed * dash_speed_factor
			boost_time_left -= delta
			if boost_time_left <= 0.0:
				boost_cooldown_left = boost_cooldown
		
	move_and_slide()
	
	for collision_index in range(get_slide_collision_count()):
		var collider = get_slide_collision(collision_index).get_collider()
		if collider is RigidBody2D:
			var yeet_direction = Vector2(move_input, -abs(move_input)) * slide_speed_factor
			print('YEET: %s' % yeet_direction)
			collider.apply_central_impulse(yeet_direction)

func die():
	animation.play("Dead")

func return_to_foyer():
	pass

func open_pause():
	if Input.is_action_just_pressed("pause"):
		$HUD/PauseMenu.visible = true
		pause_menu_open = true
		$HUD/TimerOptions/Timer.paused = true
	if not $HUD/PauseMenu.visible:
		pause_menu_open = false
		$HUD/TimerOptions/Timer.paused = false

func entered_safe_room():
	in_safe_room = true
	$HUD/TimerOptions/Timer.paused = true

func start_timer_in_level_one():
	if not in_safe_room:
		$HUD/TimerOptions/Timer.start()
		$HUD/TimerOptions/Timer.paused = false
