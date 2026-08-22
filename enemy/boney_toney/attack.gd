extends BossState

@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")

func enter():
	super.enter()
	await get_tree().create_timer(1).timeout
	combo()
 
func attack(move = "1"):
	animation_player.play("attack_" + move)
	await animation_player.animation_finished
	await get_tree().create_timer(2).timeout

func combo():
	var move_set = ["1","1","2"]
	for i in move_set:
		await attack(i)
 
	#combo()
 
func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)
		camera.trigger_shake()

func transition():
	if owner.direction.length() > 260:
		get_parent().change_states("Follow")
