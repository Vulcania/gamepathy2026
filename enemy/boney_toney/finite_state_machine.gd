extends Node2D

enum State {Idle, Follow, Attack, Teleport, SpawnMinion, Death}
var Idle = get_child(0)
var Follow = get_child(1)

var current_state: State
var previous_state: State
 
func _ready():
	current_state = State.Idle
	previous_state = current_state
	current_state.enter()
 
func change_state(state):
	current_state = find_child(state)
	current_state.enter()
	print("fsm change state")
 
	previous_state.exit()
	previous_state = current_state
