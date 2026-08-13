class_name EnemyAIHandler
extends Node2D

@export var sprite : AnimatedSprite2D = null
@export var animation : AnimationPlayer = null
@export var base_shape : CollisionShape2D = null
@export var hitbox : HitBox = null
@export var attack_box : AttackBox = null
@export var floor_check_left : RayCast2D = null
@export var wall_check_left : RayCast2D = null
@export var movement_handler : MovementHandler = null
@export var flip_handler : FlipHandler = null

var is_attacking : bool = false
var is_targeted : bool = false
var is_dying : bool = false

signal is_dead

enum State { IDLE, WALK, ATTACK, HIT, DYING, DEAD }

var new_state : State
var current_state = State.WALK
var direction = Vector2(1.0, 0.0)

func handle_state(entity : CharacterBody2D, delta : float) -> void:
	new_state = check_state()
	if new_state != current_state:
		current_state = new_state
		match current_state:
			State.DYING:
				movement_handler.movement(entity, Vector2.ZERO, delta)
			
			State.IDLE:
				movement_handler.movement(entity, Vector2.ZERO, delta)
			
			State.WALK:
				movement_handler.movement(entity, direction, delta)
			
			State.HIT:
				movement_handler.movement(entity, Vector2.ZERO, delta)
			
			State.ATTACK:
				movement_handler.movement(entity, Vector2.ZERO, delta)
		_update_animation()
		await animation.animation_finished

func check_state():
	if is_attacking:
		return State.ATTACK
	
	if is_targeted:
		return State.HIT
	
	if is_dying:
		return State.DYING
	
	if floor_check_left.is_colliding() == false or wall_check_left.is_colliding():
		flip()
		return State.IDLE
	#print("enemy ai handler:", current_state)
	return State.WALK


func flip():
	flip_handler.flip_entity(sprite, direction)
	flip_handler.flip_raycast(floor_check_left, wall_check_left)
	flip_handler.apply_collision_shapes_offset(base_shape, hitbox, attack_box)
	direction.x *= -1
	print("enemy ai handler flipped")

func _update_animation():
	match current_state:
		State.IDLE:
			animation.play("idle")
			return
		State.WALK:
			animation.play("walk")
			return
		State.HIT:
			animation.play("hit")
			return
		State.ATTACK:
			animation.play("attack")
			return
		State.DYING:
			animation.play("dying")
			return

func _on_health_component_depleted_health() -> void:
	is_dying = true
