extends Node2D


func _on_agatha_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		if Input.is_action_pressed("interact"):
			pass
			#dialog einfügen

func _on_door_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		if Input.is_action_pressed("interact"):
			pass

func enter_level_one():
	pass
