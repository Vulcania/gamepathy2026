extends Sprite2D
class_name Agatha

var talked_once = false
var option_one = false
var option_two = false
var option_three = false

var is_in_area = false


func _ready():
	$pressE.hide()
	BuffSelectionOne.option_one.connect(_on_option_1)
	BuffSelectionOne.option_two.connect(_on_option_2)
	BuffSelectionOne.option_three.connect(_on_option_3)

func _input(event):
	if event.is_action_pressed("interact"):
		if is_in_area:
			if !talked_once:
				talked_once = true
				Dialogic.start("res://dialog/timelines/Opening Agatha.dtl")
				return
			if talked_once && option_one:
				Dialogic.start("res://dialog/timelines/Agatha_Option1.dtl")
				return
			if talked_once && option_two:
				Dialogic.start("res://dialog/timelines/Agatha_Option2.dtl")
				return
			if talked_once && option_three:
				Dialogic.start("res://dialog/timelines/Agatha_Option3.dtl")
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
