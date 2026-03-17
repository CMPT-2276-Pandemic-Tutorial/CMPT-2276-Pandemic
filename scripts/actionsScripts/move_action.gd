extends Area2D

#@onready var player1 = $"../../players/Player1"
#@onready var player2 = $"../../players/Player2"
#@onready var player3 = $"../../players/Player3"
#@onready var player4 = $"../../players/Player4"
#var players: Array[Node2D] = []

func _ready() -> void:
	#players = [player1, player2, player3, player4]
	pass

func move(viewport: Node, event: InputEvent, shape_idx: int, player, name) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameManager.actionCount <= 0:
			print("No actions remaining!")
			return
		var current_city = Map.findCity(player.current_city)
		#print(player.current_city)
		print(name)
		var is_connected = false
		for i in current_city.get_num_of_connections():
			if current_city.get_connection_name(i) == name:
				is_connected = true
		if is_connected:
			var position = get_node("/root/Board/cityNodes/" + name)
			player.global_position = position.global_position
			print(position.global_position)
			player.current_city = name
			if GameManager.playerRole[GameManager.currentPlayer == "Quarantine Specialist"]:
				Map.resetProtection()
				current_city.set_protection(true)
				for i in current_city.get_num_of_connections():
					Map.findCity(current_city.get_connection_name(i)).set_protection(true)
			GameManager.actionCount -= 1
		else:
			print("invalid move")
