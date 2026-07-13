extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	TimerOptions.timer_paused()
	talking_with_boss()

func talking_with_boss():
	if Global.round_one:
		if TimerOptions.you_are_late:
			Dialogic.start("res://dialog/timelines/Boss_Bad_End_Round_1.dtl")
		else:
			Dialogic.start("res://dialog/timelines/Boss_End1_Round_1.dtl")
	if Global.round_two:
		if TimerOptions.you_are_late:
			Dialogic.start("res://dialog/timelines/Boss_Bad_End_Round_2.dtl")
		else:
			Dialogic.start("res://dialog/timelines/Boss_End1_Round_2.dtl")
	if Global.round_three:
		if TimerOptions.you_are_late:
			Dialogic.start("res://dialog/timelines/Boss_Bad_End_Round_3.dtl")
		else:
			Dialogic.start("res://dialog/timelines/Boss_End1_Round_3.dtl")

func _on_dialogic_signal(argument: String):
	if argument == "end_round_one":
		if argument == "kicked_out":
			$AnimationPlayer.play("kicked_out_of_office")
		Global.round_one = false
		Global.round_two = true
		Global.round_three = false
	if argument == "end_round_two":
		if argument == "kicked_out2":
			$AnimationPlayer.play("kicked_out_of_office")
		Global.round_one = false
		Global.round_two = false
		Global.round_three = true
	if argument == "end_round_three":
		if argument == "good_ending":
			get_tree().change_scene_to_file("res://level/good_end.tscn")
		if argument == "bad_ending":
			get_tree().change_scene_to_file("res://ui/title_screen/title_screen.tscn")
		Global.restart_game()
