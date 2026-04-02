extends Node
const FILE_PATH = "res://boardInformation.json"

var cities : Array[City] = []
var num_of_cities : int = 0
var numOfCubes : Dictionary[String, int] = {"blue": 0, "black": 0, "red": 0, "yellow":0}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get Map as text
	var json = JSON.new()
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	# Parse Map
	var error = json.parse(json_text)
	assert(error == OK, "Error: JSON Parse Error, could not load map") # Check for parse error, aborts if found
	# Create cities
	var data_received = json.data
	num_of_cities = data_received["num_of_cities"]
	for i : int in num_of_cities:
		cities.append(City.new(data_received["cities"][i])) 
	# Add protection for when players spawn in Atlanta (Quarantine Specialist)
	var atlanta = findCity("Atlanta")
	atlanta.set_protection(true)
	for i in atlanta.get_num_of_connections():
		findCity(atlanta.get_connection_name(i)).set_protection(true)
	#Print test
	for i : int in num_of_cities:
		print(cities[i].city_name, " Protection: ", cities[i].protected)

func findCity(cityName) -> City:
	for i in num_of_cities:
		if cities[i].get_city_name() == cityName:
			return cities[i]
	return null
	
func resetOutbreaks() -> void:
	for i in num_of_cities:
		cities[i].set_outbreak(false)

func resetProtection() -> void:
	for i in num_of_cities:
		cities[i].set_protection(false)
