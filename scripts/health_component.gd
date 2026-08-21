class_name HealthComponent
extends Control

@export var max_health : int = 3
var current_health

signal depleted_health
signal health_changed(current_health)
signal full_health_restored

func _ready() -> void:
	current_health = max_health

# Take Damage
func decrease_health(amount : int):
	current_health -= amount
	print("healthcomp decrease health ", current_health, owner)
	if current_health <= 0:
		current_health = 0
		depleted_health.emit()
	else:
		health_changed.emit(current_health)

# Healing
func increase_health(amount : int):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
		full_health_restored.emit()
	else:
		health_changed.emit(current_health)
