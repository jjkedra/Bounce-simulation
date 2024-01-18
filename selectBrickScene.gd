extends Node2D

signal brick_selected(int)

# Called when the node enters the scene tree for the first time.
func _ready():
	$MetalBrick/MetalBrickButton.connect("button_down", _metal_brick_select)
	$WoodenBrick/WoodenBrickButton.connect("button_down", _wooden_brick_select)
	$HBoxContainer/CenterContainer/CancelButton.connect("button_down", _cancel)

func _metal_brick_select():
	print("_metal_brick_select")
	return_to_main_scene(10)

func _wooden_brick_select():
	print("_wooden_brick_select")
	return_to_main_scene(11)

func _cancel():
	print("_cancel")
	return_to_main_scene(-1)

func return_to_main_scene(brick_selected: int):
	emit_signal("brick_selected", brick_selected)
	get_tree().root.remove_child(self)
