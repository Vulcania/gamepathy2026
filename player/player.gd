extends CharacterBody2D
class_name Player

var in_safe_room = true
var pause_menu_open = false
var can_move = true
var next_attack = false

@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")

# movement
@export var base_speed: float = 300.0
@export var run_speed_factor: float = 1.67
@export var speed_buff_factor: float = 1
@export var jump_height = -1350
@export var gravity = 1200
@export var acceleration: float = 20.0
@export var friction: float = 50.0

# dash
@export var dash_speed_factor: float = 4
@export var boost_duration: float = 0.2
@export var boost_cooldown: float = 1
@export var slide_speed_factor = 2.5
@export var slide_friction_factor = 0.25

#block
@export var max_block_count = 3
@export var current_block_count = 3
var coffee_refilling = false

# names
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hearts_container = $HUD/HeartsContainer
@onready var block_container = $HUD/BlocksContainer
@onready var player_hitbox: HitBox = $HitBox
@onready var health_component: HealthComponent = $HealthComponent

@export var attack_cooldown: Timer

# handlers
@onready var input_handler: InputHandler = $Handlers/InputHandler
@onready var flip_handler: FlipHandler = $Handlers/FlipHandler
@onready var jump_handler: JumpHandler = $Handlers/JumpHandler

@export var decelerate_on_jump_release : float = 0.0

# input actions
var move_input: Vector2 = Vector2.ZERO
var is_running: bool = false
var is_ducking: bool = false
var is_ducking_just_pressed: bool = false
var is_blocking: bool = false
var is_jumping: bool = false
var is_jump_released : bool = false
var is_attacking: bool = false
var is_interacting: bool = false
var gravity_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

# dash
var boost_time_left: float = 0.0
var boost_cooldown_left: float = 0.0
var dash_direction:float = 1.0

enum State { IDLE, WALK, RUN, JUMP, FALL, DUCK, SLIDE, BLOCK, DASH, BRAKING, ATTACK, INTERACTING }

var current_state: State = State.IDLE

var hit = false

signal state_updated(state:State)

func _ready() -> void:
	hearts_container.set_max_hearts(health_component.max_health)
	block_container.set_max_blocks(max_block_count)
#	BuffSelectionOne.option_one.connect(_on_option_1)
#	BuffSelectionOne.option_one.connect(_on_option_2)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Global.global_refill_coffee.connect(_refill_blocks)
	health_component.depleted_health.connect(die)

func _physics_process(delta: float) -> void:
	Global.player_position = global_position
	block_container.update_blocks(current_block_count)
	move_input = input_handler.movement_input()
	is_running = Input.is_action_pressed("run")
	is_ducking = Input.is_action_pressed("duck")
	is_ducking_just_pressed = Input.is_action_just_pressed("duck")
	is_blocking = Input.is_action_pressed("block")
	is_jumping = input_handler.jump_input()
	is_jump_released = input_handler.jump_released()
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
	#is_interacting = Input.is_action_pressed("interact")
	
	_update_state()
	
	if move_input:
		flip_handler.flip_entity(sprite, move_input)
	else:
		player_hitbox.position.x = 0
	if move_input.x != 0.0:
		flip_handler.player_flip_hitbox_correction(player_hitbox)
		
	if current_state != State.DASH and boost_cooldown_left > 0:
		boost_cooldown_left = boost_cooldown_left - delta
	
	jump_handler.handle_jump(self, is_jumping, is_jump_released)
	_apply_movement(delta)

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
			Global.player_blocking = true
			if current_block_count > 0:
				return State.BLOCK
		if is_attacking:
			return State.ATTACK
		return State.JUMP if velocity.y < 0 else State.FALL
	if is_interacting:
		return State.INTERACTING
	if is_jumping:
		return State.JUMP
	if is_blocking and is_running and move_input.x != 0.0 and not current_state == State.DASH and boost_cooldown_left <= 0.0:
		Global.player_blocking = true
		boost_time_left = boost_duration
		dash_direction = sign(move_input) if move_input.x != 0.0 else 1.0
		return State.DASH
	if is_ducking and is_running and move_input.x != 0.0:
		if is_ducking_just_pressed:
			boost_time_left = boost_duration
		return State.SLIDE
	if is_blocking:
		Global.player_blocking = true
		if current_block_count > 0:
			return State.BLOCK
	if is_ducking:
		return State.DUCK
	if sign(move_input.x) != sign(velocity.x):
		return State.BRAKING
	if is_running and move_input.x != 0.0:
		return State.RUN
	if move_input.x != 0.0:
		return State.WALK
	if is_attacking:
		return State.ATTACK
	return State.IDLE

