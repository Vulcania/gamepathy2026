extends CharacterBody2D
class_name AnotherDeer

@export var speed = -80.0
@export var current_speed = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false

var dead = false

var player : Player

var max_health = 2
var health 
var hit = false 
var can_attack = true 

@onready var detect_edge = $RayCastEdges
@onready var detect_wall = $RayCastWalls
@onready var detect_player = $RayCastPlayer
@onready var detect_player_behind = $RayCastPlayerBehind
@onready var animation = $AnimationPlayer

func _ready():
	health = max_health
	animation.play("Walk")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !detect_edge.is_colliding() && is_on_floor():
		flip()
	if detect_wall.is_colliding():
		flip()
	
	if detect_player.get_collider() is Player:
		attack()
	if detect_player_behind.get_collider() is Player:
		flip()
	
	velocity.x = speed 
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

func attack():
	animation.play("Attack")

func _on_attack_area_area_entered(area):
	if area.get_parent() is Player && !dead && can_attack:
		area.get_parent().take_damage(1)


func take_damage(damage_amount):
	if !dead:
		
		health -= damage_amount
		
		get_node("Healthbar").update_healthbar(health, max_health)
		
		if health <= 0:
			die()

func get_hit():
	hit = !hit
	
	if hit:
		current_speed = speed
		speed = 0
		can_attack = false
		animation.play("Hit")
	else:
		speed = current_speed
		can_attack = true
		animation.play("Walk")

func die():
	dead = true
	speed = 0
	animation.play("Dead")
