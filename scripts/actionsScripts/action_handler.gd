extends Node

signal trade_requested(player_a, player_b)

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
@export_category("Other Elements")
@export var trade_container: Control

var research_station_scene = preload("res://scenes/iconScenes/research_station.tscn")
var players: Array[Node2D] = []
var cureMarkers

func _ready() -> void:
	add_to_group("action_handler")
	#player_hand_node = get_tree().get_first_node_in_group("player_hand")
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
	elif a == "station":
		print("Running Build Station")
		build_research_station_action()
	elif a == "trade":
		trade_action() #target player
	elif a == "close_trade":
		close_trade_action() #target player
	elif a == "trade_card":
		trade_card_action() #target player

#displays available trading options
func trade_action():
	var trade_partners = GameManager.trading_partners(players)
	#if trading partners are found then displays available actions
	if trade_partners.size() > 0:
		$ActionButtons/TradePanel.visible = true
		var container = $ActionButtons/TradePanel/AvailablePlayers
		for child in container.get_children():
			child.queue_free()
		for player_id in trade_partners:
			var btn = Button.new()
			btn.text = "Player " + str(player_id + 1)
			container.add_child(btn)
			btn.pressed.connect(_on_trade_partner_selected.bind(player_id))
	else:
		print("No available trading partners!")
		return

func trade_card_action():
	var player_hand = get_tree().get_first_node_in_group("player_hand")
	if player_hand.selected_card == null:
		print("No card selected!")
		return
	player_hand.confirm_trade()


func close_trade_action():
	$ActionButtons/TradePanel.visible = false
	PlayerHand.clear_card_highlight()
	var container = $ActionButtons/TradePanel/AvailablePlayers
	$ActionButtons/TradePanel/CurrentPlayerLabel.text = "                                          Please Select a Trade Partner!"
	for child in container.get_children():
		child.queue_free()
	for child in $ActionButtons/TradePanel/CardContainer.get_children():
		child.queue_free()


func _on_trade_partner_selected(target_player):
	var current_player = GameManager.currentPlayer
	$ActionButtons/TradePanel/CurrentPlayerLabel.text = "   Currently viewing Player " + str(target_player + 1) + "'s hand"
	print("Trade request between ", current_player, " and ", target_player)
	emit_signal("trade_requested", current_player, target_player)
	PlayerHand._on_trade_requested(current_player, target_player)

func cure_disease_action(colour) -> void:
	if GameManager.actionCount <= 0:
		print("No actions remaining!")
		return
	var player = players[GameManager.currentPlayer]
	if !Map.findCity(player.current_city).get_station():
		print("City does not have station")
		return
	if GameManager.cured[colour]:
		print("Colour already cured")
		return
	if !PlayerHand.can_cure(colour):
		print("Not enough cards to cure")
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
	var did_treat
	if GameManager.cured[colour] or GameManager.playerRole[GameManager.currentPlayer] == "Medic":
		did_treat = current_city.treat_disease(colour, true)
	else:
		did_treat = current_city.treat_disease(colour, false)
	if did_treat:
		GameManager.actionCount -= 1
	else:
		print("No cubes of colour to treat!")

func build_research_station_action() -> void:
	if GameManager.actionCount <= 0:
		print("No actions remaining!")
		return
	var player = players[GameManager.currentPlayer]
	var current_city = Map.findCity(player.current_city)
	if current_city.get_station():
		print("Station already built")
		return
	var player_hand = PlayerHand.player_hand[GameManager.currentPlayer]
	for card in player_hand.size():
		var data = player_hand[card].card_data
		if typeof(data) == TYPE_DICTIONARY and data.get("name") == player.current_city:
			Map.findCity(player.current_city).add_station()
			var station_icon = research_station_scene.instantiate()
			Map.findCity(player.current_city).get_city_node().add_child(station_icon)
			station_icon.global_position = Map.findCity(player.current_city).get_city_node().global_position
			PlayerHand.remove_card_from_hand(player_hand[card])
			GameManager.actionCount -= 1
			print("Station built")
			return
	print("Do not have city card to build station")
