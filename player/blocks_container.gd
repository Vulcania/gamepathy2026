extends HBoxContainer
class_name Block_Manager

@onready var blocks_gui_class = preload("res://player/player assets/block.tscn")

func set_max_blocks(max_blocks : int):
	for i in range(max_blocks):
		var block = blocks_gui_class.instantiate()
		add_child(block)

func update_blocks(current_block_count = get_parent().current_block_count):
	var blocks = get_children()
	
	for i in range(current_block_count):
		blocks[i].update(true)
	
	for i in range(current_block_count, blocks.size()):
		blocks[i].update(false)

#func hide_outside_levels():
#	if Global.in_game:
#		$".".visible = true
#	if not Global.in_game:
#		$".".visible = false
