extends Node2D

var is_in_door_area = false

func ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	$Door/pressE.hide()

func _input(event):
	if event.is_action_pressed("interact"):
		if is_in_door_area:
			$AnimationPlayer.play("EnterLevelOne")

func _on_door_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_door_area = true
		$Door/pressE.show()

func _on_door_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_door_area = false
		$Door/pressE.hide()

func _on_dialogic_signal(argument: String):
	if argument == "":
		pass

func enter_level_one():
	get_tree().change_scene_to_file("res://level/level_one.tscn")
#in AnimationPlayer
