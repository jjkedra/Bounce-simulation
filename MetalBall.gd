extends BaseBall

class_name MetalBall

const metal_audio_file = "res://audio/MetalBall.mp3"

func _init():
	super()
	print("AYO FROM METAL")
	const physics_material_path = "res://pmaterial/metal.tres"
	var physics_material = preload(physics_material_path)
	set_physics_material_override(physics_material)

func get_audio_file():
	return metal_audio_file
