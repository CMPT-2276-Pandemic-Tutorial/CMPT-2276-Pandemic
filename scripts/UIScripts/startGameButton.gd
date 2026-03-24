extends Button
var menu = "res://scenes/boardMain.tscn"
var tutorial = "res://scenes/UIScenes/tutorialScenes/tutorial_menu.tscn"

func _on_pressed() -> void:
	get_tree().change_scene_to_file(menu)


func _on_tutorial_select_pressed() -> void:
	get_tree().change_scene_to_file(tutorial)
