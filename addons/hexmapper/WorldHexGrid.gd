class_name WorldHexGrid
extends Node3D

const HEX_TILE = preload("res://addons/hexmapper/hex_tile_static.tscn")
var hex_globals = get_node("/root/" + "HexGlobals")

var map = {}
var selected_layout
# Called when the node enters the scene tree for the first time.
func _ready():
	print(hex_globals.map_shape)
	match hex_globals.map_shape:
		"Hexagon":
			genHexMap()
		"Rectangle":
			genRectangleMap()
		"Triangle":
			genTriangleMap()
		"Parallelogram":
			genParallelogramMap()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match hex_globals.map_shape:
		"Hexagon":
			genHexMap()
		"Rectangle":
			genRectangleMap()
		"Triangle":
			genTriangleMap()
		"Parallelogram":
			genParallelogramMap()

func genRectangleMap():
	var map_size = max(hex_globals.map_width, hex_globals.map_depth)
	
	match hex_globals.orientation:
		'flat':
			print("Flat")
			
			for q in range(hex_globals.map_width):
				var qoff = floor(q/2.0)
				for r in range(-qoff, hex_globals.map_depth - qoff):
					var hex_tile = HEX_TILE.instantiate()
					var mesh_aabb = hex_tile.get_mesh().global_transform * hex_tile.get_mesh().get_aabb()
					
					var new_mesh_z: float = mesh_aabb.size.z / 2
					
					selected_layout = FlatLayout.new(Vector2(new_mesh_z, new_mesh_z), Vector2.ZERO)
					var hex = Hex.new(q, r)
					
					hex_tile.set_hex(hex)
					map[hex_tile] = null
		'pointy':
			print("Pointy")
			for r in range(hex_globals.map_depth):
				var roff = floor(r/2.0)
				for q in range(-roff, hex_globals.map_width - roff):
					var hex_tile = HEX_TILE.instantiate()
					var mesh = hex_tile.get_mesh()
					var collider = hex_tile.get_collider()
					
					mesh.rotate_y(deg_to_rad(30))
					collider.rotate_y(deg_to_rad(30))
					
					var mesh_aabb = mesh.global_transform * hex_tile.get_mesh().get_aabb()
					
					var new_mesh_z: float = mesh_aabb.size.z / 2
					
					selected_layout = PointyLayout.new(Vector2(new_mesh_z, new_mesh_z), Vector2.ZERO)
					var hex = Hex.new(q, r)
					hex_tile.set_hex(hex)
					map[hex_tile] = null
	
	for i in map.keys():
		add_child(i)
		var pixel = selected_layout.hex_to_pixel(i.hex)					
		i.translate(Vector3(pixel.x, 0, pixel.y))	

func genTriangleMap():
	
	var map_size = max(hex_globals.map_width, hex_globals.map_depth)
	
	for q in range(map_size + 1):
		for r in range((map_size - q) + 1):
			buildMapCords(q, r)

	for i in map.keys():
		add_child(i)
		var pixel = selected_layout.hex_to_pixel(i.hex)					
		i.translate(Vector3(pixel.x, 0, pixel.y))

func genParallelogramMap():
	var map_size = max(hex_globals.map_width, hex_globals.map_depth)
	
	for q in range(map_size + 1):
		for r in range(map_size + 1):
			buildMapCords(q, r)

	for i in map.keys():
		add_child(i)
		var pixel = selected_layout.hex_to_pixel(i.hex)					
		i.translate(Vector3(pixel.x, 0, pixel.y))
		
func genHexMap():
	var map_size = max(hex_globals.map_width, hex_globals.map_depth)
	
	for q in range(-map_size, map_size + 1):
		var r1 = max(-map_size, -q - map_size)
		var r2 = min(map_size, -q + map_size)
		for r in range(r1, r2 + 1):
			buildMapCords(q, r)
			
	
	for i in map.keys():
		add_child(i)
		var pixel = selected_layout.hex_to_pixel(i.hex)					
		i.translate(Vector3(pixel.x, 0, pixel.y))

func buildMapCords(q, r):
	match hex_globals.orientation:
				'flat':
					print("Flat")
					
					var hex_tile = HEX_TILE.instantiate()
					var mesh_aabb = hex_tile.get_mesh().global_transform * hex_tile.get_mesh().get_aabb()
					
					var new_mesh_z: float = mesh_aabb.size.z / 2
					
					selected_layout = FlatLayout.new(Vector2(new_mesh_z, new_mesh_z), Vector2.ZERO)
					var hex = Hex.new(q, r)
					
					hex_tile.set_hex(hex)
					map[hex_tile] = null
				'pointy':
					print("Pointy")
					
					var hex_tile = HEX_TILE.instantiate()
					var mesh = hex_tile.get_mesh()
					var collider = hex_tile.get_collider()
					
					mesh.rotate_y(deg_to_rad(30))
					collider.rotate_y(deg_to_rad(30))
					
					var mesh_aabb = mesh.global_transform * hex_tile.get_mesh().get_aabb()
					
					var new_mesh_z: float = mesh_aabb.size.z / 2
					
					selected_layout = PointyLayout.new(Vector2(new_mesh_z, new_mesh_z), Vector2.ZERO)
					var hex = Hex.new(q, r)
					hex_tile.set_hex(hex)
					map[hex_tile] = null
