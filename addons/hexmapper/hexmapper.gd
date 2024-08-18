@tool
extends EditorPlugin

var panel
const TOOL_PANEL = preload("res://addons/hexmapper/HexMapperPanel.tscn")
var _file_dialog
var selected_mesh: MeshInstance3D
var _option_button: OptionButton

func _enter_tree() -> void:
	panel = TOOL_PANEL.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, panel)
	_option_button = panel.get_node("HBoxContainer/MeshOptionButton")
	_option_button.connect("item_selected", Callable(self, "_on_mesh_option_selected"))

func _exit_tree() -> void:
	remove_control_from_docks(panel)
	panel.queue_free()

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
	set_option_mesh_icon()
	
func set_option_mesh_icon():
	#_option_button.add_icon_item(selected_mesh.material_override, "Mesh")
	pass
