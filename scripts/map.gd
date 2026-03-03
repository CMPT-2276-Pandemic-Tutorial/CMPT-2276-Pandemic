extends Node
var FILE_PATH = "res://map/baseboard.json"

var cities = []
var num_of_cities = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var json = JSON.new()
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	var json_text = file.get_as_text()
	var error = json.parse(json_text)
	file.close()
	if error == OK:
		var data_received = json.data
		num_of_cities = data_received["num_of_cities"]
		for i : int in num_of_cities:
			cities.append(City.new(data_received["cities"][i])) 
		for i : int in num_of_cities:
			print(cities[i].name)
	else:
		print("JSON Parse Error")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
