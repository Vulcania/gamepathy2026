extends Node2D


@onready var animation = $AnimationPlayer

var door_unlocked = true
#door_unlocked for when all enemies are defeated
var is_in_door_area = false

func _ready() -> void:
	$Door/pressE.hide()
	TimerOptions.timer_unpaused()
	TimerOptions.timer_activated()

func _input(event):
	if event.is_action_pressed("interact"):
		if is_in_door_area and door_unlocked:
			animation.play("EnterKitchen")

func enter_next_room():
	get_tree().change_scene_to_file("res://level/kitchen.tscn")

func _on_door_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_door_area = true
		$Door/pressE.show()

func _on_door_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_door_area = false
		$Door/pressE.hide()
