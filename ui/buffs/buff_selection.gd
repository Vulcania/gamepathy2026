extends Control
class_name BuffSelection

var agatha
var player

var buff_list : Array[TextureRect]

func _ready() -> void:
	agatha = get_node("res://npc/AgathaToad/agatha.tscn")
	player = get_node("res://player/player.tscn")

func _on_option_1_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option1.dtl")
	agatha.option_1()

func _on_option_2_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option2.dtl")
	agatha.option_2()

func _on_option_3_pressed() -> void:
	Dialogic.start("res://dialog/timelines/Agatha_Option3.dtl")
	agatha.option_3()
