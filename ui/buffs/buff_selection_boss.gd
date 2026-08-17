extends CanvasLayer

func _ready() -> void:
	hide()
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument: String):
	if argument == "open_boss_buffs":
		show()
	if argument == "first_boss_buffs":
		$Round1.show()
		$Round2.hide()
	if argument == "second_boss_buffs":
		$Round1.hide()
		$Round2.show()

func _on_option_1_pressed() -> void:
	if Global.round_one:
		Dialogic.start("res://dialog/timelines/Boss_End_Round_1.dtl")
		$BuffObtainedSound.play()
		await $BuffObtainedSound.finished
	if Global.round_two:
		Dialogic.start("res://dialog/timelines/Boss_End_Round_1_2.dtl")
		$BuffObtainedSound.play()
		await $BuffObtainedSound.finished
	hide()

func _on_option_2_pressed() -> void:
	if Global.round_one:
		Dialogic.start("res://dialog/timelines/Boss_End_Round_2.dtl")
		$BuffObtainedSound.play()
		await $BuffObtainedSound.finished
	if Global.round_two:
		Dialogic.start("res://dialog/timelines/Boss_End_Round_2_2.dtl")
		$BuffObtainedSound.play()
		await $BuffObtainedSound.finished
	hide()

func _on_option_3_pressed() -> void:
	if Global.round_one:
		Dialogic.start("res://dialog/timelines/Boss_End_Round_3.dtl")
		$BuffObtainedSound.play()
		await $BuffObtainedSound.finished
	if Global.round_two:
		Dialogic.start("res://dialog/timelines/Boss_End_Round_3_2.dtl")
		$BuffObtainedSound.play()
		await $BuffObtainedSound.finished
	hide()
