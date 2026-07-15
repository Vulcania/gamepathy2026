extends AnimatedSprite2D

signal refill_coffee

var player_drank_coffee = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		player_drank_coffee = true
		refill_coffee.emit()
		Global.blocks_refilled()
		$Area2D.queue_free()
