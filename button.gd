extends Button
var menu = "res://ui_prototype.tscn"

func _on_pressed() -> void:
	get_tree().change_scene_to_file(menu)
