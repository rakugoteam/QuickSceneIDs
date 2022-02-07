tool
extends EditorPlugin

var setting_path := "addons/quick_scene_ids/file_path"
var default_properties := {
	setting_path : [
		"res://quick_scene_ids.json", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_FILE, "",
			PROPERTY_USAGE_CATEGORY)
	]
}

var tool_menu_entry := "Scene IDs Editor"
var editor_size := Vector2(600, 400)
var editor = preload("Editor/SceneIDEditor.tscn")

func _enter_tree():
	ProjectTools.set_settings_dict(default_properties)
	ProjectSettings.set_order(setting_path, 1)
	editor = editor.instance()
	add_control_to_container(CONTAINER_TOOLBAR, editor)
	add_tool_menu_item(tool_menu_entry, editor, "popup_centered", editor_size)

func _exit_tree():
	remove_tool_menu_item(tool_menu_entry)
	editor.queue_free()
