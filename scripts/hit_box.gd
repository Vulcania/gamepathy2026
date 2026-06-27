class_name HitBox
extends Area2D

signal take_damage

func _on_area_entered(hitbox : AttackBox) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"):
		take_damage.emit(hitbox.damage)
