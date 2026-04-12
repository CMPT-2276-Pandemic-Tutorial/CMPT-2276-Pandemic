extends Node
const menu = "res://scenes/boardMain.tscn"
const tutorial = "res://scenes/UIScenes/tutorialScenes/tutorial_menu.tscn"
const testing = "res://scenes/AutomatedTestScreen.tscn"

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SLASH:
			get_tree().change_scene_to_file(testing)

func _on_start_select_pressed() -> void:
	get_tree().change_scene_to_file(menu)


func _on_tutorial_select_pressed() -> void:
	get_tree().change_scene_to_file(tutorial)
