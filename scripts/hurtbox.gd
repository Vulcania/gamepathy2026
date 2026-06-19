extends Area2D
class_name Hurtbox

@onready var owner_health_component : HealthComponent 

func _ready() -> void:
	monitoring = false # Doesn't detect other shapes
	
	collision_layer = 0
	collision_mask = 2


func receive_hit(damage : int) -> void:
	owner_health_component.decrease_health(damage)
