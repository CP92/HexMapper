extends Object
class_name Hex

var v: Vector3

func _init(q: int, r: int):
	self.v = Vector3(q,r,-q - r)
	#self.v.x = q
	#self.v.y = r
	#self.v.z = -q - r	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func q():
	return v.x
	
func r():
	return v.y

func s():
	return v.z
			
