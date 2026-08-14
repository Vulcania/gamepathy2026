class_name HealthComponent
extends Control

@export var max_health : int = 3
@export var current_health : int = 3

signal depleted_health
signal health_changed(current_health)
signal full_health_restored

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
