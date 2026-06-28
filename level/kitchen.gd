extends Node2D

var is_in_area = false

func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("interact"):
		if is_in_area:
			$Door/AnimationPlayer.play("door_opened")

func enter_level_two():
	get_tree().change_scene_to_file("res://level/level_two.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = false
