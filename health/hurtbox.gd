extends Area2D
class_name Hurtbox

@onready var owner_health_component : HealthComponent 

func _ready() -> void:
	monitoring = false # Doesn't detect other shapes

# TODO set collision layers and masks

func receive_hit(damage : int) -> void:
	owner_health_component.decrease_health(damage)
