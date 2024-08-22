extends MeshInstance3D

var hex_globals = get_node("/root/" + "HexGlobals")
var selected_material 
var unselected_material
# Called when the node enters the scene tree for the first time.
func _ready():
	self.mesh = hex_globals.hex_mesh
	self.create_convex_collision()
	set_surface_override_material(0, unselected_material)# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_tile_to_selected():
	set_surface_override_material(0, selected_material)

func set_tile_to_unselected():
	set_surface_override_material(0, unselected_material)
