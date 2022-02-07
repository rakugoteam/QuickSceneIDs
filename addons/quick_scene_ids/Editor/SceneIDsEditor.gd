tool
extends VBoxContainer

export var scene_id_edit:PackedScene

var editor:EditorInterface
var file_path:String
var scene_ids: Dictionary
var f := File.new()

onready var box : BoxContainer = $ScrollContainer/VBoxContainer

func _ready() -> void:
	var setting = ProjectSettings.get("addons/quick_scene_ids/file_path")
	if setting == null:
		return

	$Add.icon = get_icon("CreateNewSceneFrom", "EditorIcons")
	file_path = setting
	connect("visibility_changed", self, "_on_visibility_changed")


func _on_visibility_changed() -> void:
	for ch in box.get_children():
		box.remove_child(ch)
		ch.queue_free()

	if f.file_exists(file_path):
		# load json
		f.open(file_path, f.READ)
		var json = f.get_as_text()
		scene_ids = parse_json(json)
		f.close()
	
		for k in scene_ids.keys():
			var scene_path = scene_ids[k]
			if scene_path is PackedScene:
				scene_path = scene_path.resource_path
			add_sle(k, scene_path)

	else:
		scene_ids = {}


func plugin_ready(_editor:EditorInterface) -> void:
	editor = _editor


func on_add() -> void:
	add_sle("", "")


func add_sle(scene_id:String, scene_path:String):
	var nsle = scene_id_edit.instance()
	box.add_child(nsle)
	nsle.hide()
	nsle.editor = editor
	nsle.scene = scene_path
	nsle.id = scene_id
	nsle.connect("removed", self, "_on_removed_id")
	nsle.connect("changed", self, "_on_apply")
	nsle.show()
	prints("adds", scene_id, scene_path)


func _on_apply() -> void:
	var dict := {}
	for ch in box.get_children():
		dict[ch.id] = ch.scene

	save_sl(file_path, dict)


func save_sl(_file_path:String, _scene_ids:Dictionary):
	# save json
	var json := to_json(_scene_ids)
	f.open(_file_path, f.WRITE)
	f.store_string(json)
	f.close()


func _on_removed_id(id_node):
	box.remove_child(id_node)
	id_node.queue_free()
	_on_apply()
