extends Area2D

signal city_clicked(city_name)

func _ready():
	input_pickable = true # allows detection of the mouse

func _input_event(viewport, event, shape_idx): #sets up input event for mouse buttons using default godot designations
	if event is InputEventMouseButton and event.pressed:
		emit_signal("city_clicked", name)
