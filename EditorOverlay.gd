extends Node2D

const default_gravity = 980

var selectBallsScene = preload("res://selectBallsScene.tscn").instantiate()
var selectBrickScene = preload("res://selectBrickScene.tscn").instantiate()
var selectedScene = null
var panned_item = null
var panning = false
var started = false

var g_slider
var h_slider
var v_slider
var grid
var ruler

var g_start_drag_value = default_gravity

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/CenterContainer2/BButton.connect("pressed", _on_balls_button_pressed)
	$VBoxContainer/HBoxContainer/CenterContainer3/PButton.connect("pressed", _on_brick_button_pressed)
	$VBoxContainer/HBoxContainer/CenterContainer/MarginContainer/StartButton.connect("pressed", _start_game)
	$VBoxContainer/HBoxContainer2/CenterContainer/RestartButton.connect("pressed", _restart_game)
	$VBoxContainer/HBoxContainer2/CenterContainer2/GridButton.connect("pressed", _on_grid_button_pressed)
	selectBallsScene.connect("ball_selected", _on_data_received)
	selectBrickScene.connect("brick_selected", _on_data_received)
	
	g_slider = $VBoxContainer/HBoxContainer2/CenterContainer3/VBoxContainer/GSlider
	h_slider = $HSlider
	v_slider = $VSlider
	grid = $TextureRect
	ruler = $RulerLabel

func _on_balls_button_pressed():
	selectedScene = selectBallsScene
	handle_scene_selection()
	started = false

func _on_brick_button_pressed():
	selectedScene = selectBrickScene
	handle_scene_selection()
	started = false

func _start_game():
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.freeze_ball(false)
	for brick in get_tree().get_nodes_in_group("bricks"):
		brick.freeze_brick(false)
	started = true

func _restart_game():
	for ball in get_tree().get_nodes_in_group("balls"):
		remove_child(ball)
	for brick in get_tree().get_nodes_in_group("bricks"):
		remove_child(brick)
	PhysicsServer2D.area_set_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, default_gravity)
	PhysicsServer2D.area_set_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2(0, 1))
	g_slider.value = default_gravity
	h_slider.value = 0
	v_slider.value = 1
	g_start_drag_value = default_gravity
	started = false
	
func _on_grid_button_pressed():
	grid.visible = !grid.visible
	ruler.visible = grid.visible

func _pause_game():
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.freeze_ball(true)
	for brick in get_tree().get_nodes_in_group("bricks"):
		brick.freeze_brick(true)

func _on_data_received(data):
	print("Data: ", data)
	self.showScene()
	if data != -1:
		spawn_entity(data)

# Code to spawn the selected entity at mouse position
func spawn_entity(entity_type: int):  # Assuming entity_type is passed to decide the type of entity to spawn
	var entity = load_entity_from_type(entity_type)  # Load the entity scene based on type
	var new_entity = entity.instantiate()  # Create an instance of the entity scene
	new_entity.position = get_global_mouse_position()  # Place the entity at the mouse position
	add_child(new_entity)  # Add the entity to the scene tree

	if entity_type <= 9 and entity_type >= 0:
		new_entity.add_to_group("balls")
	elif entity_type >= 10:
		new_entity.add_to_group("bricks")
	panning = true
	panned_item = new_entity

func load_entity_from_type(entity_type: int) -> PackedScene:
	var entity_scene_path = ""  # Placeholder for the path to entity scenes based on type
	
	# Determine the path to entity scenes based on the provided entity_type
	match entity_type:
		0:
			entity_scene_path = "res://BaseBall.tscn"
		1:
			entity_scene_path = "res://MetalBall.tscn"
		2:
			entity_scene_path = "res://RubberBall.tscn" 
		3:
			entity_scene_path = "res://MagnetBall.tscn" 
		10:
			entity_scene_path = "res://MetalBrick.tscn" 
		11:
			entity_scene_path = "res://WoodenBrick.tscn" 
	# Load the PackedScene for the entity based on the determined path
	var entity_scene = load(entity_scene_path)
	return entity_scene

func _input(event):
	if panning:
		if event is InputEventMouseMotion:
			if event.button_mask == MOUSE_BUTTON_LEFT:  # Check if left mouse button is pressed
				var mouse_pos = get_global_mouse_position()
				panned_item.position = mouse_pos
		elif event is InputEventKey:
			if event.is_action("ui_right"):
				panned_item.rotation_degrees += 2
			elif event.is_action("ui_left"):
				panned_item.rotation_degrees -= 2
			elif event.is_action("ui_up"):
				panned_item.resize(0.05)
			elif event.is_action("ui_down"):
				panned_item.resize(-0.05)
		else:
			if event is InputEventMouseButton:
				if event.button_mask == MOUSE_BUTTON_LEFT and event.pressed:
					panning = false
					panned_item = null

func _on_g_slider_drag_started():
	g_start_drag_value = PhysicsServer2D.area_get_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY)

func _on_g_slider_value_changed(value):
	var prev_value = PhysicsServer2D.area_get_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY)
	PhysicsServer2D.area_set_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, value)
	if (prev_value == 0 or g_start_drag_value == 0) and started:
		_pause_game()
		_start_game()

func _on_h_slider_value_changed(value):
	PhysicsServer2D.area_set_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2(value, v_slider.value))
	if PhysicsServer2D.area_get_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY) != 0 and started:
		_pause_game()
		_start_game()

func _on_v_slider_value_changed(value):
	PhysicsServer2D.area_set_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2(h_slider.value, value))
	if PhysicsServer2D.area_get_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY) != 0 and started:
		_pause_game()
		_start_game()

func hideScene():
	self.visible = false

func showScene():
	self.visible = true

func handle_scene_selection():
	self._pause_game()
	if selectedScene:
		self.hideScene()
		get_tree().root.add_child(selectedScene)
