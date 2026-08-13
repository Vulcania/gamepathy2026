extends Node

var max_enemies_in_lvl: int = 0
var defeated_enemies: int = 0
var coffee_break = false

var restart = false

#rounds
var round_one = true
var round_two = false
var round_three = false
var boss_deafeated = false

func _ready():
	if Dialogic.current_timeline != null:
		return

func restart_game():
	TimerOptions.restart_game()
	round_one = true
	restart = true
	boss_deafeated = false

func blocks_refilled():
	coffee_break = true
	coffee_break = !coffee_break
	print("coffee_break")

func enemy_counter_lvl_one():
	max_enemies_in_lvl = 2
	defeated_enemies = 0

func enemy_counter_lvl_two():
	max_enemies_in_lvl += 5

func enemy_counter_lvl_three():
	max_enemies_in_lvl += 5
