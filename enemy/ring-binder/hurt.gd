extends States

@onready var animation = $AnimationPlayer
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")

var can_transition: bool = false

func take_damage():
	camera.trigger_shake()
	owner.take_damage()
	can_transition = true


func transision():
	if can_transition:
		get_parent().change_state("Idle")
	if owner.health <= 0:
		get_parent().change_state("Dead")
