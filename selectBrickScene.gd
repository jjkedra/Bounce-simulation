extends Node2D

signal brick_selected(int)

# Called when the node enters the scene tree for the first time.
func _ready():
	$MetalBrick/MetalBrickButton.connect("button_down", _metal_brick_select)

func _metal_brick_select():
	print("_metal_brick_select")
	return_to_main_scene(3)

func return_to_main_scene(brick_selected: int):
	emit_signal("brick_selected", brick_selected)
	get_tree().root.remove_child(self)
