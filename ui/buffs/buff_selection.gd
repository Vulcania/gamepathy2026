extends CanvasLayer
#class_name BuffSelection


@onready var agatha = preload("res://npc/AgathaToad/agatha.tscn")
@onready var player : Player

signal option_one
signal option_two
signal option_three

func _ready() -> void:
	hide()
#	agatha = get_node("res://npc/AgathaToad/agatha.tscn")
#	player = get_node("res://player/player.tscn")
	#timer = get_node()
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_timeline_ended():
	if Dialogic.VAR.OpeningAgathaEnd:
		show()


func _on_option_1_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option1.dtl")
	option_one.emit()
	#visible = false
	queue_free()

func _on_option_2_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option2.dtl")
	option_two.emit()
	#visible = false
	queue_free()

func _on_option_3_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option3.dtl")
	option_three.emit()
	#visible = false
	queue_free()
