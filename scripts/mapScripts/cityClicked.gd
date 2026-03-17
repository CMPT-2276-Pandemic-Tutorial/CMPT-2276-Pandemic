extends Area2D

signal city_clicked(city_name)

@onready var player1 = $"../../players/Player1"
@onready var player2 = $"../../players/Player2"
@onready var player3 = $"../../players/Player3"
@onready var player4 = $"../../players/Player4"

var players: Array[Node2D] = []

func _ready():
	input_pickable = true
	players = [player1, player2, player3, player4]

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("city_clicked", name)
		#print(players[GameManager.currentPlayer].current_city)
		MoveAction.move(viewport, event, shape_idx, players[GameManager.currentPlayer], name)
