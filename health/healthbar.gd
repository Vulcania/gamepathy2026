extends Node2D

@onready var max_bar_fill = %healthbar.size.x
var bar_fill_amount : float

func update_healthbar(_current_health : int, _max_health : int):
	bar_fill_amount = (float(_current_health) / _max_health) * max_bar_fill
	if bar_fill_amount > max_bar_fill:
		bar_fill_amount = max_bar_fill
	%healthbar.size.x = bar_fill_amount
