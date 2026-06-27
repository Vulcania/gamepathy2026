class_name Hurtbox
extends Area2D

signal take_damage

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _on_area_entered(hitbox : Hitbox) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"):
		take_damage.emit(hitbox.damage)
