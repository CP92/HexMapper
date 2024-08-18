class_name PointyLayout
extends Layout

func _init(size: Vector2, origin: Vector2):
	self.orientation = Orientation.new(
		sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0,
		sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5)
	self.size = size
	self.origin = origin
