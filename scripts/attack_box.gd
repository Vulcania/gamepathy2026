extends Area2D
class_name AttackBox

@export var damage : int = 1

func _init() -> void:
	collision_layer = 2
	collision_mask = 0
