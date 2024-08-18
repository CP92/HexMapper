extends Object
class_name Layout

static var orientation: Orientation
static var size: Vector2
static var origin: Vector2


func _init(orientation: Orientation, size: Vector2, origin: Vector2) -> void:
	self.orientation = orientation
	self.size = size
	self.origin = origin

func pixel_to_hex(p: Vector2) -> FractionalHex:
	var M: Orientation = self.orientation
	var pt: Vector2 = Vector2((p.x - self.origin.x) / self.size.x, 
					 		(p.y - self.origin.y) / self.size.y)
	var q: float = M.b0 * pt.x + M.b1 * pt.y
	var r: float = M.b2 * pt.x + M.b3 * pt.y
	return FractionalHex.new(q, r)

func hex_to_pixel(h: Hex) -> Vector2:
	var M: Orientation = self.orientation
	var x: float = (M.f0 * h.q() + M.f1 * h.r()) * self.size.x
	var y: float = (M.f2 * h.q() + M.f3 * h.r()) * self.size.y
	return Vector2(x + self.origin.x, y + self.origin.y)
func hex_corner_offset(corner: int) -> Vector2:
	var size: Vector2 = self.size
	var angle: float = 2.0 * PI * (self.orientation.start_angle + corner) / 6
	return Vector2(size.x * cos(angle), size.y * sin(angle))

func polygon_corners(h: Hex) -> Array:
	var corners: Array = []
	var center: Vector2 = hex_to_pixel(h)
	for i in 6:
		var offset: Vector2 = hex_corner_offset(i)
		corners.append(Vector2(center.x + offset.x, center.y + offset.y))
	return corners

func mesh_polygon_corners(mesh: MeshInstance3D) -> Array:
	var corners: Array = []
	var mesh_x: float = abs(mesh.get_aabb().size.x)
	var mesh_y: float = abs(mesh.get_aabb().size.z)
	var h: Hex = Hex.new(mesh_x, mesh_y)
	var center: Vector2 = hex_to_pixel(h)
	for i in 6:
		var offset: Vector2 = hex_corner_offset(i)
		corners.append(Vector2(center.x + offset.x, center.y + offset.y))
	return corners
