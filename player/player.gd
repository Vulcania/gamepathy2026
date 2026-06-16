extends CharacterBody2D


# movement
@export var base_speed: float = 300.0
@export var run_speed_factor: float = 1.67
@export var jump_speed_factor: float = -2
@export var gravity_speed_factor: float = 4
@export var acceleration: float = 10.0
@export var friction: float = 30.0

# dash
@export var dash_speed_factor: float = 2.67
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.5

@export var slide_friction_factor = 0.33 


# input actions
var move_input: float = 0.0
var is_running: bool = false
var is_ducking: bool = false
var is_blocking: bool = false
var is_jumping: bool = false
var gravity_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

# dash

var dash_time_left: float = 0.0
var dash_cooldown_left: float = 0.0
var dash_direction:float = 1.0

enum State { IDLE, WALK, RUN, JUMP, FALL, DUCK, SLIDE, BLOCK, DASH }

var current_state: State = State.IDLE

func _physics_process(delta: float) -> void:
	move_input = Input.get_axis("move_left", "move_right")
	is_running = Input.is_action_pressed("run")
	is_ducking = Input.is_action_pressed("duck")
	is_blocking = Input.is_action_pressed("block")
	is_jumping = Input.is_action_pressed("jump")
	
	_update_state()
	
	if current_state != State.DASH and dash_cooldown_left > 0:
		dash_cooldown_left = dash_cooldown_left - delta
	
	_apply_movement(delta)


func _update_state() -> void:
	if current_state == State.DASH and dash_time_left >= 0:
		return
	if not is_on_floor():
		if is_blocking:
			current_state = State.BLOCK
			return
		current_state = State.JUMP if velocity.y < 0 else State.FALL
		return
	if is_jumping:
		current_state = State.JUMP
		return
	if is_blocking and is_running and move_input != 0.0 and not current_state == State.DASH and dash_cooldown_left <= 0.0:
		dash_time_left = dash_duration
		dash_direction = sign(move_input) if move_input != 0.0 else 1.0
		current_state = State.DASH
		return
	if is_ducking and is_running and move_input != 0.0:
		current_state = State.SLIDE
		return
	if is_blocking:
		current_state = State.BLOCK
		return
	if is_ducking:
		current_state = State.DUCK
		return
	if is_running and move_input != 0.0:
		current_state = State.RUN
		return
	if move_input != 0.0:
		current_state = State.WALK
		return
	current_state = State.IDLE
		
func _apply_movement(delta:float) -> void:
	var target_speed: float
	if not is_on_floor():
		velocity.y += gravity_vector.y * base_speed * gravity_speed_factor * delta
	match current_state:
		State.IDLE, State.BLOCK, State.DUCK:
			target_speed = 0.0
			velocity.x = move_toward(velocity.x, target_speed, friction)
		State.WALK:
			target_speed = move_input * base_speed
			velocity.x = move_toward(velocity.x, target_speed, acceleration)
		State.RUN:
			target_speed = move_input * base_speed * run_speed_factor
			velocity.x = move_toward(velocity.x, target_speed, acceleration)
		State.SLIDE:
			target_speed = 0.0
			velocity.x = move_toward(velocity.x, target_speed, friction*slide_friction_factor)
		State.JUMP:
			if is_on_floor():
				velocity.y = base_speed * jump_speed_factor
			velocity.x = move_input * base_speed
		State.DASH:
			velocity.x = dash_direction * base_speed * dash_speed_factor
			dash_time_left -= delta
			if dash_time_left <= 0.0:
				dash_cooldown_left = dash_cooldown
		
	move_and_slide()
		
