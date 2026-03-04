extends Area2D

@onready var ui = get_node("/root/UI Prototype")
@onready var player1 = get_node("/root/UI Prototype/Player1")
@onready var player2 = get_node("/root/UI Prototype/Player2")
@onready var player3 = get_node("/root/UI Prototype/Player3")
@onready var player4 = get_node("/root/UI Prototype/Player4")
var players: Array[Node2D] = []

func _ready() -> void:
	players = [player1, player2, player3, player4]

func black_treat_button() -> void:
	treat_disease_action("black")

func blue_treat_button() -> void:
	treat_disease_action("blue")

func red_treat_button() -> void:
	treat_disease_action("red")	

func yellow_treat_button() -> void:
	treat_disease_action("yellow")

func treat_disease_action(colour) -> void:
	if GameManager.actionCount <= 0:
		print("No actions remaining!")
		return
	var player = players[GameManager.currentPlayer]
	var current_city = Map.findCity(player.current_city)
	current_city.treat_disease(colour, GameManager.cured[colour])
	GameManager.actionCount -= 1
