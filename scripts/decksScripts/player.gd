extends Node2D

signal current_city_changed(value)

@export var x_offset:float
@export var y_offset:float

var current_city: String:
	set(value):
		if value == current_city:
			return
		current_city = value
		current_city_changed.emit(current_city)


func _ready() -> void:
	current_city = "Atlanta"
	global_position = $"../../cityNodes/Atlanta".global_position + Vector2(x_offset,y_offset)
