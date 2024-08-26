class_name WorldHexGrid
extends Node3D

const HEX_TILE = preload("res://addons/hexmapper/hex_tile_static.tscn")

@export_group("HexMapProperties")
@export var hex_mesh: Mesh
@export var mesh_orientation = "flat"
@export var map_shape = "Hexagon"
@export var map_width = 20
@export var map_depth = 20
@export var orientation = "flat"

var map = {}
var selected_layout

func _ready():
	match map_shape:
		"Hexagon":
			genHexMap()
		"Rectangle":
			genRectangleMap()
		"Triangle":
			genTriangleMap()
		"Parallelogram":
			genParallelogramMap()

func genRectangleMap():
	var map_size = max(map_width, map_depth)
	
	match orientation:
		'flat':
			for q in range(map_width):
				var qoff = floor(q/2.0)
				for r in range(-qoff, map_depth - qoff):
					var hex_tile = HEX_TILE.instantiate()
					hex_tile.set_properties(Hex.new(q,r), hex_mesh)
					
					var mesh_aabb = hex_tile.get_mesh().transform * hex_tile.get_mesh().get_aabb()
					
					var new_mesh_z: float = mesh_aabb.size.z / 2
					if mesh_orientation != orientation:
						
						var collider = hex_tile.get_collider()
						hex_tile.get_mesh().rotate_y(deg_to_rad(30))
						collider.rotate_y(deg_to_rad(30))
					selected_layout = FlatLayout.new(Vector2(new_mesh_z, new_mesh_z), Vector2.ZERO)

					map[hex_tile] = null
		'pointy':
			for r in range(map_depth):
				var roff = floor(r/2.0)
				for q in range(-roff, map_width - roff):
					var hex_tile = HEX_TILE.instantiate()
					hex_tile.set_properties(Hex.new(q, r), hex_mesh)
					var mesh_aabb = hex_tile.get_mesh().transform * hex_tile.get_mesh().get_aabb()
					
					var new_mesh_z: float = mesh_aabb.size.z / 2
					if mesh_orientation != orientation:
						
						var collider = hex_tile.get_collider()
						hex_tile.get_mesh().rotate_y(deg_to_rad(30))
						collider.rotate_y(deg_to_rad(30))
					selected_layout = PointyLayout.new(Vector2(new_mesh_z, new_mesh_z), Vector2.ZERO)
					map[hex_tile] = null
	
	for i in map.keys():
		add_child(i)
		var pixel = selected_layout.hex_to_pixel(i.hex)					
		i.translate(Vector3(pixel.x, 0, pixel.y))	

func genTriangleMap():
	var map_size = max(map_width, map_depth)
	
	for q in range(map_size + 1):
		for r in range((map_size - q) + 1):
			buildMapCords(q, r)

	for i in map.keys():
		add_child(i)
		var pixel = selected_layout.hex_to_pixel(i.hex)					
		i.translate(Vector3(pixel.x, 0, pixel.y))

func genParallelogramMap():
	var map_size = max(map_width, map_depth)
	
	for q in range(map_size + 1):
		for r in range(map_size + 1):
			buildMapCords(q, r)

	for i in map.keys():
		add_child(i)
		var pixel = selected_layout.hex_to_pixel(i.hex)					
		i.translate(Vector3(pixel.x, 0, pixel.y))
		
func genHexMap():
	var map_size = max(map_width, map_depth)
	
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
	match orientation:
				'flat':
					var hex_tile = HEX_TILE.instantiate()
					hex_tile.set_properties(Hex.new(q, r), hex_mesh)
					
					var mesh_aabb = hex_tile.get_mesh().transform * hex_tile.get_mesh().get_aabb()
					
					var new_mesh_z: float = mesh_aabb.size.z / 2
					if mesh_orientation != orientation:
						
						var collider = hex_tile.get_collider()
						hex_tile.get_mesh().rotate_y(deg_to_rad(30))
						collider.rotate_y(deg_to_rad(30))
					selected_layout = FlatLayout.new(Vector2(new_mesh_z, new_mesh_z), Vector2.ZERO)
					
					map[hex_tile] = null
				'pointy':
					var hex_tile = HEX_TILE.instantiate()
					hex_tile.set_properties(Hex.new(q, r), hex_mesh)
					
					var mesh_aabb = hex_tile.get_mesh().transform * hex_tile.get_mesh().get_aabb()
					
					var new_mesh_z: float = mesh_aabb.size.z / 2
					if mesh_orientation != orientation:
						
						var collider = hex_tile.get_collider()
						hex_tile.get_mesh().rotate_y(deg_to_rad(30))
						collider.rotate_y(deg_to_rad(30))
					selected_layout = PointyLayout.new(Vector2(new_mesh_z, new_mesh_z), Vector2.ZERO)

					map[hex_tile] = null
