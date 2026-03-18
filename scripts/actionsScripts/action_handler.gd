extends Node

@export_category("Players")
@export var player1: Node
@export var player2: Node
@export var player3: Node
@export var player4: Node
@export_category("Cure Tokens") 
@export var cureMarkerBlack: Node
@export var cureMarkerBlue: Node
@export var cureMarkerRed: Node
@export var cureMarkerYellow: Node

var players: Array[Node2D] = []
var cureMarkers

func _ready() -> void:
	players = [player1, player2, player3, player4]
	cureMarkers = {"black" = cureMarkerBlack, "blue" = cureMarkerBlue, "red" = cureMarkerRed, "yellow" = cureMarkerYellow}
	cureMarkers["black"].visible = false
	cureMarkers["blue"].visible = false
	cureMarkers["red"].visible = false
	cureMarkers["yellow"].visible = false

func run_action(a, c):
	if a == "cure":
		print("Running Cure")
		cure_disease_action(c)
	elif a == "treat":
		print("Running Treat")
		treat_disease_action(c)
	elif a == "station":
		print("Running Build Station")
		build_research_station_action()

func cure_disease_action(colour) -> void:
	if GameManager.actionCount <= 0:
		print("No actions remaining!")
		return
	var player = players[GameManager.currentPlayer]
	if !Map.findCity(player.current_city).get_station():
		print("City does not have station")
		return
	if GameManager.cured[colour]:
		print("Colour already cured")
		return
	if !PlayerHand.can_cure(colour):
		print("Not enough cards to cure")
		return 
	GameManager.cured[colour] = true
	cureMarkers[colour].visible = true
	if GameManager.check_for_win():
		GameManager.gameEnd(true)
	GameManager.actionCount -= 1

func treat_disease_action(colour) -> void:
	if GameManager.actionCount <= 0:
		print("No actions remaining!")
		return
	var player = players[GameManager.currentPlayer]
	var current_city = Map.findCity(player.current_city)
	current_city.treat_disease(colour, GameManager.cured[colour])
	GameManager.actionCount -= 1

func build_research_station_action() -> void:
	if GameManager.actionCount <= 0:
		print("No actions remaining!")
		return
	var player = players[GameManager.currentPlayer]
	var current_city = Map.findCity(player.current_city)
	if current_city.get_station():
		print("Station already built")
		return
	var player_hand = PlayerHand.player_hand[GameManager.currentPlayer]
	for card in player_hand.size():
		var data = player_hand[card].card_data
		if typeof(data) == TYPE_DICTIONARY and data.get("name") == player.current_city:
			Map.findCity(player.current_city).add_station()
			PlayerHand.remove_card_from_hand(player_hand[card])
			GameManager.actionCount -= 1
			print("Station built")
			return
	print("Do not have city card to build station")
