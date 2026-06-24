extends Sprite2D

var talked_once = false

func _ready() -> void:
	$pressE.hide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && not talked_once:
		$pressE.show()
		if Input.is_action_pressed("interact"):
			talked_once = true
			Dialogic.start_timeline("Opening Agatha")
	if area.get_parent() is Player && talked_once:
		$pressE.show()
		if Input.is_action_pressed("interact"):
			Dialogic.start_timeline("Agatha Default")
	else:
		$pressE.hide()
