extends Control

@export var max_health : int = 100 
@export var current_health : int

signal depleted_health
signal health_changed(current_health)
signal full_health_restored

# Take Damage
func decrease_health(amount : int):
	current_health -= amount
	if current_health < 0:
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
