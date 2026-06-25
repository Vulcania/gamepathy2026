extends Sprite2D

var talked_once = false

func _ready():
	$pressE.hide()

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !talked_once:
		$pressE.show()
		if Input.is_action_just_pressed("interact"):
			talked_once = true
			Dialogic.start("res://dialog/timelines/Opening Agatha.dtl")
	if area.get_parent() is Player && talked_once:
		$pressE.show()
		if Input.is_action_just_pressed("interact"):
			Dialogic.start("res://dialog/timelines/Agatha Default.dtl")
	else:
		$pressE.hide()
