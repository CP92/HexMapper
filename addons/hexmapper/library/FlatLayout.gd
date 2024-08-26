class_name FlatLayout
extends Layout


func _init(size: Vector2, origin: Vector2):
	self.orientation = Orientation.new(
3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0),
2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0, 0.0)
	self.size = size
	self.origin = origin
