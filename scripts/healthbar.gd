extends Node2D

@onready var max_bar_fill = $ColorRect.size.x
var bar_fill_amount : float

func update_healthbar(current_health : int, max_health : int):
	bar_fill_amount = (float(current_health) / max_health) * max_bar_fill
	if bar_fill_amount > max_bar_fill:
		bar_fill_amount = max_bar_fill
	$ColorRect.size.x = bar_fill_amount
