class_name City

const cube_scene = preload("res://scenes/iconScenes/cube.tscn")

var city_name : String
var colour : String
var num_of_connections : int
var connections : Array
var cubes : Dictionary[String, int] = {"black": 0, "blue": 0, "red": 0, "yellow": 0}
var station : bool
var protected : bool = false
var city_coords : Vector2

var outbreak : bool = false

var city_node : Node
var cube_nodes : Array[Node] = []

func get_city_name() -> String: return city_name
func get_colour() -> String: return colour
func get_num_of_connections() -> float: return num_of_connections
func get_connection_name(index) -> String: return connections[index]
func get_cubes(c) -> int: return cubes[c]
func get_cubes_string(c) -> String: return str(cubes[c])
func get_station() -> bool: return station
func get_outbreak() -> bool: return outbreak
func get_protected() -> bool: return protected
func get_city_node() -> Node: return city_node

func set_protection(p) -> void: protected = p
func set_outbreak(o) -> void: outbreak = o
func set_city_node(node) -> void: city_node = node
	
func add_station() -> void: station = true
func should_outbreak() -> bool: return !outbreak

func _init(city_info) -> void:
	city_name = city_info["name"]
	colour = city_info["colour"]
	num_of_connections = city_info["num_of_connections"]
	connections = city_info["connections"]
	cubes["black"] = city_info["black"]
	cubes["blue"] = city_info["blue"]
	cubes["red"] = city_info["red"]
	cubes["yellow"] = city_info["yellow"]
	station = city_info["station"]

func infect(c) -> bool:
	if protected:
		print(city_name + " is protected, skipping infect.")
		return false
	print("Infecting " + city_name + " with " + c)
	var ob : bool # Should city outbreak
	if cubes[c] == 3:
		print(city_name + " is at " + str(cubes[c]) + " " + c)
		ob = true
	else: 
		cubes[c] += 1
		add_cube(c)
		print(city_name + " is at " + str(cubes[c]) + " " + c)
		ob = false
	# Check if info panel needs to be updated.
	if InfoPanel.current_city and InfoPanel.current_city.get_city_name() == get_city_name():
		InfoPanel.update_text(null)
		print("Updating Info Panel after infection.")
	return ob

func infect_epidemic() -> bool:
	if protected:
		print(city_name + " is protected, skipping epidemic.")
		return false
	var ob := true # Should city outbreak; set to true on default
	print(city_name + " is target of Epidemic, it is at:" + str(cubes[colour]) + " " + colour + " cubes")
	# Check if cubes are at zero and the city should not outbreak
	if cubes[colour] == 0:
		ob = false
	# Add cubes until there are 3 on city.
	for i in 3 - cubes[colour]:
		add_cube(colour)
	cubes[colour] = 3
	# Check if info panel needs to be updated.
	if InfoPanel.current_city and InfoPanel.current_city.get_city_name() == get_city_name():
		InfoPanel.update_text(null)
		print("Updating Info Panel after epidemic.")
	return ob

func treat_disease(c, cured) -> bool:
	print("Treating " + c)
	var treated := true # Check for if treatment actually occured and action needs to be reduced
	if cubes[c] == 0: # Check if city needs treating
		treated = false
	elif cured: # Treat all cubes
		for i in cubes[c]:
			remove_cube(c)
		cubes[c] = 0
	else: # Treat one cube
		cubes[c] -= 1
		remove_cube(c)
	# Check if info panel needs to be updated.
	if treated and InfoPanel.current_city and InfoPanel.current_city.get_city_name() == get_city_name():
		InfoPanel.update_text(null)
		print("Updating Info Panel after treatment.")
	return treated 

func add_cube(c:String) -> void:
	var cube = cube_scene.instantiate()
	city_node.add_child(cube)
	cube.colour = c
	cube.global_position = city_node.global_position + Vector2(randf_range(-15,15),randf_range(-10,10))
	match c:
		"blue":cube.modulate = Color(0.2,0.4,1)
		"red":cube.modulate = Color(1, 0.2, 0.2)
		"yellow":cube.modulate = Color(1,1,0.2)
		"black":cube.modulate = Color(0.1,0.1,0.1)
	cube_nodes.append(cube)

func remove_cube(c:String) -> void:
	for i in cube_nodes.size():
		if cube_nodes[i].colour == c:
			cube_nodes[i].queue_free()
			cube_nodes.erase(cube_nodes[i])
			return
