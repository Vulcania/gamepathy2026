extends Sprite2D

var talked_once = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && not talked_once:
		talked_once = true
		pass
	if area.get_parent() is Player && talked_once:
		pass
