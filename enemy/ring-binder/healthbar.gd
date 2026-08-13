extends Control

@onready var fill_max = $ColorRect.size.x
var fill_amount : float

func update_healthbar(health, max_health):
	fill_amount = (float(owner.health) / owner.max_health) * fill_max
	$ColorRect.size.x = fill_amount
