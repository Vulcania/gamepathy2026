extends Area2D

func _ready() -> void:
	var layout = Dialogic.start("res://dialog/timelines/SkullNote_DontDie.dtl")
	layout.register_character(load("res://dialog/characters/skull.dch"), $Marker2D)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		print("player entered skull area")
		Dialogic.start("res://dialog/timelines/SkullNote_DontDie.dtl")
		$Laugh.play()
