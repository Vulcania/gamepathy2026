extends Node2D

var is_in_area = false

func _ready() -> void:
	$Door/pressE.hide()

func _input(event):
	if is_in_area:
		if event.is_action_pressed("interact"):
			$Door/AnimationPlayer.play("door_opened")

func enter_level_two():
	get_tree().change_scene_to_file("res://level/level_two.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = true
		$Door/pressE.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = false
		$Door/pressE.hide()
