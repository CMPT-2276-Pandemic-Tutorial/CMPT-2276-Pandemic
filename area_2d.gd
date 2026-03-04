extends Area2D

@onready var ui = get_node("/root/UI Prototype")
@onready var player1 = get_node("/root/UI Prototype/Player1")
@onready var player2 = get_node("/root/UI Prototype/Player2")
@onready var player3 = get_node("/root/UI Prototype/Player3")
@onready var player4 = get_node("/root/UI Prototype/Player4")
var players: Array[Node2D] = []

func _ready() -> void:
	players = [player1, player2, player3, player4]

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if GameManager.actionCount <= 0:
			print("No actions remaining!")
			return
		var player = players[GameManager.currentPlayer]
		
		var current_city = Map.findCity(player.current_city)
		var is_connected = false
		for i in current_city.get_num_of_connections():
			if current_city.get_connection_name(i) == name:
				is_connected = true

		if is_connected:
			player.global_position = global_position
			player.current_city = name
			GameManager.actionCount -= 1
		else:
			print("invalid move")
