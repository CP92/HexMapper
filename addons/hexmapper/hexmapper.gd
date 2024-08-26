@tool
extends EditorPlugin
class_name hex_mapper

var panel
const TOOL_PANEL = preload("res://addons/hexmapper/HexMapperPanel.tscn")
var map
var _file_dialog
var _mesh_option_button: OptionButton
var _mesh_flat_button: CheckButton
var _mesh_pointy_button: CheckButton
var _map_shape_option: OptionButton
var _map_depth_slider: HSlider
var _map_depth_visual: LineEdit
var _map_width_slider: HSlider
var _map_width_visual: LineEdit
var _flat_button: CheckButton
var _pointy_button: CheckButton

func _enter_tree() -> void:
	add_custom_type("HexMapper", "Node3D", preload("res://addons/hexmapper/WorldHexGrid.gd"), preload("res://icon.svg"))
		
	panel = TOOL_PANEL.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, panel)
	
	_mesh_option_button = panel.get_node("MeshOptionContainer/MeshOptionButton")
	_mesh_option_button.connect("item_selected", Callable(self, "_on_mesh_option_selected"))
	
	_mesh_flat_button = panel.get_node("MeshOrientationContainer/MeshFlatButton")
	_mesh_pointy_button = panel.get_node("MeshOrientationContainer/MeshPointyButton")
	
	_mesh_flat_button.connect("pressed", Callable(self, "_on_mesh_flat_toggled"))
	_mesh_pointy_button.connect("pressed", Callable(self, "_on_mesh_pointy_toggled"))
	
	_map_shape_option = panel.get_node("MapShapeContainer/OptionButton")
	_map_shape_option.connect("item_selected", Callable(self, "_on_map_shape_selected"))
	
	
	_map_depth_slider = panel.get_node("MapDepthContainer/HSlider")
	_map_depth_visual = panel.get_node("MapDepthContainer/LineEdit")
	

	_map_depth_slider.connect("value_changed", Callable(self, "_on_depth_slider_updated"))
	_map_depth_visual.connect("text_submitted", Callable(self, "_on_map_depth_visual_changed"))
	
	
	_map_width_slider = panel.get_node("MapWidthContainer/HSlider")
	_map_width_visual = panel.get_node("MapWidthContainer/LineEdit")
	

	_map_width_slider.connect("value_changed", Callable(self, "_on_width_slider_updated"))
	_map_width_visual.connect("text_submitted", Callable(self, "_on_map_width_visual_changed"))
	
	_flat_button = panel.get_node("HBoxContainer/FlatButton")
	_pointy_button = panel.get_node("HBoxContainer/PointyButton")
	
	
	_flat_button.connect("pressed", Callable(self, "_on_flat_toggled"))
	_pointy_button.connect("pressed", Callable(self, "_on_pointy_toggled"))
	
	if get_hex_map():
		set_map_values()
	
func _exit_tree() -> void:
	remove_control_from_docks(panel)
	panel.queue_free()

func _on_mesh_pointy_toggled():
	_mesh_flat_button.set_pressed_no_signal(not _mesh_flat_button.button_pressed)
	get_hex_map().mesh_orientation = "flat" if _mesh_flat_button.button_pressed else "pointy"

func _on_mesh_flat_toggled():
	_mesh_pointy_button.set_pressed_no_signal(not _mesh_pointy_button.button_pressed)
	get_hex_map().mesh_orientation = "flat" if _mesh_flat_button.button_pressed else "pointy"

func _on_flat_toggled():
	_pointy_button.set_pressed_no_signal(not _pointy_button.button_pressed)
	get_hex_map().orientation = "flat" if _flat_button.button_pressed else "pointy"

func _on_pointy_toggled():
	_flat_button.set_pressed_no_signal(not _flat_button.button_pressed)
	get_hex_map().orientation = "flat" if _flat_button.button_pressed else "pointy"
	
func _on_depth_slider_updated(value: float):
	get_hex_map().map_depth = value
	_map_depth_visual.text = str(value)
	
func _on_width_slider_updated(value: float):
	get_hex_map().map_width = value
	_map_width_visual.text = str(value)
	
func _on_map_depth_visual_changed(text: String):
	get_hex_map().map_depth = int(text)
	_map_depth_slider.value = int(text)
	
func _on_map_width_visual_changed(text: String):
	get_hex_map().map_width = int(text)
	_map_width_slider.value = int(text)
	
func _on_map_shape_selected(index: int):
	var text = _map_shape_option.get_item_text(index)
	get_hex_map().map_shape = text
	
func _on_mesh_option_selected(ind: int):
	match ind:
		0:
			_file_dialog = FileDialog.new()
			add_child(_file_dialog)
			_file_dialog.mode = FileDialog.FILE_MODE_OPEN_FILE
			_file_dialog.access = FileDialog.ACCESS_RESOURCES
			_file_dialog.size = Vector2(750, 750)
			_file_dialog.connect("file_selected", Callable(self, "_on_FileDialog_file_selected"))
			_file_dialog.show()
		_:
			get_hex_map().hex_mesh = _mesh_option_button.get_item_metadata(ind)

func _on_FileDialog_file_selected(path):
	var file = load(path)
	get_hex_map().hex_mesh = file
	var mesh_index := set_option_mesh_icon(file)
	_mesh_option_button.select(mesh_index)
	_mesh_option_button.set_item_metadata(mesh_index, file)
	
func set_option_mesh_icon(file) -> int:
	var _mesh_arr : Array[Mesh]
	_mesh_arr.append(file)
	
	var _2d_arr : Array[Texture2D] = get_editor_interface().make_mesh_previews(_mesh_arr, 128)
	
	var option_index := _mesh_option_button.item_count
	_mesh_option_button.add_icon_item(_2d_arr[0], "", option_index)
	return option_index

func get_hex_map() -> WorldHexGrid:
	var scene_root = EditorInterface.get_edited_scene_root()
	if scene_root.is_class("Node3D"):
		if scene_root is WorldHexGrid:
			return scene_root
		else:
			var mapper = scene_root.get_node("HexMapper")
			return mapper
	return null

func set_map_values():
	get_hex_map().map_shape = _map_shape_option.get_item_text(0)
	get_hex_map().map_depth = _map_depth_slider.value
	get_hex_map().map_width = _map_width_slider.value
	get_hex_map().orientation = "flat"
