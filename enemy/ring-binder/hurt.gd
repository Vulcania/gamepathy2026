extends BossState

@onready var animation = $AnimationPlayer
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")

var hit = false

var can_transition: bool = false

func take_damage():
	print("ringbinder hurt: take damage")
	print(owner.health, "ringbinder health")
	camera.trigger_shake()
	owner.take_damage(1)
	can_transition = true

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		hit = true
		print("ringbinder hurt: hit area entered", area)
		take_damage()
		if hit:
			hit = !hit

func transision():
	if can_transition:
		get_parent().change_state("Idle")
	if owner.health <= 0:
		get_parent().change_state("Dead")
