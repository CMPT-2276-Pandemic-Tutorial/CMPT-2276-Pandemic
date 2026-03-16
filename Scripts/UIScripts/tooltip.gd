extends CanvasLayer

@onready var label = $Panel/MarginContainer/Label
@onready var panel = $Panel

func display(text: String, mouse_pos: Vector2):
	visible = true
	label.text = text
	# Offset a bit from the cursor
	panel.position = mouse_pos + Vector2(15,15)

func hide_tooltip() -> void:
	visible = false
