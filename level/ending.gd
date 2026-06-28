extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("res://dialog/timelines/Ending Temp.dtl")
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_timeline_ended():
	get_tree().change_scene_to_file("res://ui/title_screen/title_screen.tscn")
