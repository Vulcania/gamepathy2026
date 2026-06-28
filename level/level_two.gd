extends Node2D

@onready var animation = $Door/AnimationPlayer

var door_unlocked = false

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func enter_next_room():
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && door_unlocked:
		animation.play("door_opened")
