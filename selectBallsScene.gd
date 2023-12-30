extends Node2D

signal ball_selected(int)

# Called when the node enters the scene tree for the first time.
func _ready():
	$BaseBall/BaseBallButton.connect("button_down", _base_ball_select)
	$MetalBall/MetalBallButton.connect("button_down", _metal_ball_select)
	$RubberBall/RuberBallButton.connect("button_down", _rubber_ball_select)
	$MagnetBall/MagnetButton.connect("button_down", _magnet_ball_select)

func _base_ball_select():
	print("_base_ball_select")
	return_to_main_scene(0)

func _metal_ball_select():
	print("_metal_ball_select")
	return_to_main_scene(1)

func _rubber_ball_select():
	print("_rubber_ball_select")
	return_to_main_scene(2)

func _magnet_ball_select():
	print("_magnet_ball_select")
	return_to_main_scene(3)

func return_to_main_scene(ballChoice: int):
	emit_signal("ball_selected", ballChoice)
	get_tree().root.remove_child(self)

