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

func cure_disease_action(colour) -> void:
	if GameManager.actionCount <= 0:
		print("No actions remaining!")
		return
	if GameManager.cured[colour]:
		print("Colour already cured")
		return
	if !PlayerHand.can_cure(colour):
		print("Not enough cards to cure")
		return 
	var player = players[GameManager.currentPlayer]
	if !Map.findCity(player.current_city).get_station():
		print("City does not have station")
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
