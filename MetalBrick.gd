extends BaseBrick

var area2d

func _init():
	super()
	self.add_to_group("metal")

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	area2d = get_node("Area2D")
	$Area2D.add_to_group("metal")
	
func resize(modifier):
	if sprite2d.scale.x + modifier > 0 and sprite2d.scale.x + modifier > 0:
		area2d.scale.x += modifier
		area2d.scale.y += modifier
	super(modifier)
