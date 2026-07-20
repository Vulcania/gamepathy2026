class_name FlipHandler
extends Node2D


func flip_entity(entity : CharacterBody2D, sprite : AnimatedSprite2D):
	if entity.velocity.x > 0.0:
		sprite.flip_h = false
	
	if entity.velocity.x < 0.0:
		sprite.flip_h = true
