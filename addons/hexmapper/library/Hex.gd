extends Object
class_name Hex

var v: Vector3

func _init(q: int, r: int):
	self.v = Vector3(q,r,-q - r)

func q():
	return v.x
	
func r():
	return v.y

func s():
	return v.z
