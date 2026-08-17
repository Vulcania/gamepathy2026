extends CanvasLayer

#signal option_one
#signal option_two
#signal option_three

func _ready() -> void:
	hide()
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument: String):
	if argument == "open_buffs2":
		show()

func _on_option_1_pressed() -> void:
#	option_one.emit()
	Dialogic.start("res://dialog/timelines/Jim_Option1.dtl")
	$BuffObtainedSound.play()
	await $BuffObtainedSound.finished
	queue_free()

func _on_option_2_pressed() -> void:
	#option_two.emit()
	Dialogic.start("res://dialog/timelines/Jim_Option2.dtl")
	$BuffObtainedSound.play()
	await $BuffObtainedSound.finished
	queue_free()

func _on_option_3_pressed() -> void:
	#option_three.emit()
	Dialogic.start("res://dialog/timelines/Jim_Option3.dtl")
	$BuffObtainedSound.play()
	await $BuffObtainedSound.finished
	queue_free()
