class_name HitBox
extends Area2D

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(attack : AttackBox) -> void:
	if attack == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(attack.damage)
