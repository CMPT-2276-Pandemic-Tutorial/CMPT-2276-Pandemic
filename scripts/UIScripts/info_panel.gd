extends Node

var current_city = null
var label

func update_text(new_city) -> void:
	if new_city:
		current_city = new_city
	var text = ("Name: " + current_city.get_city_name() \
	+ "\nBlack Cubes: " + current_city.get_cubes_string("black") \
	+ "\nBlue Cubes: " + current_city.get_cubes_string("blue") \
	+ "\nRed Cubes: " + current_city.get_cubes_string("red") \
	+ "\nYellow Cubes: " + current_city.get_cubes_string("yellow") \
	+ "\nStation: " + str(current_city.get_station()))
	label.set_text(text)
