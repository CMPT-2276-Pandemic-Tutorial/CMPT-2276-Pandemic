extends Node

#Comments may be excessive - I am writing line by line for practice - Aidan Sweeney

var city_data = [] #storing the array from JSON file

func _ready():
		load_city_data() #Declaration for loading data from json - AS
		connect_city_signals() #declaration for connecting signals to buttons (collision shapes) - AS
		GameManager.set_references() #called to set references when scene is opened
		
func load_city_data():
		var file = FileAccess.open("res://boardInformation.json", FileAccess.READ) #open the json file and give godot read access - AS
		var json_text = file.get_as_text() #godot method to return the file contents as a string for reading - AS
		var data = JSON.parse_string(json_text) #parse the JSON string from above. Godot Docs for 4.6 show better methods? If this fails try using parse() - AS
		
		city_data = data["cities"] # Adds cities into the Array from JSON file. 3/4 - THIS WASN'T WORKING BECAUSE IT WAS GODOT 3 COMMAND RETURNING A DICTIONARY FML - AS
		
func connect_city_signals():
	var cities_node = $cityNodes # pulls the cityNodes node to access the individual nodes
	if cities_node == null: #debug error
		push_error("cityNodes node not found")
		return
		
	for city in cities_node.get_children(): #check if city has signal connected - AS
		if city.has_signal("city_clicked"):
			city.connect("city_clicked", _on_city_clicked) 
	
func _on_city_clicked(city_name):
	var city_info = null #start click off at nothing
	print("DEBUG TEST - Clicked city name ", city_name)
	for x in city_data:
		if x["name"] == city_name:
			city_info = x
			break
	if city_info == null:
		print("City not found in JSON: ", city_name)
		return
			
	$CityDescriptionBox/panel/info.text = "Name: " + city_info["name"] + "\nBlack Cubes: " + str(city_info["black"]) + "\nRed Cubes: " + str(city_info["red"]) + "\nYellow Cubes: " + str(city_info["yellow"]) + "\nBlue Cubes: " + str(city_info["blue"])+ "\nStation: " + str(city_info["station"])  
	
	
		
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	for i in Map.cityCoords.size():
#		var add_city = $Area2D.duplicate()
#		add_city.position = Map.cityCoords[i]
#		add_city.name = Map.cities[i].get_city_name()
#		add_child(add_city)
#	$Area2D.visible = false # hide our template area at 0,0


func _on_button_pressed() -> void:
	GameManager.endTurn()
	$cardsAndDecks/InfectDeck.draw_infect_card()
	$TurnLabel.text = "player " + str(GameManager.currentPlayer + 1) + "'s turn"