func _update_animation()->void:
	#rotation = 0
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
			await get_tree().create_timer(2).timeout
			is_blocking = false
			Global.player_blocking = false
			print("player: is_blocking:", is_blocking)
			return
		State.DASH:
			animation.play("Dash")
			return
		State.ATTACK:
			animation.play("Attack")
			await animation.animation_finished
			is_attacking = false
			return
		State.INTERACTING:
			animation.play("Idle")
			return

func take_damage(damage) -> void:
	camera.trigger_shake()
	if !is_blocking:
		$HealthComponent.decrease_health(damage)
		print("player takes damage, ", damage)
		animation.play("Hit")
	else:
		print("player blocked it")

func _apply_movement(delta:float) -> void:
	var target_speed : float = 0.0
	if not is_on_floor():
		velocity.y += gravity * delta
		#var direction = move_input
		velocity.x = base_speed * move_input.x #direction
	match current_state:
		State.IDLE, State.BLOCK, State.DUCK, State.INTERACTING, State.ATTACK:
			target_speed = 0.0
			velocity.x = move_toward(velocity.x, target_speed, friction)
		State.BRAKING:
			target_speed = move_input.x * base_speed * speed_buff_factor
			velocity.x = move_toward(velocity.x, target_speed, friction)
		State.WALK:
			target_speed = move_input.x * base_speed * speed_buff_factor
			velocity.x = move_toward(velocity.x, target_speed, acceleration)
		State.RUN:
			target_speed = move_input.x * base_speed * run_speed_factor * speed_buff_factor
			velocity.x = move_toward(velocity.x, target_speed, acceleration)
		State.JUMP:
			if is_on_floor():
				velocity.y = jump_height
			target_speed = move_input.x * base_speed * speed_buff_factor
			#velocity.x = move_toward(velocity.x, target_speed, acceleration)
			#velocity.x is the jump problems origin but i don't know how to fix it
		State.DASH:
			velocity.x = dash_direction * base_speed * dash_speed_factor * speed_buff_factor
			boost_time_left -= delta
			if boost_time_left <= 0.0:
				boost_cooldown_left = boost_cooldown
		
	move_and_slide()

func blocking():
	if is_blocking:
		Global.player_blocking = true
		current_block_count -= 1
		# block_container.update_blocks(current_block_count)
	print(current_block_count, "blocks left")
	print("player: is_blocking value:", is_blocking)

func _refill_blocks():
	current_block_count = max_block_count
	block_container.update_blocks(current_block_count)
	print("coffee refilled, blockcount:", current_block_count)
	Global.coffee_break = false

func die():
	get_tree().change_scene_to_file("res://ui/game_over.tscn")

func _on_dialogic_signal(argument: String):
	if argument == "entered_dialog":
		is_interacting = true
		$Sounds/Talk.play()
	if argument == "exited_dialog":
		is_interacting = false
	if argument == "option1_selected":
		speed_buff_factor += 0.1
	if argument == "option2_selected":
		max_block_count += 1
		current_block_count += 1
	if argument == "":
		pass

func return_to_foyer():
	pass

func start_timer_in_level_one():
	if not in_safe_room:
		$HUD/TimerOptions/Timer.start()
		$HUD/TimerOptions/Timer.paused = false

func _on_health_component_health_changed(current_health) -> void:
	hearts_container.update_hearts(current_health)


func attack():
	#if is_attacking:
		var overlapping_objects = $AttackBox.get_overlapping_areas()
			
		for area in overlapping_objects:
			var parent = area.get_parent()
			print("print parent name in player script", parent.name)
			
		for area in overlapping_objects:
			if area.get_parent().is_in_group("Enemies"):
				print("attacks enemy area")
				area.get_parent().take_damage(2)

func _on_attack_box_area_entered(area: Area2D) -> void:
	if area.get_parent() is RingBinder:
		area.get_parent().take_damage()
		print("player:attack area ringbinder entered")

func in_elevator():
	is_interacting = true

func elevatorhide():
	$Sprite2D.visible = false

func left_elevator():
	is_interacting = false
