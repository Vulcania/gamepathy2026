class_name StateMachine
extends Node

@export var initial_state : States
var active_state: States

func _ready() -> void:
	for child_state: States in get_children():
		child_state.switch_state.connect(change_state)
	
	if initial_state:
		initial_state.enter_state()
		active_state = initial_state

func _process(delta: float) -> void:
	if active_state:
		active_state.update(delta)

func _physics_process(delta: float) -> void:
	if active_state:
		active_state.physics_update(delta)

func change_state(new_state: States) -> void:
	if new_state == active_state:
		return
	
	if active_state:
		active_state.exit_state()
	
	active_state = new_state
	
	if active_state:
		active_state.enter_state()
