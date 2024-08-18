extends Hex
class_name FractionalHex

func _init(q: float, r: float):
	self.v = Vector3(q,r,-q - r)
	
