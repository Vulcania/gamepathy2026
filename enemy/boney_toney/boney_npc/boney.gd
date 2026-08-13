extends Sprite2D

var is_in_area = false

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = true
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = false

func _input(event):
	if event.is_action_pressed("interact"):
		if is_in_area:
			if Global.round_one:
				Dialogic.start("res://dialog/timelines/Boney_FirstConfrontation.dtl")
			if Global.round_two:
				Dialogic.start("res://dialog/timelines/Boney_SecondConfrontation.dtl")
			if Global.round_three:
				Dialogic.start("res://dialog/timelines/Boney_ThirdConfrontation.dtl")

func _on_dialogic_signal(argument: String):
	if argument == "start_boss_battle":
		pass
	if argument == "boss_battle_1":
		pass
	if argument == "boss_battle_2":
		pass
	if argument == "boss_battle_3":
		pass
