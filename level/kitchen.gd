extends Node2D


func _ready() -> void:
	pass # Replace with function body.


func enter_level_two():
	get_tree().change_scene_to_file("res://level/level_two.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		if Input.is_action_just_pressed("interact"):
			print("is trying to interact")
			$Door/AnimationPlayer.play("door_opened")
