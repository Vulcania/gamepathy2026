class_name InputHandler
extends Node2D

# Movement input
var direction : Vector2  = Vector2.ZERO
var is_running: bool = false
var is_ducking: bool = false
var is_ducking_just_pressed: bool = false
var is_blocking: bool = false
var is_jumping: bool = false
var is_jump_released : bool = false
var is_attacking: bool = false
var is_interacting: bool = false

func movement_input() -> Vector2:
	direction.x = Input.get_axis("move_left", "move_right")
	return direction

func jump_input() -> bool:
	is_jumping = Input.is_action_just_pressed("jump")
	return is_jumping

func jump_released() -> bool:
	is_jump_released = Input.is_action_just_released("jump")
	return is_jump_released

func duck_input() -> bool:
	is_ducking = Input.is_action_pressed("duck")
	return is_ducking

func duck_pressed() -> bool:
	is_ducking_just_pressed = Input.is_action_just_pressed("duck")
	return is_ducking_just_pressed

func block_input() -> bool:
	is_blocking = Input.is_action_pressed("block")
	return is_blocking

func attack_input() -> bool:
	is_attacking = Input.is_action_pressed("attack")
	return is_attacking

func interact_input() -> bool:
	is_interacting = Input.is_action_pressed("interact")
	return is_interacting
