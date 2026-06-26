extends CharacterBody2D

@export var speed = 120.0
@export var current_speed = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false

var max_health = 3
var health: int
var can_attack = true 

var is_hit: bool = false
var is_following: bool = false
var is_attacking: bool = false
var is_dying: bool = false
var is_dead: bool = false

enum State { IDLE, FOLLOWING, WALK, ATTACK, HIT, DYING, DEAD }

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
	velocity.x = speed 
	
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

func _get_state() -> State:
	if is_hit: 
		return State.HIT
	if is_following:
		return State.FOLLOWING
	if is_attacking:
		return State.ATTACK
	if is_dying:
		return State.DYING
	if is_dead:
		return State.DEAD
	return State.IDLE
	
func _update_animation() -> void:
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
		State.FOLLOWING:
			animation.play("Walk")
			return
		State.DYING:
			animation.play("Dead")
			return
		State.DEAD:
			queue_free()
	return

func take_damage(damage_amount):
	if !is_dead:
		health -= damage_amount
		if health <= 0:
			die()
	get_node("Healthbar").update_healthbar(health, max_health)

func get_hit(damage):
	is_hit = !is_hit
	
	if is_hit:
		current_speed = speed
		can_attack = false
		$AnimationPlayer.play("Hit")
		is_hit = !is_hit
		take_damage(damage)
		return
	else:
		speed = current_speed
		can_attack = true
		$AnimationPlayer.play("Walk")

func die():
	is_dead = true
	speed = 0
	$AnimationPlayer.play("Dead")

func _on_detect_environment_area_entered(area):
	if area.get_parent() is Player && !is_hit:
		can_attack = true
		if can_attack:
			is_attacking = true
			$AnimationPlayer.play("Attack")
			can_attack = false
			await get_tree().create_timer(2).timeout
			return
	else:
		flip()

func _on_hurtbox_take_damage(damage) -> void:
	get_hit(damage)

func _on_detect_environment_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_attacking = false
		$AnimationPlayer.play("Idle")
