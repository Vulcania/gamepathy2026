extends Node2D

var boss_door_area = false
var in_elevator = false

@onready var normalboney = $NPCBoney
@onready var bossboney = $BoneyToney

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	#$BoneyToney.paused = true
	$BoneyToney.visible = false

func _input(event: InputEvent) -> void:
	if boss_door_area and in_elevator:
		print("boss room: is in boss door area")
		if event.is_action_pressed("interact"):
			$AnimationPlayer.play("EnterBossOffice")

func enter_boss_office():
	get_tree().change_scene_to_file("res://level/ending.tscn")

func _on_dialogic_signal(argument: String):
	if argument == "start_boss_battle":
#		$BoneyToney.paused = false
		$BoneyToney.visible = true
		$NPCBoney.hide()
	if argument == "unlock_boss_door":
		$BoneyToney.queue_free()
		$AnimationPlayer.play("CallElevator")
	if argument == "lock_boss_door":
		boss_door_area = false

func _on_door_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and boss_door_area:
		$Door/pressE.show()
		in_elevator = true

func _on_door_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		$Door/pressE.hide()
		in_elevator = false
