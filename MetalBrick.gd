extends BaseBrick

func _init():
	super()
	self.add_to_group("metal")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.add_to_group("metal")
