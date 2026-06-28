extends Sprite2D

var talked_once = false
var option_one = false
var option_two = false
var option_three = false

var is_in_area = false


func _ready():
	$pressE.hide()
	BuffSelectionTwo.option_one.connect(_on_option_1)
	BuffSelectionTwo.option_two.connect(_on_option_2)
	BuffSelectionTwo.option_three.connect(_on_option_3)

func _input(event):
	if event.is_action_pressed("interact"):
		if is_in_area:
			if !talked_once:
				talked_once = true
				Dialogic.start("res://dialog/timelines/Jim Main.dtl")
				return

func _on_option_1():
	option_one = true

func _on_option_2():
	option_two = true

func _on_option_3():
	option_three = true

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		$pressE.show()
		is_in_area = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_in_area = false
		$pressE.hide()
