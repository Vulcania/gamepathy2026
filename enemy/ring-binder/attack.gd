extends States

@onready var animation = $AnimationPlayer
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")

func attack():
	print("ringbinder attacks player")
	var distance = owner.direction.length()
	
	if distance < 100:
		animation.play("Attack")

func _on_attack_area_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)
		#$SFX/Attack.play()
		camera.trigger_shake()
		print("ringbinder damaging player")

func transition():
	if owner.direction.length() > 100:
		get_parent().change_state("Idle")
	if owner.hit:
		get_parent().change_state("Hurt")
