extends CharacterBody2D

@export var speed = 120.0
@export var current_speed = 0.0

var idle_speed = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false

@export var max_health = 3
var health: int
var can_attack = true 
var target
var direction

var is_walking: bool = true
var is_hit: bool
var is_following: bool
var is_attacking: bool
var is_dying: bool
var is_dead: bool

enum State { IDLE, PURSUING, WALK, ATTACK, HIT, DYING, DEAD }

var initial_state: State = State.WALK
var current_state: State

@onready var animation = $AnimationPlayer

func _ready():
	health = max_health
	is_hit = false
	is_following = false
	is_attacking = false
	is_dying = false
	is_dead = false

func _physics_process(delta):
	_update_state()
	_apply_behaviour(delta)
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
	print(current_state)
	if previous_state != current_state:
		_update_animation()

func _apply_behaviour(_delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	
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
				velocity.x = direction.x
		
		State.DYING:
			speed = idle_speed
			# timer to let animation play
			is_dead = true
			return
	

func _get_state() -> State:
	if is_walking:
		return State.WALK
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
	return initial_state
	
func _update_animation():
	match current_state:
		State.IDLE:
			animation.play("Idle")
			
		State.WALK:
			animation.play("Walk")
			
		State.HIT:
			animation.play("Hit")
			
		State.ATTACK:
			animation.play("Attack")
			
		State.PURSUING:
			animation.play("Walk")
			
		State.DEAD:
			is_dead = true
			queue_free()
			
		State.DYING:
			speed = 0
			animation.play("Dead")

#func reset_state() -> void:
	#is_walking = false
	#is_hit = false
	#is_following = false
	#is_attacking = false

func take_damage(damage_amount):
	is_hit = true
	health -= damage_amount
	get_node("Healthbar").update_healthbar(health, max_health)
	print(health)
	
	if health <= 0:
		return State.DYING

func _on_detect_environment_body_entered(body: Node2D) -> State:
	if body is TileMapLayer:
		# insert timer to wait a moment and Idle?
		flip()
		return State.WALK
	
	if body is Player:
		target = body
		is_following = true
		return State.PURSUING
		
		# if close enough <- determined by if player in attack area
		# is_attacking = true
	return initial_state
	

func _on_detect_environment_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		is_following = false
		is_walking = true

func _on_attack_box_area_entered(area: Area2D) -> void:
	if area is HitBox:
		is_walking = false
		is_attacking = true

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area is AttackBox:
		is_walking = false
		is_hit = true

func _on_attack_box_area_exited(_area: Area2D) -> void:
	is_attacking = false
	is_walking = true
