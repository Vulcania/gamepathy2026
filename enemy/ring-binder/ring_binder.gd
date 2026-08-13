extends CharacterBody2D

#@export var speed = 120.0
#@export var current_speed = 0.0

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")
@onready var player = get_parent().find_child("Player")

var facing_right = false

var max_health = 3
var health: int
#var current_state: States

#var direction : Vector2
var acceleration: Vector2 = Vector2.ZERO 

func _ready():
	$SFX/Idle.play()
	health = max_health
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")

func _process(_delta: float) -> void:
#	if direction.x < 0:
#		sprite.flip_h = true
#	else:
#		sprite.flip_h = false
	acceleration = (player.position - position).normalized() * 700

func _physics_process(_delta):
	var direction = player.position - position
	
	velocity = direction.normalized() * 60
	move_and_slide()

func _on_attack_area_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)
		$SFX/Attack.play()
		camera.trigger_shake()
		print("melee attacking player")

func take_damage():
	health -= 1
	print("ring binder takes damage", health)
	camera.trigger_shake()
	if health > 0:
		$SFX/Hurt.play()
		animation.play("Hit")
	if health < 1: 
		$SFX/Dying.play()
		animation.play("Death")
#queue free in Death Animation
