extends BaseBall

class_name RubberBall

const rubber_audio_file = "res://audio/RubberBall.mp3"

func _init():
	super()
	print("AYO FROM RUBBER")
	const physics_material_path = "res://pmaterial/rubber.tres"
	var physics_material = preload(physics_material_path)
	set_physics_material_override (physics_material)

func get_audio_file():
	return rubber_audio_file
