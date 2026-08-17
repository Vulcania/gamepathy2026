extends CanvasLayer
#class_name BuffSelection


@onready var agatha = preload("res://npc/AgathaToad/agatha.tscn")
@onready var player : Player

signal option_one
signal option_two
signal option_three

func _ready() -> void:
	hide()
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument: String):
	if argument == "open_buff_selection_1":
		show()

func _on_option_1_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option1.dtl")
	option_one.emit()
	$BuffObtainedSound.play()
	await $BuffObtainedSound.finished
	queue_free()

func _on_option_2_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option2.dtl")
	option_two.emit()
	$BuffObtainedSound.play()
	await $BuffObtainedSound.finished
	queue_free()

func _on_option_3_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option3.dtl")
	option_three.emit()
	$BuffObtainedSound.play()
	await $BuffObtainedSound.finished
	queue_free()
