extends CharacterBody2D

var speed : int = 40
var health : int
var strength : int = 2
var facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var hitbox : CollisionShape2D

@onready var ray_cast = $RayCast2D
@onready var vert_collision = $VerticalCollision

signal player_was_hit
signal enemy_was_hit

func _ready() -> void:
	health = $HealthComponent.max_health
	$EnemyHitbox/enemy_hitbox.hide()
	scale.x = abs(scale.x)*-1

func _physics_process(delta):
	move_and_slide()
	$AnimatedSprite2D.play("walking")
	
	if !ray_cast.is_colliding():
		flip()
	
	velocity.x = speed
	
	if not is_on_floor():
		velocity.y += gravity * delta

func flip():
	# $AnimatedSprite2D.play("idle")
	# timer?
	facing_right = !facing_right
	scale.x = abs(scale.x)*-1
	
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed)*-1

func _on_boundary_shape_body_entered(body: Node2D):
	if (body.name == "Player"):
		player_was_hit.emit()
	if (body.name == "player_attack"):
		enemy_was_hit.emit()

func _on_health_component_depleted_health() -> void:
	#$AnimatedSprite2D.play("dying")
	queue_free()

# when player target detected, approach and attack if close enough
func attack():
	$AnimatedSprite2D.play("attack")
	
	if $EnemyHitbox/enemy_hitbox.hide():
		$EnemyHitbox/enemy_hitbox.show()

func take_damage(damage : int):
	$HealthComponent.decrease_health(damage)

func _on_health_component_health_changed(new_health: int):
	health = new_health
	# affect healthbar

func _on_vertical_collision_body_entered(body: Area2D) -> void:
	if (body.name == "MonitorArea"):
		attack()
	else:
		flip()
