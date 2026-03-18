class_name City extends Node

var cube_scene = preload("res://scenes/cube.tscn")

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
var city_node
var cubes = []

func _init(city_info) -> void:
	city_name = city_info["name"]
	colour = city_info["colour"]
	num_of_connections = city_info["num_of_connections"]
	connections = city_info["connections"]
	black_cubes = city_info["black"]
	blue_cubes = city_info["blue"]
	red_cubes = city_info["red"]
	yellow_cubes = city_info["yellow"]
	station = city_info["station"]

func get_city_name() -> String:
	return city_name

func get_colour() -> String:
	return colour

func get_num_of_connections() -> float:
	return num_of_connections

func get_connection_name(index) -> String:
	return connections[index]

func get_cubes_string(c) -> String:
	match c:
		"black":
			return str(int(black_cubes))
		"blue":
			return str(int(blue_cubes))
		"red":
			return str(int(red_cubes))
		"yellow":
			return str(int(yellow_cubes))
	return "error"

func get_station() -> bool:
	return station

func get_city_node() -> Node:
	return city_node

func add_station() -> void:
	station = true

func set_protection(p) -> void:
	protected = p
	
func set_outbreak(o) -> void:
	outbreak = o

func set_city_node(node) -> void:
	city_node = node
	
func should_outbreak() -> bool:
	return !outbreak

func infect(c) -> bool:
	if protected:
		print("protected")
		return false
	print("Infecting " + city_name + " with " + c)
	var ob
	match c:
		"black":
			if black_cubes == 3:
				print(city_name + " is at " + str(black_cubes) + " black")
				ob = true
			else: 
				black_cubes += 1
				add_cube(c)
				print(city_name + " is at " + str(black_cubes) + " black")
				ob = false
		"blue":
			if blue_cubes == 3:
				print(city_name + " is at " + str(blue_cubes) + " blue")
				ob = true
			else: 
				blue_cubes += 1
				add_cube(c)
				print(city_name + " is at " + str(blue_cubes) + " blue")
				ob = false
		"red":
			if red_cubes == 3:
				print(city_name + " is at " + str(red_cubes) + " red")
				ob = true
			else: 
				red_cubes += 1
				add_cube(c)
				print(city_name + " is at " + str(red_cubes) + " red")
				ob = false
		"yellow":
			if yellow_cubes == 3:
				print(city_name + " is at " + str(yellow_cubes) + " yellow")
				ob = true
			else: 
				yellow_cubes += 1
				add_cube(c)
				print(city_name + " is at " + str(yellow_cubes) + " yellow")
				ob = false
	if InfoPanel.current_city and InfoPanel.current_city.get_city_name() == get_city_name():
		InfoPanel.update_text(null)
		print("Updating label")
	return ob

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
			for i in 3 - black_cubes:
				add_cube(colour)
			black_cubes = 3
		"blue":
			print(blue_cubes)
			if blue_cubes == 0:
				ob = false
			for i in 3 - blue_cubes:
				add_cube(colour)
			blue_cubes = 3
		"red":
			print(red_cubes)
			if red_cubes == 0:
				ob = false
			for i in 3 - red_cubes:
				add_cube(colour)
			red_cubes = 3
		"yellow":
			print(yellow_cubes)
			if yellow_cubes == 0:
				ob = false
			for i in 3 - yellow_cubes:
				add_cube(colour)
			yellow_cubes = 3
	if InfoPanel.current_city and InfoPanel.current_city.get_city_name() == get_city_name():
		InfoPanel.update_text(null)
		print("Updating label")
	return ob

func treat_disease(c, cured) -> bool:
	print("Treating " + c)
	var treated = true
	match c:
		"black":
			if black_cubes == 0:
				treated = false
			elif cured:
				for i in black_cubes:
					remove_cube(c)
				black_cubes = 0
			else:
				black_cubes -= 1
				remove_cube(c)
		"blue":
			if blue_cubes == 0:
				treated = false
			elif cured:
				for i in blue_cubes:
					remove_cube(c)
				blue_cubes = 0
			else:
				blue_cubes -= 1
				remove_cube(c)
		"red":
			if red_cubes == 0:
				treated = false
			elif cured:
				for i in red_cubes:
					remove_cube(c)
				red_cubes = 0
			else:
				red_cubes -= 1
				remove_cube(c)
		"yellow":
			if yellow_cubes == 0:
				treated = false
			elif cured:
				for i in yellow_cubes:
					remove_cube(c)
				yellow_cubes = 0
			else:
				yellow_cubes -= 1
				remove_cube(c)
	if treated and InfoPanel.current_city and InfoPanel.current_city.get_city_name() == get_city_name():
		InfoPanel.update_text(null)
		print("Updating label")
	return treated

func add_cube(c:String) -> void:
	var cube = cube_scene.instantiate()
	city_node.add_child(cube)
	cube.colour = c
	cube.global_position = city_node.global_position + Vector2(randf_range(-10,10),randf_range(-10,10))
	match c:
		"blue":cube.modulate = Color(0.2,0.4,1)
		"red":cube.modulate = Color(1, 0.2, 0.2)
		"yellow":cube.modulate = Color(1,1,0.2)
		"black":cube.modulate = Color(0.1,0.1,0.1)
	cubes.append(cube)

func remove_cube(c:String) -> void:
	for i in cubes.size():
		if cubes[i].colour == c:
			cubes[i].queue_free()
			cubes.erase(cubes[i])
			return
