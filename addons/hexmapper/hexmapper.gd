@tool
extends EditorPlugin
class_name hex_mapper

var AUTOLOAD_NAME = "HexGlobals"
var hex_globals
var panel
const TOOL_PANEL = preload("res://addons/hexmapper/HexMapperPanel.tscn")
var _file_dialog
var _option_button: OptionButton
var _map_shape_option: OptionButton
var _map_depth_slider: HSlider
var _map_depth_visual: LineEdit
var _map_width_slider: HSlider
var _map_width_visual: LineEdit
var _flat_button: CheckButton
var _pointy_button: CheckButton

func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/hexmapper/hex_globals.gd")
	hex_globals = get_node("/root/" + AUTOLOAD_NAME)
	panel = TOOL_PANEL.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, panel)
	
	_option_button = panel.get_node("MeshOptionContainer/MeshOptionButton")
	_option_button.connect("item_selected", Callable(self, "_on_mesh_option_selected"))
	
	_map_shape_option = panel.get_node("MapShapeContainer/OptionButton")
	_map_shape_option.connect("item_selected", Callable(self, "_on_map_shape_selected"))
	hex_globals.map_shape = _map_shape_option.get_item_text(0)
	
	
	_map_depth_slider = panel.get_node("MapDepthContainer/HSlider")
	_map_depth_visual = panel.get_node("MapDepthContainer/LineEdit")
	hex_globals.map_depth = _map_depth_slider.value

	_map_depth_slider.connect("value_changed", Callable(self, "_on_depth_slider_updated"))
	_map_depth_visual.connect("text_submitted", Callable(self, "_on_map_depth_visual_changed"))
	
	
	_map_width_slider = panel.get_node("MapWidthContainer/HSlider")
	_map_width_visual = panel.get_node("MapWidthContainer/LineEdit")
	hex_globals.map_width = _map_width_slider.value

	_map_width_slider.connect("value_changed", Callable(self, "_on_width_slider_updated"))
	_map_width_visual.connect("text_submitted", Callable(self, "_on_map_width_visual_changed"))
	
	_flat_button = panel.get_node("HBoxContainer/FlatButton")
	_pointy_button = panel.get_node("HBoxContainer/PointyButton")
	hex_globals.orientation = "flat"
	
	_flat_button.connect("pressed", Callable(self, "_on_flat_toggled"))
	_pointy_button.connect("pressed", Callable(self, "_on_pointy_toggled"))
	
func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
	remove_control_from_docks(panel)
	panel.queue_free()

func _on_flat_toggled():
	#_flat_button.set_pressed_no_signal(not _flat_button.button_pressed)
	_pointy_button.set_pressed_no_signal(not _pointy_button.button_pressed)
	hex_globals.orientation = "flat" if _flat_button.button_pressed else "pointy"

func _on_pointy_toggled():
	#_pointy_button.set_pressed_no_signal(not _pointy_button.button_pressed) 
	_flat_button.set_pressed_no_signal(not _flat_button.button_pressed)
	hex_globals.orientation = "flat" if _flat_button.button_pressed else "pointy"

func _on_depth_slider_updated(value: float):
	hex_globals.map_depth = value
	_map_depth_visual.text = str(value)

func _on_width_slider_updated(value: float):
	hex_globals.map_width = value
	_map_width_visual.text = str(value)

func _on_map_depth_visual_changed(text: String):
	hex_globals.map_depth = int(text)
	_map_depth_slider.value = int(text)
	
func _on_map_width_visual_changed(text: String):
	hex_globals.map_width = int(text)
	_map_width_slider.value = int(text)

func _on_map_shape_selected(text: String):
	hex_globals.map_shape = text

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

func _on_FileDialog_file_selected(path):
	var file = load(path)
	hex_globals.hex_mesh = file
	var mesh_index := set_option_mesh_icon(file)
	_option_button.select(mesh_index)
	
func set_option_mesh_icon(file) -> int:
	var _mesh_arr : Array[Mesh]
	_mesh_arr.append(file)
	
	var _2d_arr : Array[Texture2D] = get_editor_interface().make_mesh_previews(_mesh_arr, 128)
	
	var option_index := _option_button.item_count
	_option_button.add_icon_item(_2d_arr[0], "", option_index)
	return option_index
