extends CharacterBody2D

@export var speed = 120.0
@export var current_speed = 0.0
var idle_speed = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false

var max_health = 3
var health: int
var can_attack = true 
var target
var direction

var is_hit: bool = false
var is_following: bool = false
var is_attacking: bool = false
var is_dying: bool = false
var is_dead: bool = false

enum State { IDLE, PURSUING, WALK, ATTACK, HIT, DYING, DEAD }

var current_state: State = State.IDLE

@onready var animation = $AnimationPlayer

func _ready():
	health = max_health

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	
	_update_state()
	_apply_behaviour()
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

func _update_state() -> void:
	var previous_state = current_state
	current_state = _get_state()
	
	if previous_state != current_state:
		_update_animation()

func _apply_behaviour() -> void:
	match current_state:
		State.IDLE:
			velocity.x = idle_speed
			
		State.WALK:
			velocity.x = speed 
		
		State.HIT:
			speed = idle_speed
		
		State.PURSUING:
			if target:
				direction = target.global_position - global_position
				velocity.x = direction.x * speed
		
		State.DYING:
			speed = idle_speed
			# timer to let animation play
			is_dead = true
			return

func _get_state() -> State:
	if is_hit: # Ermittelt durch Hurtbox Collision
		return State.HIT
	if is_following: # Ermittelt durch DetectEnvironment
		return State.PURSUING
	if is_attacking: # Ermittelt durch DetectEnvironment
		return State.ATTACK
	if is_dying: # Ermittelt durch Health Check
		return State.DYING
	if is_dead: # Folgt ausschließlich unmittelbar nach Dying
		return State.DEAD
	return State.IDLE
	
func _update_animation():
	if velocity.x != 0:
		animation.play("Walk")
	match current_state:
		State.IDLE:
			animation.play("Idle")
			return
		State.WALK:
			animation.play("Walk")
			return
		State.HIT:
			animation.play("Hit")
			return
		State.PURSUING:
			animation.play("Walk")
			return
		State.DEAD:
			is_dead = true
			queue_free()
		State.DYING:
			speed = 0
			animation.play("Dead")
			return
	return

func take_damage(damage_amount):
	is_hit = true
	if !is_dead:
		health -= damage_amount
		get_node("Healthbar").update_healthbar(health, max_health)
		if health <= 0:
			return State.DYING

func _on_hurtbox_take_damage() -> void:
	is_hit = true

func _on_detect_environment_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		is_following = true
		current_state = State.PURSUING
	else:
		flip()

func _on_detect_environment_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		is_following = false
