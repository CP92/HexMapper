extends MeshInstance3D

var selected_material 
var unselected_material

func _ready():
	set_surface_override_material(0, unselected_material)

func set_tile_to_selected():
	set_surface_override_material(0, selected_material)

func set_tile_to_unselected():
	set_surface_override_material(0, unselected_material)
