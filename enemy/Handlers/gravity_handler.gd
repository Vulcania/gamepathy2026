class_name GravityHandler
extends Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func apply_gravity(entity : CharacterBody2D, delta : float):
	if not entity.is_on_floor():
		entity.velocity.y += gravity * delta
