extends Node2D

var current_city: String = "Atlanta"

func _ready() -> void:
	global_position = $"../../cityNodes/Atlanta".global_position
