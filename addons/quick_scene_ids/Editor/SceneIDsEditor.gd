tool
extends VBoxContainer

export var scene_id_edit:PackedScene

var editor:EditorInterface
var file_path:String
var scene_ids: SceneIDs

onready var box : BoxContainer = $ScrollContainer/VBoxContainer

func _ready() -> void:
	$Add.icon = get_icon("CreateNewSceneFrom", "EditorIcons")
	
	file_path = ProjectSettings.get("addons/scene_id/file_path")
	init()


func init() -> void:
	for ch in box.get_children():
		box.remove_child(ch)
		ch.queue_free()

	scene_ids = load(file_path)
	if not scene_ids:
		scene_ids = SceneIDs.new()
		Directory.new().make_dir_recursive(file_path.get_base_dir())
		
	var sl_dict = scene_ids.get_as_dict()
	for k in sl_dict.keys():
		var scene_path = sl_dict[k]
		if scene_path is PackedScene:
			scene_path = scene_path.resource_path
		add_sle(k, scene_path)


func plugin_ready(_editor:EditorInterface) -> void:
	editor = _editor


func on_add() -> void:
	add_sle("", "")


func add_sle(scene_id:String, scene_path:String):
	var nsle = scene_id_edit.instance()
	nsle.editor = editor
	nsle.scene = scene_path
	nsle.id = scene_id
	nsle.connect("removed", self, "_on_removed_id")
	nsle.connect("changed", self, "_on_apply")
	box.add_child(nsle)
	prints("adds", scene_id, scene_path)


func _on_apply() -> void:
	var exits := scene_ids != null

	var dict := {}
	for ch in box.get_children():
		dict[ch.id] = ch.scene

	if not exits:
		scene_ids = SceneIDs.new()

	scene_ids.set_using_dict(dict)

	save_sl(file_path, scene_ids)


func save_sl(_file_path:String, _scene_ids:SceneIDs):
	var error := ResourceSaver.save(_file_path, _scene_ids)
	if error != OK:
		push_error("There was issue writing Sceneids to %s error_number: %s" % [file_path, error])


func _on_removed_id(id_node):
	box.remove_child(id_node)
	id_node.queue_free()
	_on_apply()
