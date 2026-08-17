extends AnimatedSprite2D

signal refill_coffee

var player_drank_coffee = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		player_drank_coffee = true
		print(player_drank_coffee)
		coffee_signal()
		Global.blocks_refilled()
#		$Area2D.hide()

func coffee_signal():
#	if player_drank_coffee:
		emit_signal("refill_coffee")
		Global.blocks_refilled()
		print("the signal is emitting")
