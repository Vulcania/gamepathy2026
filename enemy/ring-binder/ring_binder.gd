extends CharacterBody2D
class_name RingBinder

#@export var speed = 120.0
#@export var current_speed = 0.0

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")

@onready var health_component: HealthComponent = $HealthComponent
@onready var healthbar: Healthbar = $Healthbar

var facing_right = false

var max_health = 2
var health: int = 2
var hit = false
var can_attack = true 
var dead = false

var direction : Vector2

func _ready():
	health_component.max_health = max_health
	print("ringbinder health:", health)
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("Idle")
	#$SFX/Idle.play()

func _process(_delta: float) -> void:
	if !dead:
		direction = Global.player_position - position
		
		if direction.x < 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

		if direction.x and direction.y <= 60:
			animation.play("Attack")
		else:
			animation.play("Idle")

func _physics_process(_delta):
	if !dead:
		velocity = direction.normalized() * 60
		move_and_slide()

func take_damage(damage):
	#health -= 1
	health_component.decrease_health(damage)
	print("ring binder takes damage, health: ", health)
	camera.trigger_shake()
	if health > 0:
		$SFX/Hurt.play()
		animation.play("Hit")
	if health <=0:
		_on_health_component_depleted_health()
#queue free in Death Animation

func _on_health_component_health_changed(current_health: Variant) -> void:
	healthbar.update_healthbar(current_health, max_health)
	#animation.play("Hit")
	#$SFX/Hurt.play()

func _on_health_component_depleted_health() -> void:
	#$SFX/Dying.play()
	dead = true
	animation.play("Death")
	await animation.animation_finished
	queue_free()
