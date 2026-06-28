extends Node2D


@onready var animation = $Door/AnimationPlayer

#var door_unlocked = false
var is_in_door_area = false

func _input(event):
	if event.is_action_pressed("interact"):
		if is_in_door_area:
			animation.play("door_opened")

func enter_next_room():
	get_tree().change_scene_to_file("res://level/kitchen.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_door_area = true
