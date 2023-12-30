extends RigidBody2D

class_name BaseBrick

var freezed_brick = true

func _init():
	freeze_brick(freezed_brick)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func freeze_brick(freeze: bool):
	self.gravity_scale = 0
	set_freeze_enabled(freeze)
