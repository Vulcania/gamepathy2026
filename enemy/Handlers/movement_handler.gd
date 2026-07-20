class_name MovementHandler
extends Node2D

@export var move_speed : int = 0

func movement(entity : CharacterBody2D, input_direction: Vector2, delta : float) -> void:
	deceleration(entity, input_direction, delta)
	
	if input_direction:
		entity.velocity.x = input_direction.x * move_speed * delta

func deceleration(entity : CharacterBody2D, input_direction : Vector2, _delta : float) -> void:
	if input_direction:
		return
	entity.velocity.x = move_toward(entity.velocity.x, 0, move_speed)
	
