extends RigidBody2D

class_name BaseBrick

var freezed_brick = true

var sprite2d
var collision_shape2d

func _init():
	freeze_brick(freezed_brick)

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite2d = get_node("Sprite2D")
	collision_shape2d = get_node("CollisionShape2D")

func freeze_brick(freeze: bool):
	self.gravity_scale = 0
	set_freeze_enabled(freeze)
			
func resize(modifier):
	if sprite2d.scale.x + modifier > 0 and sprite2d.scale.x + modifier > 0:
		sprite2d.scale.x += modifier
		sprite2d.scale.y += modifier
		collision_shape2d.scale.x += modifier
		collision_shape2d.scale.y += modifier
