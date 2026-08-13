class_name FlipHandler
extends Node2D

@export_group("Player Nodes")
@export var player_hitbox_left : float
@export var player_hitbox_right : float

@export_group("Enemy Nodes")
@export var floor_collosion_position_left : float
@export var floor_collosion_position_right : float
@export var base_shape_offset_left : float
@export var base_shape_offset_right : float
@export var hitbox_shape_offset_left : float
@export var hitbox_shape_offset_right : float
@export var attack_box_shape_offset_left : float
@export var attack_box_shape_offset_right : float

const WALL_COLLISION_ROTATION_TO_LEFT = 90.0
const WALL_COLLISION_ROTATION_TO_RIGHT = 270.0

var facing_right : bool = false

func flip_entity(sprite, direction : Vector2) -> void:
	direction.x = direction.x * -1
	facing_right = direction.x > 0.0
	sprite.flip_h = facing_right
	
func player_flip_hitbox_correction(hitbox : HitBox):
	hitbox.position.x = player_hitbox_right if facing_right else player_hitbox_left


# for enemies
func flip_raycast(collision_floor : RayCast2D, collision_wall : RayCast2D) -> void:
	collision_floor.position.x = floor_collosion_position_right if facing_right else floor_collosion_position_left
	var current_rotation : float = WALL_COLLISION_ROTATION_TO_RIGHT if facing_right else WALL_COLLISION_ROTATION_TO_LEFT
	collision_wall.set_rotation_degrees(current_rotation)
	print("flip handler: flip raycast")

func apply_collision_shapes_offset(base_shape : CollisionShape2D, hitbox : HitBox, attack_box : AttackBox) -> void:
	base_shape.position.x = base_shape_offset_right if facing_right else base_shape_offset_left
	hitbox.position.x = hitbox_shape_offset_right if facing_right else hitbox_shape_offset_left
	attack_box.position.x = attack_box_shape_offset_right if facing_right else attack_box_shape_offset_left
