extends RigidBody2D

class_name BaseBall

var audio_file = ""
var trigger_cooldown = 0.3  # Cooldown time in seconds
var trigger_timer = 0  # Timer to keep track of cooldown
var can_trigger = true  # Flag to control triggering
var freezed_ball = true # Flag to pause the ball (when moving etc.)
var can_grab = false    # Flag for editing
const wood_audio_file = "res://audio/WoodenBall.mp3"

var sprite2d
var collision_shape2d

func _init():
	print("AYO FROM BASE")
	freeze_ball(freezed_ball)
	self.max_contacts_reported = 5
	self.contact_monitor = true

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite2d = get_node("Sprite2D")
	collision_shape2d = get_node("CollisionShape2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if !can_trigger:
			trigger_timer += delta
			if trigger_timer >= trigger_cooldown:
				trigger_timer = 0
				can_trigger = true

func get_audio_file():
	return wood_audio_file

func freeze_ball(freeze: bool):
	set_freeze_enabled(freeze)

func _on_Ball_body_entered(body):
	var ball_player = AudioStreamPlayer.new()
	add_child(ball_player)
	if can_trigger:
		var sfx = load(get_audio_file())
		if sfx:
			sfx.set_loop(false)
			ball_player.set_stream(sfx)
			ball_player.play()
			# Start cooldown
			can_trigger = false
			
func resize(modifier):
	if sprite2d.scale.x + modifier > 0 and sprite2d.scale.x + modifier > 0:
		sprite2d.scale.x += modifier
		sprite2d.scale.y += modifier
		collision_shape2d.scale.x += modifier
		collision_shape2d.scale.y += modifier

