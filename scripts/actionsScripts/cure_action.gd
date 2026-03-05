extends Node

@onready var player1 = $"../../players/Player1"
@onready var player2 = $"../../players/Player2"
@onready var player3 = $"../../players/Player3"
@onready var player4 = $"../../players/Player4"
@onready var cureMarkerBlack = $"../../Markers/CureMarkerPurp"
@onready var cureMarkerBlue = $"../../Markers/CureMarkerBlue"
@onready var cureMarkerRed = $"../../Markers/CureMarkerRed"
@onready var cureMarkerYel = $"../../Markers/CureMarkerYel"
var players: Array[Node2D] = []
var cureMarkers

func _ready() -> void:
	players = [player1, player2, player3, player4]
	cureMarkers = {"black" = cureMarkerBlack, "blue" = cureMarkerBlue, "red" = cureMarkerRed, "yellow" = cureMarkerYel}
	cureMarkers["black"].visible = false
	cureMarkers["blue"].visible = false
	cureMarkers["red"].visible = false
	cureMarkers["yellow"].visible = false

func treat_cure_action(colour) -> void:
	if GameManager.actionCount <= 0:
		print("No actions remaining!")
		return
	var player = players[GameManager.currentPlayer]
	if GameManager.cured[colour]:
		print("Colour already cured")
		return
	for i in 8: #Check player's hand for 5 cards of the right colour
		pass
	for i in 5: #Remove cards from player's hand
		pass
	GameManager.cured[colour] = true
	cureMarkers[colour].visible = true
	if GameManager.check_for_win():
		GameManager.gameEnd(true)
	GameManager.actionCount -= 1

func _on_cure_black_button_pressed() -> void:
	treat_cure_action("black")

func _on_cure_blue_button_pressed() -> void:
	treat_cure_action("blue")

func _on_cure_red_button_pressed() -> void:
	treat_cure_action("red")	

func _on_cure_yellow_button_pressed() -> void:
	treat_cure_action("yellow")
