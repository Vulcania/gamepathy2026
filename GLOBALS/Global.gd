extends Node

var max_enemies_in_lvl: int = 0
var defeated_enemies: int = 0

func _ready():
	if Dialogic.current_timeline != null:
		return

func enemy_counter_lvl_one():
	max_enemies_in_lvl = 5
	defeated_enemies = 0

func enemy_counter_lvl_two():
	max_enemies_in_lvl += 5

func enemy_counter_lvl_three():
	max_enemies_in_lvl += 5
