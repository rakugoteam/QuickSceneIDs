tool
extends EditorPlugin

var default_properties := {
	"addons/quick_scene_ids/file_path" : [
		"res://quick_scene_ids.json", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_FILE, "",
			PROPERTY_USAGE_CATEGORY)
	],
}

var editor = preload("Editor/SceneIDEditor.tscn") 

func _enter_tree():
	ProjectTools.set_settings_dict(default_properties)
	editor = editor.instance()
	add_control_to_container(CONTAINER_TOOLBAR, editor)
	add_tool_menu_item("Scene IDs Editor", editor, "popup_centered", Vector2(450, 400))

func _exit_tree():
	remove_tool_menu_item(editor)
	editor.queue_free()
