@tool
extends EditorPlugin

var panel
const TOOL_PANEL = preload("res://addons/hexmapper/HexMapperPanel.tscn")
var _file_dialog
var selected_mesh: MeshInstance3D
var _option_button: OptionButton
var _map_depth_slider: HSlider
var _map_depth_visual: LineEdit
var _map_depth
var _map_width_slider: HSlider
var _map_width_visual: LineEdit
var _map_width


func _enter_tree() -> void:
	panel = TOOL_PANEL.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, panel)
	_option_button = panel.get_node("MeshOptionContainer/MeshOptionButton")
	_option_button.connect("item_selected", Callable(self, "_on_mesh_option_selected"))
	
	_map_depth_slider = panel.get_node("MapDepthContainer/HSlider")
	_map_depth_visual = panel.get_node("MapDepthContainer/LineEdit")

	_map_depth_slider.connect("value_changed", Callable(self, "_on_depth_slider_updated"))
	_map_depth_visual.connect("text_submitted", Callable(self, "_on_map_depth_visual_changed"))
	
	_map_width_slider = panel.get_node("MapWidthContainer/HSlider")
	_map_width_visual = panel.get_node("MapWidthContainer/LineEdit")

	
	_map_width_slider.connect("value_changed", Callable(self, "_on_width_slider_updated"))
	_map_width_visual.connect("text_submitted", Callable(self, "_on_map_width_visual_changed"))
	
func _exit_tree() -> void:
	remove_control_from_docks(panel)
	panel.queue_free()

func _on_depth_slider_updated(value: float):
	_map_depth = value
	_map_depth_visual.text = str(value)

func _on_width_slider_updated(value: float):
	_map_width = value
	_map_width_visual.text = str(value)

func _on_map_depth_visual_changed(text: String):
	_map_depth = int(text)
	_map_depth_slider.value = int(text)
	
func _on_map_width_visual_changed(text: String):
	_map_width = int(text)
	_map_width_slider.value = int(text)

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
	selected_mesh = MeshInstance3D.new()
	selected_mesh.set_mesh(file)
	var mesh_index := set_option_mesh_icon(file)
	_option_button.select(mesh_index)
	
func set_option_mesh_icon(file) -> int:
	var _mesh_arr : Array[Mesh]
	_mesh_arr.append(file)
	
	var _2d_arr : Array[Texture2D] = get_editor_interface().make_mesh_previews(_mesh_arr, 128)
	
	var option_index := _option_button.item_count
	_option_button.add_icon_item(_2d_arr[0], "", option_index)
	return option_index
