extends Node2D

var is_in_area = false

func _ready() -> void:
	var layout = Dialogic.start("res://dialog/timelines/enter_kitchen2.dtl")
	layout.register_character(load("res://dialog/characters/Player.dch"), $Player/Marker2D)
	Dialogic.start("res://dialog/timelines/enter_kitchen2.dtl")
	$Door/pressE.hide()
	TimerOptions.timer_paused()
	BlocksContainer.hide()

func _input(event):
	if event.is_action_pressed("interact"):
		if is_in_area:
			$Door/AnimationPlayer.play("door_opened")

func enter_level_three():
	get_tree().change_scene_to_file("res://level/level_three.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = true
		$Door/pressE.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = false
		$Door/pressE.hide()
