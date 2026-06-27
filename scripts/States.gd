extends Node
class_name States

signal switch_state(state: States)

func enter_state() -> void:
	pass # Play Animation

func update(_delta : float) -> void:
	pass # Conditions for State to switch

func physics_update(_delta : float) -> void:
	pass # Which ruleset applies to movement

func exit_state() -> void:
	pass # Exit state
