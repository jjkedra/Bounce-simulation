extends BaseBall

class_name MetalBall

const metal_audio_file = "res://audio/MetalBall.mp3"

var area2d

func _init():
	super()
	print("AYO FROM METAL")
	const physics_material_path = "res://pmaterial/metal.tres"
	var physics_material = preload(physics_material_path)
	set_physics_material_override(physics_material)

func _process(delta):
	pass

func _ready():
	super()
	area2d = get_node("Area2D")
	$Area2D.add_to_group("metal")

func get_audio_file():
	return metal_audio_file
	
func resize(modifier):
	if sprite2d.scale.x + modifier * 0.2 > 0 and sprite2d.scale.x + modifier * 0.2 > 0:
		sprite2d.scale.x += modifier * 0.2
		sprite2d.scale.y += modifier * 0.2
		collision_shape2d.scale.x += modifier
		collision_shape2d.scale.y += modifier
		area2d.scale.x += modifier
		area2d.scale.y += modifier
