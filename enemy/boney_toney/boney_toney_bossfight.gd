extends CharacterBody2D

@onready var collision = $"../../PlayerDetection/CollisionShape2D" 
@onready var player = get_parent().find_child("Player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar

var direction : Vector2

enum State {IDLE, FOLLOW, ATTACK, TELEPORT, SPAWNMINION, DEATH}
var Idle = get_child(0)
var Follow = get_child(1)

var new_state : State

var current_state: State = State.IDLE
var previous_state: State

var is_attacking = false
var is_hit = false
var is_dead = false

var player_entered = false
var player_out_of_reach = false
 
var health: = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			is_dead = true

func _ready():
	set_physics_process(false)
	
	current_state = State.IDLE
 

func handle_state(entity : CharacterBody2D, delta : float) -> void:
	new_state = check_state()
	if new_state != current_state:
		current_state = new_state
		match current_state:
			State.IDLE:
				pass
			State.FOLLOW:
				pass
			State.ATTACK:
				pass
			State.TELEPORT:
				pass
			State.SPAWNMINION:
				pass
			State.DEATH:
				pass
		_update_animation()



func check_state():
	if is_targeted and !is_dying:
		return State.HIT
	
	if is_attacking and !is_hit and !is_dead:
		return State.ATTACK
	
	if is_dead:
		return State.DEATH
	
	if floor_check_left.is_colliding() == false or wall_check_left.is_colliding():
		flip()
		return State.IDLE
	
	if !is_attacking and !is_targeted and !is_dying:
		return State.WALK
	return State.IDLE
