extends StaticBody3D
class_name HexTileStatic

var cord = []

var hex: Hex

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	#print(str("Entered", cord)) # Replace with function body.
	print(self.hex.v)
	enable_highlight()

func _on_mouse_exited():
	#print(str("Exit", cord)) # Replace with function body.
	disable_highlight()

func set_hex(hex: Hex):
	self.hex = hex

func get_mesh() -> MeshInstance3D:
	return $HexTileMesh

func get_collider() -> CollisionShape3D:
	return $CollisionShape3D

func enable_highlight():
	var mesh = $HexTileMesh as MeshInstance3D
	mesh.set_tile_to_selected()
	
func disable_highlight():
	var mesh = $HexTileMesh as MeshInstance3D
	mesh.set_tile_to_unselected()
