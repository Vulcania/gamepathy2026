class_name EnemyAIHandler
extends Node2D

@export var body : CharacterBody2D = null
@export var sprite : AnimatedSprite2D = null
#@export var healthbar : Healthbar = null
@export var floor_check_left : RayCast2D = null
@export var floor_check_right : RayCast2D = null
@export var wall_check_left : RayCast2D = null
@export var wall_check_right : RayCast2D = null
@export var movement_handler : MovementHandler = null

var is_idle : bool = false
var is_attacking : bool = false
var is_targeted : bool = false
var is_dying : bool = false

signal is_dead

enum State { IDLE, PURSUING, WALK, ATTACK, HIT, DYING, DEAD }

var current_state = State.WALK
var direction = Vector2(-1.0, 0.0)

func handle_state(entity : CharacterBody2D, delta : float) -> void:
	current_state = check_state()
	match current_state:
		State.IDLE:
			movement_handler.movement(entity, Vector2.ZERO, delta)
			is_idle = true
			await get_tree().create_timer(2.0).timeout
		
		State.WALK:
			is_idle = false
			movement_handler.movement(entity, direction, delta)
		
		State.HIT:
			is_idle = false
			movement_handler.movement(entity, Vector2.ZERO, delta)
		
		State.ATTACK:
			is_idle = false
			movement_handler.movement(entity, Vector2.ZERO, delta)
		
		State.DYING:
			movement_handler.movement(entity, Vector2.ZERO, delta)
	_update_animation()

func check_state():
	if is_idle:
		return State.WALK
	
	if is_attacking:
		return State.ATTACK
	
	if is_targeted:
		return State.HIT
	
	if is_dying:
		return State.DYING
	
	if floor_check_left.is_colliding() == false or wall_check_left.is_colliding():
		flip()
		return State.IDLE
	
	#if floor_check_right.is_colliding() == false or wall_check_right.is_colliding():
		#flip()
		#return State.IDLE
	return State.WALK

func flip():
	body.scale.x *= -1
	#healthbar.scale.x *= -1
	direction.x *= -1

func _update_animation():
	match current_state:
		State.IDLE:
			sprite.animation = "idle"
			return
		State.WALK:
			sprite.animation = "walk"
			return
		State.HIT:
			sprite.animation = "hit"
			return
		State.ATTACK:
			sprite.animation = "attack"
			return
		State.DYING:
			sprite.animation = "dying"
			return

func _on_health_component_depleted_health() -> void:
	is_dying = true
