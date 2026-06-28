extends CharacterBody2D

@export var speed = 100.0
@export var current_speed = 0.0

var idle_speed = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false

@export var max_health = 3
var health: int
var target: Player
var direction: Vector2

enum State { IDLE, PURSUING, WALK, ATTACK, HIT, DYING, DEAD }

var initial_state: State = State.WALK
var current_state: State

signal state_changed(new_state: State)

@onready var animation = $AnimationPlayer

func _ready():
	health = max_health
	current_state = initial_state
	_update_behaviour(current_state)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	
	if facing_right:
		velocity.x = abs(speed)
	else:
		velocity.x = abs(speed) * -1

func _update_behaviour(new_state: State) -> void:
	match new_state:
		State.IDLE:
			velocity.x = idle_speed
		
		State.WALK:
			velocity.x = speed 
		
		State.HIT:
			velocity.x = idle_speed
		
		State.PURSUING:
			if target:
				direction = target.global_position - global_position
				velocity.x = direction.x # TODO works but moves too fast, so this isn't quite right
		
		State.ATTACK:
			velocity.x = idle_speed
		
		State.DYING:
			velocity.x = idle_speed
			# Timer to let animation play
			state_changed.emit(State.DEAD)
	
func _update_animation(new_state: State):
	match new_state:
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
			
		State.DYING:
			speed = 0
			animation.play("Dead")
			# TODO timer
			# queue_free()

func take_damage(damage_amount):
	state_changed.emit(State.HIT)
	
	health -= damage_amount
	get_node("Healthbar").update_healthbar(health, max_health)
	
	if health <= 0:
		state_changed.emit(State.DYING)

func _on_detect_environment_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		state_changed.emit(State.PURSUING)
		
	if body is TileMapLayer:
		# insert timer to wait a moment and Idle?
		flip()
		state_changed.emit(State.WALK)

func _on_detect_environment_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		state_changed.emit(State.WALK)

func _on_attack_box_area_entered(area: Node2D) -> void:
	if area is HitBox:
		state_changed.emit(State.ATTACK)

func _on_attack_box_area_exited(area: Node2D) -> void:
	if area is HitBox:
		state_changed.emit(State.WALK)

func _on_state_changed(new_state: State) -> void:
	_update_animation(new_state)
	_update_behaviour(new_state)
	current_state = new_state
	print(new_state)

func _on_detect_behind_body_entered(body: Node2D) -> void:
	if body is Player:
		flip()
