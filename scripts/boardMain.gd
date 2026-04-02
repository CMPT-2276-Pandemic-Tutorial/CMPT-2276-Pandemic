extends Node

#Comments may be excessive - I am writing line by line for practice - Aidan Sweeney

var city_data = [] #storing the array from JSON file
@onready var roleButton = $RoleCardButton
var roleImages = {
	0: preload("res://assets/tutorialAssets/RoleCards/GeneralistRoleCardAdjustedSize.jpg"),
	1: preload("res://assets/tutorialAssets/RoleCards/scientistAdjustedSize.png"),
	2: preload("res://assets/tutorialAssets/RoleCards/MedicAdjustedSize.jpg"),
	3: preload("res://assets/tutorialAssets/RoleCards/QuarantineSpecialistAdjustedSize.jpg")
}
var roleTutorialScenes = {
	0: preload ("res://scenes/UIScenes/tutorialScenes/generalistRoleTutorial.tscn"),
	1: preload ("res://scenes/UIScenes/tutorialScenes/scientistRoleTutorial.tscn"),
	2: preload ("res://scenes/UIScenes/tutorialScenes/MedicRoleTutorial.tscn"),
	3: preload("res://scenes/UIScenes/tutorialScenes/QuarantineRoleTutorial.tscn")
				
}

func _ready():
		load_city_data() #Declaration for loading data from json - AS
		connect_city_signals() #declaration for connecting signals to buttons (collision shapes) - AS
		GameManager.action_count_changed.connect(_on_action_changed)
		if GameManager.playerRole[GameManager.currentPlayer] == "Generalist":
			GameManager.actionCount = 5
		else: 
			GameManager.actionCount = 4
		#Draw cards for player1s first turn
		$cardsAndDecks/playerDeck/Deck.draw_card()
		$cardsAndDecks/playerDeck/Deck.draw_card()
		$playerIndicator.side_card_display()
		
		


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
	city_info = Map.findCity(city_name)
	if city_info == null:
		print("City not found in JSON: ", city_name)
		return
	InfoPanel.update_text(city_info)

func _on_action_changed(action):
	$ActionsRemainingLabel.text = "Actions Remaining:  " + str(action)

		
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	for i in Map.cityCoords.size():
#		var add_city = $Area2D.duplicate()
#		add_city.position = Map.cityCoords[i]
#		add_city.name = Map.cities[i].get_city_name()
#		add_child(add_city)
#	$Area2D.visible = false # hide our template area at 0,0
func show_role_overlay(role_id:int)->void:
	var overlay_scene = roleTutorialScenes[role_id]
	var overlay_instance = overlay_scene.instantiate()
	$RoleCardOverlay.add_child(overlay_instance)
	

func _on_button_pressed() -> void:
	$ActionHandler.close_trade_action()
	PlayerHand.clear_card_highlight()
	$cardsAndDecks/playerDeck/Deck.draw_card()
	$cardsAndDecks/playerDeck/Deck.draw_card()
	$playerIndicator.side_card_display()
	await get_tree().create_timer(0.55).timeout
	
	GameManager.endTurn()
	$playerIndicator.change_player()
	$playerIndicator.side_card_display()
	_update_role_card()
	if GameManager.turnNum <= 3:
		$cardsAndDecks/playerDeck/Deck.draw_card()
		$cardsAndDecks/playerDeck/Deck.draw_card()
		$playerIndicator.side_card_display()
		
	$TurnLabel.text = "Player " + str(GameManager.currentPlayer + 1) + "'s Turn"
	match(GameManager.currentPlayer):
		0:
			$TurnLabel.label_settings.font_color = Color(0.247, 0.278, 0.8, 1.0)
		1:
			$TurnLabel.label_settings.font_color = Color(0.725, 0.478, 0.341, 1.0)
		2:
			$TurnLabel.label_settings.font_color = Color(0.431, 0.424, 0.427, 1.0)
		3:
			$TurnLabel.label_settings.font_color = Color(0.929, 0.106, 0.141, 1.0)


func _on_role_card_button_pressed() -> void:
	var roleCurrentPlayer = GameManager.currentPlayer
	#$RoleCardButton.texture_normal = roleImages[roleCurrentPlayer]
	show_role_overlay(roleCurrentPlayer)
	
func _update_role_card() -> void:
	var roleCurrentPlayer = GameManager.currentPlayer
	$RoleCardButton.texture_normal = roleImages[roleCurrentPlayer]
