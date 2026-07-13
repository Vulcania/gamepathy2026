extends AnimatedSprite2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		Global.blocks_refilled()
#		area.get_parent().update_block_display()
		$Area2D.queue_free()
