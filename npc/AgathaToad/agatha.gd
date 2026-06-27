extends Sprite2D
class_name Agatha

var talked_once = false
var option_one = false
var option_two = false
var option_three = false

func _ready():
	$pressE.hide()

func option_1():
	option_one = true

func option_2():
	option_two = true

func option_3():
	option_three = true
	
func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !talked_once:
		$pressE.show()
		if Input.is_action_just_pressed("interact"):
			talked_once = true
			Dialogic.start("res://dialog/timelines/Opening Agatha.dtl")
	if area.get_parent() is Player && talked_once && option_one:
		$pressE.show()
		if Input.is_action_just_pressed("interact"):
			Dialogic.start("res://dialog/timelines/Agatha_Option1.dtl")
	if area.get_parent() is Player && talked_once && option_two:
		$pressE.show()
		if Input.is_action_just_pressed("interact"):
			Dialogic.start("res://dialog/timelines/Agatha_Option2.dtl")
	if area.get_parent() is Player && talked_once && option_three:
		$pressE.show()
		if Input.is_action_just_pressed("interact"):
			Dialogic.start("res://dialog/timelines/Agatha_Option3.dtl")
	else:
		$pressE.hide()
