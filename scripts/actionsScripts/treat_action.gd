extends Node

@onready var player1 = $"../../players/Player1"
@onready var player2 = $"../../players/Player2"
@onready var player3 = $"../../players/Player3"
@onready var player4 = $"../../players/Player4"
var players: Array[Node2D] = []

func _ready() -> void:
	players = [player1, player2, player3, player4]

func treat_disease_action(colour) -> void:
	if GameManager.actionCount <= 0:
		print("No actions remaining!")
		return
	var player = players[GameManager.currentPlayer]
	var current_city = Map.findCity(player.current_city)
	current_city.treat_disease(colour, GameManager.cured[colour])
	GameManager.actionCount -= 1

func _on_treat_black_button_pressed() -> void:
	treat_disease_action("black")

func _on_treat_blue_button_pressed() -> void:
	treat_disease_action("blue")

func _on_treat_red_button_pressed() -> void:
	treat_disease_action("red")	

func _on_treat_yellow_button_pressed() -> void:
	treat_disease_action("yellow")
