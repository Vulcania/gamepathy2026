extends BossState

@onready var animation = $AnimationPlayer
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")


func enter():
	super.enter()
	animation.play("Death")
	#$SFX/Dying.play()
