class_name JumpHandler
extends Node2D

@export var jump_velocity : float = 0.0
@export var decelerate_on_jump_release : float = 0.0

func handle_jump(entity : CharacterBody2D, is_jumping : bool, is_jump_released : bool) -> void:
	if is_jumping and entity.is_on_floor():
		entity.velocity.y = -jump_velocity

	if is_jump_released and entity.velocity.y < 0:
		entity.velocity.y *= decelerate_on_jump_release
