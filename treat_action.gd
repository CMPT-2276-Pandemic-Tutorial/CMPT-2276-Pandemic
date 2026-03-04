extends Area2D

@onready var player1 = get_node("/root/UI Prototype/Player1")
@onready var player2 = get_node("/root/UI Prototype/Player2")
@onready var player3 = get_node("/root/UI Prototype/Player3")
@onready var player4 = get_node("/root/UI Prototype/Player4")
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

func _on_button_2_pressed() -> void:
	treat_disease_action("black")

func _on_button_3_pressed() -> void:
	treat_disease_action("blue")

func _on_button_4_pressed() -> void:
	treat_disease_action("red")	

func _on_button_5_pressed() -> void:
	treat_disease_action("yellow")
