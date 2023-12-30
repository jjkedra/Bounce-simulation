extends BaseBall

class_name MagnetBall

const magnet_audio_file = "res://audio/MagnetBall.mp3"

signal area_entered(body)

# Define the magnetic properties of the ball
var magnetStrength = 50  # Adjust the strength of the magnet
var magnetRange = 1000     # Adjust the range of magnetic attraction
var isStuck = false        # Flag to track if the ball is stuck to a surface
var detectedBodies = []

func _init():
	super()
	print("AYO FROM MAGNETO")
	const physics_material_path = "res://pmaterial/metal.tres"
	var physics_material = preload(physics_material_path)
	set_physics_material_override(physics_material)

func _ready():
	$Area2D.connect("body_entered", _on_MetalEntered)
	$Area2D.connect("body_exited", _on_MetalExited)

func _on_MetalEntered(body):
	if body.is_in_group("metal"):
		if not detectedBodies.has(body):
			detectedBodies.append(body)

func _on_MetalExited(body):
	if body.is_in_group("metal"):
		if detectedBodies.has(body):
			detectedBodies.erase(body)

func _physics_process(delta):
	for body in detectedBodies:
		apply_magnetic_force(body)

func get_audio_file():
	return magnet_audio_file

func apply_magnetic_force(surface):
	var surfacePos = surface.global_position
	var ballPos = global_position
	var direction = (surfacePos - ballPos).normalized()

	var distance = surfacePos.distance_to(ballPos)
	var effectiveRange = magnetRange / 2
	var forceMultiplier = 1.0 - (distance / effectiveRange)
	forceMultiplier = clamp(forceMultiplier, 0.0, 1.0)

	var force = direction * (magnetStrength * forceMultiplier)
	apply_central_impulse(force)
