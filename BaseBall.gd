extends RigidBody2D

class_name BaseBall

var audio_file = ""
var trigger_cooldown = 0.3  # Cooldown time in seconds
var trigger_timer = 0  # Timer to keep track of cooldown
var can_trigger = true  # Flag to control triggering


func _init():
	print("AYO FROM BASE")
	self.max_contacts_reported = 5
	self.contact_monitor = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !can_trigger:
		trigger_timer += delta
		if trigger_timer >= trigger_cooldown:
			trigger_timer = 0
			can_trigger = true

func get_audio_file():
	return audio_file

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

