class_name City extends Node

var city_name
var colour
var num_of_connections
var connections
var black_cubes
var blue_cubes
var red_cubes
var yellow_cubes
var station

func _init(city_info) -> void:
	city_name = city_info["name"]
	colour = city_info["colour"]
	num_of_connections = city_info["num_of_connections"]
	connections = city_info["connections"]
	black_cubes = city_info["black"]
	blue_cubes = city_info["blue"]
	red_cubes = city_info["red"]
	yellow_cubes = city_info["yellow"]
