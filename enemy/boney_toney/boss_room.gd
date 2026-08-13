extends Node2D

var boss_door_area = false

@onready var normalboney = $NPCBoney
@onready var bossboney = $BoneyToney


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _input(event: InputEvent) -> void:
	if boss_door_area:
		print("boss room: is in boss door area")
		if event.is_action_pressed("interact"):
			get_tree().change_scene_to_file("res://level/ending.tscn")

func _on_dialogic_signal(argument: String):
	if argument == "start_boss_battle":
		pass
	if argument == "unlock_boss_door":
		boss_door_area = true
	if argument == "lock_boss_door":
		boss_door_area = false
