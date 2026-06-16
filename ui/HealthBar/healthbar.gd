extends Control

@onready var max_bar_fill = %healthbar.size.x
var bar_fill_amount : float

func update_healthbar(current_health, max_health):
	bar_fill_amount = (float(current_health) / max_health) * max_bar_fill
	%healthbar.size.x = bar_fill_amount
