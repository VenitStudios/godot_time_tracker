@tool
extends EditorPlugin
const SAVE_FILE: String = "res://addons/timetracker/track_info.json"

var open_time: float

var label: Label

func _enable_plugin() -> void:
	# Add autoloads here.
	init_time()


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	label = Label.new()
	
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, label)
	label.get_parent().move_child(label, -3)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if is_instance_valid(label):
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, label)


func init_time() -> void:
	if FileAccess.file_exists(SAVE_FILE):
		open_time = JSON.parse_string(FileAccess.get_file_as_string(SAVE_FILE)).get("open_time", 0)


func _save_external_data() -> void:
	var fs := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	fs.store_string(JSON.stringify({"open_time": open_time}))
	fs.close()
	
	var efs := EditorInterface.get_resource_filesystem()
	efs.update_file(SAVE_FILE)
	efs.reimport_files([SAVE_FILE])

func _process(delta: float) -> void:
	if is_instance_valid(label):
		open_time += delta
		var hour: String = str(int(open_time / 3600.0)).pad_zeros(2)
		var minute: String = str(int((fmod(open_time, 3600)) / 60.0)).pad_zeros(2)
		var second: String = str(int(fmod(open_time, 60))).pad_zeros(2)
		
		label.text = str(hour, ":", minute, ":", second)
