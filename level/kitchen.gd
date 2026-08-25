extends Node2D

var is_in_area = false

func _ready() -> void:
	$Door2/pressE.hide()
	TimerOptions.timer_paused()
	$AnimationPlayer.play("EnteredKitchen")

func _input(event):
	if is_in_area:
		if event.is_action_pressed("interact"):
			$AnimationPlayer.play("EnterLevelTwo")

func enter_level_two():
	get_tree().change_scene_to_file("res://level/level_two.tscn")

func _on_door_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = true
		$Door2/pressE.show()

func _on_door_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = false
		$Door2/pressE.hide()
