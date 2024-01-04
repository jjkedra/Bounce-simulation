extends BaseBall

class_name MagnetBall

const magnet_audio_file = "res://audio/MagnetBall.mp3"

var detectedSouthAreasNORTH = []
var detectedNorthAreasNORTH = []
var detectedMetalAreasNORTH = []

var detectedSouthAreasSOUTH = []
var detectedNorthAreasSOUTH = []
var detectedMetalAreasSOUTH = []

func _init():
	super()
	print("AYO FROM MAGNETO")
	const physics_material_path = "res://pmaterial/metal.tres"
	var physics_material = preload(physics_material_path)
	set_physics_material_override(physics_material)

func _ready():
	$NorthArea.add_to_group("north")
	$SouthArea.add_to_group("south")
	$NorthArea.connect("area_entered", _on_NorthAreaEntered)
	$NorthArea.connect("area_exited", _on_NorthAreaExited)
	$SouthArea.connect("area_entered", _on_SouthAreaExited)
	$SouthArea.connect("area_exited", _on_SouthAreaExited)
	
	# Check for bodies already inside the area


func get_audio_file():
	return magnet_audio_file

func _on_NorthAreaEntered(area):
	if area.is_in_group("metal"):
		if not detectedMetalAreasNORTH.has(area):
			detectedMetalAreasNORTH.append(area)
	elif area.is_in_group("north"):
		if not detectedNorthAreasNORTH.has(area):
			print("NORTH DETECTED ON NORTH")
			detectedNorthAreasNORTH.append(area)
	elif area.is_in_group("south"):
		if not detectedSouthAreasNORTH.has(area):
			print("SOUTH DETECTED ON NORTH")
			detectedSouthAreasNORTH.append(area)

func _on_NorthAreaExited(area):
	if area.is_in_group("metal"):
		if detectedMetalAreasNORTH.has(area):
			detectedMetalAreasNORTH.erase(area)
	elif area.is_in_group("north"):
		if detectedNorthAreasNORTH.has(area):
			detectedNorthAreasNORTH.erase(area)
	elif area.is_in_group("south"):
		if detectedSouthAreasNORTH.has(area):
			detectedSouthAreasNORTH.erase(area)

func _on_SouthAreaEntered(area):
	if area.is_in_group("metal"):
		if not detectedMetalAreasSOUTH.has(area):
			detectedMetalAreasSOUTH.append(area)
	elif area.is_in_group("north"):
		if not detectedNorthAreasSOUTH.has(area):
			print("NORTH DETECTED ON SOUTH")
			detectedNorthAreasSOUTH.append(area)
	elif area.is_in_group("south"):
		if not detectedSouthAreasSOUTH.has(area):
			print("SOUTH DETECTED ON SOUTH")
			detectedSouthAreasSOUTH.append(area)

func _on_SouthAreaExited(area):
	if area.is_in_group("metal"):
		if detectedMetalAreasSOUTH.has(area):
			detectedMetalAreasSOUTH.erase(area)
	elif area.is_in_group("north"):
		if detectedNorthAreasSOUTH.has(area):
			detectedNorthAreasSOUTH.erase(area)
	elif area.is_in_group("south"):
		if detectedSouthAreasSOUTH.has(area):
			detectedSouthAreasSOUTH.erase(area)

func _physics_process(delta):
	# Check for overlapping bodies
	var overlapping_bodies = $NorthArea.get_overlapping_areas()
	for area in overlapping_bodies:
		_on_NorthAreaEntered(area)
	overlapping_bodies = $SouthArea.get_overlapping_areas()
	for area in overlapping_bodies:
		_on_SouthAreaEntered(area)
	# NORTH POLE
	for metal_area_n in self.detectedMetalAreasNORTH:
		apply_magnetic_force(metal_area_n, 1)
	for south_area_n in self.detectedSouthAreasNORTH:
		apply_magnetic_force(south_area_n, 1)
	for north_area_n in self.detectedNorthAreasNORTH:
		apply_magnetic_force(north_area_n, 0)

	# SOUTH POLE
	for metal_area_s in self.detectedMetalAreasSOUTH:
		apply_magnetic_force(metal_area_s, 1)
	for south_area_s in self.detectedSouthAreasSOUTH:
		apply_magnetic_force(south_area_s, 0)
	for north_area_s in self.detectedNorthAreasSOUTH:
		apply_magnetic_force(north_area_s, 1)

func calculate_opposite_pole_overlap(north_area, south_area):
	var overlap_area = north_area.overlapping_area(south_area)
	return overlap_area

func apply_magnetic_force(area, force_type):
	var force_direction = Vector2.ZERO

	if force_type == 0:  # Repulsion
		force_direction = (global_position - area.global_position).normalized()
	elif force_type == 1:  # Attraction
		force_direction = (area.global_position - global_position).normalized()
	var distance = global_position.distance_to(area.global_position)
	var force_magnitude = 1000.0 / distance  # You can adjust this value for the strength of the force
	var force = force_direction * force_magnitude
	self.apply_central_impulse(force)  # Apply force to self in opposite direction
