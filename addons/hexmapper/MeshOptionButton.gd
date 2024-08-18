extends OptionButton

var _file_dialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_selected(index: int) -> void:
	match index :
		0:
			_file_dialog = FileDialog.new()
			_file_dialog.mode = FileDialog.FILE_MODE_OPEN_FILE
			_file_dialog.access = FileDialog.ACCESS_RESOURCES
			_file_dialog.connect("file_selected", self, "_on_FileDialog_file_selected")
			
func _on_FileDialog_file_selected(path):
	var texture = load(path)
