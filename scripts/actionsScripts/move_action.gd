extends Area2D

var last_city_pressed

#@onready var player1 = $"../../players/Player1"
#@onready var player2 = $"../../players/Player2"
#@onready var player3 = $"../../players/Player3"
#@onready var player4 = $"../../players/Player4"
#var players: Array[Node2D] = []

func _ready() -> void:
	#players = [player1, player2, player3, player4]
	pass

func move(viewport: Node, event: InputEvent, shape_idx: int, player, destination) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if last_city_pressed != destination: 
			last_city_pressed = destination
			return
		if GameManager.actionCount <= 0:
			print("No actions remaining!")
			return
		if player.current_city == destination:
			print("Already there")
			return
		var current_city = Map.findCity(player.current_city)
		#print(player.current_city)
		print(destination)
		var is_des_connected = false
		for i in current_city.get_num_of_connections():
			if current_city.get_connection_name(i) == destination:
				is_des_connected = true
		if is_des_connected:
			var board_position = get_node("/root/Board/cityNodes/" + destination)
			player.global_position = board_position.global_position
			print(board_position.global_position)
			player.current_city = destination
			if GameManager.playerRole[GameManager.currentPlayer] == "Quarantine Specialist":
				Map.resetProtection()
				current_city.set_protection(true)
				for i in current_city.get_num_of_connections():
					Map.findCity(current_city.get_connection_name(i)).set_protection(true)
			GameManager.actionCount -= 1
			return
		
		#check if shuttle flight is possible
		if current_city.get_station() and Map.findCity(destination).get_station():
			var board_position = get_node("/root/Board/cityNodes/" + destination)
			player.global_position = board_position.global_position
			print(board_position.global_position)
			player.current_city = destination
			if GameManager.playerRole[GameManager.currentPlayer] == "Quarantine Specialist":
				Map.resetProtection()
				current_city.set_protection(true)
				for i in current_city.get_num_of_connections():
					Map.findCity(current_city.get_connection_name(i)).set_protection(true)
			GameManager.actionCount -= 1
			return
		
		#check if direct flight is possible
		var player_hand = PlayerHand.player_hand[GameManager.currentPlayer]
		for card in player_hand.size():
			var data = player_hand[card].card_data
			if typeof(data) == TYPE_DICTIONARY and data.get("name") == destination:
				var board_position = get_node("/root/Board/cityNodes/" + destination)
				player.global_position = board_position.global_position
				print(board_position.global_position)
				player.current_city = destination
				if GameManager.playerRole[GameManager.currentPlayer] == "Quarantine Specialist":
					Map.resetProtection()
					current_city.set_protection(true)
					for i in current_city.get_num_of_connections():
						Map.findCity(current_city.get_connection_name(i)).set_protection(true)
				PlayerHand.remove_card_from_hand(player_hand[card])
				GameManager.actionCount -= 1
				return
		
		print("invalid move")
