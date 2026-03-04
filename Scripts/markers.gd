extends Node

var Outbreakoffsets: Array[Vector2] = [
	Vector2(42,38), # second outbreak
	Vector2(0,71), 
	Vector2(42,107), 
	Vector2(0,142),
	Vector2(42,175),
	Vector2(0,207),
	Vector2(42,240),
	Vector2(0,274)
	]

var InfectionRateOffsets: Array[Vector2] = [
	Vector2(42,0),
	Vector2(83,0),
	Vector2(124,0),
	Vector2(165,0),
	Vector2(205,0),
	Vector2(245,0)
]

func _process(delta: float) -> void: # this is for testing
	for mark in Outbreakoffsets:
		var new_light = $OutbreakMarker.duplicate()
		new_light.position += mark
		add_child(new_light)
	for mark in InfectionRateOffsets:
		var new_marker = $InfectionMarker.duplicate()
		new_marker.position += mark
		add_child(new_marker)
