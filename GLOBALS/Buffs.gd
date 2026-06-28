extends Resource
class_name Buffs

signal buffs_applied(buffs : Buffs)
signal buffs_reset #when game is reset

@export_group("Buffs Data")
@export var id: String

@export_group("Buffs Visuals")
@export var icon: Texture

func initialize_buffs(_target: Node) -> void:
	pass

func apply_buffs(_target: Node) -> void:
	buffs_applied.emit(self)
