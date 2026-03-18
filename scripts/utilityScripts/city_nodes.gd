extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in Map.num_of_cities:
		Map.cities[i].set_city_node(get_node(Map.cities[i].get_city_name()))
