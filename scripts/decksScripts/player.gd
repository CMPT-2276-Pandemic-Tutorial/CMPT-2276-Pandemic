extends Node2D

@export var x_offset:float
@export var y_offset:float

var current_city: String = "Atlanta"


func _ready() -> void:
	global_position = $"../../cityNodes/Atlanta".global_position + Vector2(x_offset,y_offset)
