extends CharacterBody2D

@export var speed : int = 40
#@export var gravity : int = 10

var current_health : int
var facing_right = false
#var velocity : Vector2
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ray_cast = $RayCast2D
@onready var vert_collision = $VerticalCollision

signal player_was_hit
signal enemy_was_hit

func _ready() -> void:
	current_health = $HealthComponent.max_health
	$AnimatedSprite2D.play("walking")

func _physics_process(delta: float):
	#move_character()
	if !ray_cast.is_colliding():
		flip()
	
	#if !vert_collision.is_colliding():
		#flip()
	
	velocity.x = speed
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x)*-1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed)*-1

#func move_character():
	#move_local_x(-speed)
	#move_local_y(gravity)

func detect_environment():
	pass

func _on_boundary_shape_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		player_was_hit.emit()
	if (body.name == "player_attack"):
		enemy_was_hit.emit()

func _on_health_component_depleted_health() -> void:
	# death animation
	queue_free()

func _on_health_component_health_changed(current_health: int) -> void:
	pass # change healthbar?

func _on_vertical_collision_body_entered(body: CollisionShape2D) -> void:
	flip()
