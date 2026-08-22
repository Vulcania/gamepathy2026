class_name EnemyAIHandler
extends Node2D

@onready var player = get_node("root/Main/test_level/Player")

@export var is_flying : bool = false

@export var sprite : AnimatedSprite2D = null
@export var animation : AnimationPlayer = null
@export var base_shape : CollisionShape2D = null
@export var hitbox : HitBox = null
@export var attack_box : AttackBox = null
@export var floor_check_left : RayCast2D = null
@export var wall_check_left : RayCast2D = null
@export var movement_handler : MovementHandler = null
@export var flip_handler : FlipHandler = null
@export var health_component: HealthComponent = null

var is_attacking : bool = false
var is_targeted : bool = false
var is_dying : bool = false

signal is_dead

enum State { IDLE, WALK, ATTACK, HIT, DYING, DEAD }

var new_state : State
var current_state = State.WALK
var direction : Vector2 = Vector2(1.0, 0.0)

func _ready() -> void:
	health_component.depleted_health.connect(_on_health_component_depleted_health)

func _process(_delta) -> void:
	if is_flying:
		direction = Global.player_position - position

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
		#await animation.animation_finished

func check_state():
	if is_targeted and !is_dying:
		return State.HIT
	
	if is_attacking and !is_targeted and !is_dying:
		return State.ATTACK
	
	if is_dying:
		return State.DYING
	
	if floor_check_left.is_colliding() == false or wall_check_left.is_colliding():
		flip()
		return State.IDLE
	
	if !is_attacking and !is_targeted and !is_dying:
		return State.WALK
	return State.IDLE

func flip():
	flip_handler.flip_entity(sprite, direction)
	flip_handler.flip_raycast(floor_check_left, wall_check_left)
	flip_handler.apply_collision_shapes_offset(base_shape, hitbox, attack_box)
	
	if is_flying == false:
		direction.x *= -1

func _update_animation():
	match current_state:
		State.DYING:
			animation.play("dying")
			await animation.animation_finished
			return
		State.IDLE:
			if !is_dying:
				animation.play("idle")
				return
		State.WALK:
			if !is_dying:
				animation.play("walk")
				return
		State.HIT:
			if !is_dying:
				animation.play("hit")
				await animation.animation_finished
				return
		State.ATTACK:
			animation.play("attack")
			return

func _on_health_component_depleted_health():
	is_dying = true
