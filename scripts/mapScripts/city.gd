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
var outbreak = false
var protected = false

func _init(city_info) -> void:
	city_name = city_info["name"]
	colour = city_info["colour"]
	num_of_connections = city_info["num_of_connections"]
	connections = city_info["connections"]
	black_cubes = city_info["black"]
	blue_cubes = city_info["blue"]
	red_cubes = city_info["red"]
	yellow_cubes = city_info["yellow"]

func get_city_name() -> String:
	return city_name

func get_colour() -> String:
	return colour

func get_num_of_connections() -> float:
	return num_of_connections

func get_connection_name(index) -> String:
	return connections[index]

func set_protection(p) -> void:
	protected = p
	
func set_outbreak(o) -> void:
	outbreak = o

func should_outbreak() -> bool:
	return !outbreak

func infect(c) -> bool:
	if protected:
		print("protected")
		return false
	print("Infecting " + city_name + " with " + c)
	match c:
		"black":
			if black_cubes == 3:
				print(city_name + " is at " + str(black_cubes) + " black")
				return true
			else: 
				black_cubes += 1
				print(city_name + " is at " + str(black_cubes) + " black")
				return false
		"blue":
			if blue_cubes == 3:
				print(city_name + " is at " + str(blue_cubes) + " blue")
				return true
			else: 
				blue_cubes += 1
				print(city_name + " is at " + str(blue_cubes) + " blue")
				return false
		"red":
			if red_cubes == 3:
				print(city_name + " is at " + str(red_cubes) + " red")
				return true
			else: 
				red_cubes += 1
				print(city_name + " is at " + str(red_cubes) + " red")
				return false
		"yellow":
			if yellow_cubes == 3:
				print(city_name + " is at " + str(yellow_cubes) + " yellow")
				return true
			else: 
				yellow_cubes += 1
				print(city_name + " is at " + str(yellow_cubes) + " yellow")
				return false
	return false

func infect_epidemic() -> bool:
	if protected:
		print("protected")
		return false
	var ob = true
	match colour:
		"black":
			print(black_cubes)
			if black_cubes == 0:
				ob = false
			black_cubes = 3
		"blue":
			print(blue_cubes)
			if blue_cubes == 0:
				ob = false
			blue_cubes = 3
		"red":
			print(red_cubes)
			if red_cubes == 0:
				ob = false
			red_cubes = 3
		"yellow":
			print(yellow_cubes)
			if yellow_cubes == 0:
				ob = false
			yellow_cubes = 3
	return ob

func treat_disease(c, cured) -> void:
	match c:
		"black":
			if cured:
				black_cubes = 0
			else:
				black_cubes -= 1
		"blue":
			if cured:
				blue_cubes = 0
			else:
				blue_cubes -= 1
		"red":
			if cured:
				red_cubes = 0
			else:
				red_cubes -= 1
		"yellow":
			if cured:
				yellow_cubes = 0
			else:
				yellow_cubes -= 1
