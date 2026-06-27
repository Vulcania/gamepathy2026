extends CharacterBody2D

@export var speed = 120.0
@export var current_speed = 0.0

var facing_right = false

var max_health = 3
var health: int
var current_state: States

func _ready():
	health = max_health

func _physics_process(delta):
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	
	current_state.update(delta)
	
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
