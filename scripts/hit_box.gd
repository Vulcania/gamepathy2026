class_name HitBox
extends Area2D

func _on_area_entered(body : AttackBox) -> void:
	if body == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(body.damage)
