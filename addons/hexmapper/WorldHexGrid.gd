class_name WorldHexGrid
extends Node3D

const HEX_TILE = preload("res://addons/hexmapper/hex_tile_static.tscn")

var map_height = 10
var map_width = 10
var map_orientation = 'flat'
var map = {}
var selected_layout
# Called when the node enters the scene tree for the first time.
func _ready():
	genHexMap() # Replace with function body.
	#genParallelogramMap()
	#genTriangleMap()
	#genRectangleMap()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func genRectangleMap():
	var map_size = max(map_width, map_height)
	
	match map_orientation:
		'flat':
			print("Flat")
			
			for q in range(map_width):
				var qoff = floor(q/2.0)
				for r in range(-qoff, map_height - qoff):
					var hex_tile = HEX_TILE.instantiate()
					var mesh_aabb = hex_tile.get_mesh().global_transform * hex_tile.get_mesh().get_aabb()
					
					var new_mesh_z: float = mesh_aabb.size.z / 2
					
					selected_layout = FlatLayout.new(Vector2(new_mesh_z, new_mesh_z), Vector2.ZERO)
					var hex = Hex.new(q, r)
					
					hex_tile.set_hex(hex)
					map[hex_tile] = null
		'pointy':
			print("Pointy")
			for r in range(map_height):
				var roff = floor(r/2.0)
				for q in range(-roff, map_width - roff):
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
	
	var map_size = max(map_width, map_height)
	
	for q in range(map_size + 1):
		for r in range((map_size - q) + 1):
			buildMapCords(q, r)

	for i in map.keys():
		add_child(i)
		var pixel = selected_layout.hex_to_pixel(i.hex)					
		i.translate(Vector3(pixel.x, 0, pixel.y))

func genParallelogramMap():
	var map_size = max(map_width, map_height)
	
	for q in range(map_size + 1):
		for r in range(map_size + 1):
			buildMapCords(q, r)

	for i in map.keys():
		add_child(i)
		var pixel = selected_layout.hex_to_pixel(i.hex)					
		i.translate(Vector3(pixel.x, 0, pixel.y))
		
func genHexMap():
	var map_size = max(map_width, map_height)
	
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
	match map_orientation:
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
