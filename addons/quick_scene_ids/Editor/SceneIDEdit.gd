tool
extends HBoxContainer

export var menu_rect:Rect2

onready var editor := EditorPlugin.new().get_editor_interface()
onready var tscn_dialog : FileDialog = $FreePos/TscnDialog
onready var scenes_menu_button : Button = $ScenesMenuButton 
onready var scenes_menu : PopupMenu = $ScenesMenuButton/ScenesMenu
onready var scene_edit : LineEdit = $SceneEdit
onready var id_edit : LineEdit = $IdEdit


var scene : String setget _set_scene, _get_scene
var id : String setget _set_id, _get_id

var menu_rect_offset : Rect2

signal changed
signal removed(id)

func _ready() -> void:
	menu_rect_offset = menu_rect

func _on_scenes_menu_button() -> void:
	scenes_menu.clear()
	
	for s in editor.get_open_scenes():
		scenes_menu.add_item(s)
	
	menu_rect = menu_rect_offset
	menu_rect.position.y += scenes_menu_button.rect_size.y
	menu_rect.position += scenes_menu_button.rect_global_position
	menu_rect.position.x -= menu_rect.size.x
	scenes_menu.popup(menu_rect)

func _set_scene(value:String) -> void:
	scene_edit.text = value
	emit_signal("changed")

func _get_scene() -> String:
	return scene_edit.text

func _set_id(value:String) -> void:
	$IdEdit.text = value

func _get_id() -> String:
	return $IdEdit.text

func _on_item(index:int) -> void:
	_set_scene(scenes_menu.get_item_text(index))

func _on_browse() -> void:
	tscn_dialog.popup()

func _on_tscn_dialog() -> void:
	_set_scene(tscn_dialog.current_path)

func _on_remove() -> void:
	emit_signal("removed", self)

func _on_changed(new_text):
	emit_signal("changed")
