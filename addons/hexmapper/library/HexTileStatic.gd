extends StaticBody3D
class_name HexTileStatic

var cord = []

var hex: Hex

func _on_mouse_entered():
	print(self.hex.v)
	enable_highlight()

func _on_mouse_exited():
	disable_highlight()

func set_properties(hex: Hex, mesh: Mesh):
	set_hex(hex)
	set_mesh(mesh)
	set_collision()

func set_collision():
	$HexTileCollision.make_convex_from_siblings()

func set_hex(hex: Hex):
	self.hex = hex

func get_mesh() -> MeshInstance3D:
	return $HexTileMesh

func set_mesh(mesh: Mesh):
	$HexTileMesh.mesh = mesh

func get_collider() -> CollisionShape3D:
	return $HexTileCollision

func enable_highlight():
	var mesh = $HexTileMesh as MeshInstance3D
	mesh.set_tile_to_selected()
	
func disable_highlight():
	var mesh = $HexTileMesh as MeshInstance3D
	mesh.set_tile_to_unselected()
