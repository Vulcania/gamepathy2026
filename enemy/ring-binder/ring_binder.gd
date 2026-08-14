extends CharacterBody2D
class_name RingBinder

#@export var speed = 120.0
#@export var current_speed = 0.0

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")
@onready var player = get_parent().find_child("Player")

var facing_right = false

var max_health = 3
var health: int = 3
var hit = false
var can_attack = true 

var direction : Vector2

func _ready():
	health = max_health
	print("ringbinder health:", health)
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("Idle")
	#$SFX/Idle.play()

func _process(_delta: float) -> void:
	direction = player.global_position - position
	
	if direction.x < 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	if direction.x and direction.y <= 60:
		animation.play("Attack")
	else:
		animation.play("Idle")

func _physics_process(_delta):
	velocity = direction.normalized() * 60
	move_and_slide()

func take_damage():
	health -= 1
	print("ring binder takes damage, health: ", health)
	camera.trigger_shake()
	if health > 0:
		#$SFX/Hurt.play()
		animation.play("Hit")
#	if health <= 0: 
#		$SFX/Dying.play()
#		animation.play("Death")
#queue free in Death Animation

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is AttackBox:
		#hit = true
		print("ringbinder: attackbox entered")
		take_damage()
	if area.get_parent() is Player:
		#hit = true
		print("ringbinder: attackbox entered")
		take_damage()
