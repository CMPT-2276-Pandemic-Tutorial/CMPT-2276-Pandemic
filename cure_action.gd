extends Area2D

@onready var player1 = get_node("/root/UI Prototype/Player1")
@onready var player2 = get_node("/root/UI Prototype/Player2")
@onready var player3 = get_node("/root/UI Prototype/Player3")
@onready var player4 = get_node("/root/UI Prototype/Player4")
@onready var cureMarkerBlack = get_node("/root/UI Prototype/Markers/CureMarkerPurp")
@onready var cureMarkerBlue = get_node("/root/UI Prototype/Markers/CureMarkerBlue")
@onready var cureMarkerRed = get_node("/root/UI Prototype/Markers/CureMarkerRed")
@onready var cureMarkerYel = get_node("/root/UI Prototype/Markers/CureMarkerYel")
var players: Array[Node2D] = []
var cureMarkers

func _ready() -> void:
	players = [player1, player2, player3, player4]
	cureMarkers = {"black" = cureMarkerBlack, "blue" = cureMarkerBlue, "red" = cureMarkerRed, "yellow" = cureMarkerYel}
	cureMarkers["black"].visible = false
	cureMarkers["blue"].visible = false
	cureMarkers["red"].visible = false
	cureMarkers["yellow"].visible = false

func black_cure_button() -> void:
	treat_cure_action("black")

func blue_cure_button() -> void:
	treat_cure_action("blue")

func red_cure_button() -> void:
	treat_cure_action("red")	

func yellow_cure_button() -> void:
	treat_cure_action("yellow")

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
