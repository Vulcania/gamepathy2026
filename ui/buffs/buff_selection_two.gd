extends CanvasLayer

signal option_one
signal option_two
signal option_three

func _ready() -> void:
	hide()
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_timeline_ended():
	if Dialogic.VAR.OpeningAgathaEnd:
		show()

func _on_option_1_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option1.dtl")
	option_one.emit()
	queue_free()

func _on_option_2_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option2.dtl")
	option_two.emit()
	queue_free()

func _on_option_3_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option3.dtl")
	option_three.emit()
	queue_free()
