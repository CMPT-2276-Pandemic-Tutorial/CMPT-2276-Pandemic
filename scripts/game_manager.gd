extends Node

signal action_count_changed(value)
signal turn_changed(value)
signal current_player_changed(value)

var map
var infectionMarker: Node
var outbreakMarker: Node
var infectionDeck: Node

var turnNum: int:
	set(value):
		if value == turnNum:
			return
		turnNum = value
		turn_changed.emit(turnNum)
var playerCount = 4
var currentPlayer: int:
	set(value):
		if value == currentPlayer:
			return
		currentPlayer = value
		current_player_changed.emit(currentPlayer)
#Just hard coding the roles for right now
var playerRole = ["Generalist", "Scientist", "Medic", "Quarantine Specialist"]
var actionCount: int:
	set(value):
		if value == actionCount:
			return
		actionCount = value
		action_count_changed.emit(actionCount)
var infectionIndex = 0
var infectionRate = [2,2,2,3,3,4,4]
var outbreakLevel = 0
var cured = {"black": false, "blue": false, "red": false, "yellow": false}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map = Map

#Functions to handle start/end of turn
func beginNextTurn() -> void:
	turnNum += 1
	#Start the next players turn
	currentPlayer = turnNum % playerCount
	if playerRole[currentPlayer] == "Generalist":
		actionCount = 5
	else: 
		actionCount = 4
	CardManager.show_player_hand(currentPlayer)

func endTurn() -> void:
	infectCities()
	beginNextTurn()

#Game end function, parameter is bool - true means won, false means lost
func gameEnd(won) -> void:
	if won:
		print("game won")
	else:
		print("game lost")

func trading_partners(players):
	var current_player_index = GameManager.currentPlayer #returns int index of the current player 
	var current_player_node = players[current_player_index] #returns instanced Player node of the current player 
	
	#checks if a trade is possible and keeps a list of available players
	var valid_players: Array[int] = []
	for i in range(players.size()):
		if i == current_player_index:
			continue #skips the iteration of the current player
		if players[i].current_city == current_player_node.current_city:
			valid_players.append(i)
	return valid_players


#Functions for handling infecting cities and outbreaks
func infectCities() -> void:
	var cityToInfect
	for i in infectionRate[infectionIndex]:
		var cityToInfectString = infectionDeck.draw_infect_card()
		cityToInfect = map.findCity(cityToInfectString) #Replace New York with draw
		print("Infected city is " + cityToInfectString)
		if cityToInfect.infect(cityToInfect.get_colour()): #Infects City and checks for outbreak
			outbreak(cityToInfect)
			map.resetOutbreaks()

func epidemic() -> void:
	if infectionIndex < 6: 
		infectionIndex += 1
		infectionMarker.move_local_x(40.0)
	var cityToInfectString = infectionDeck.draw_infect_card_bottom()
	var cityToInfect = map.findCity(cityToInfectString)
	print("Epidemic city is " + cityToInfectString)
	if cityToInfect.infect_epidemic(): #Infects City and checks for outbreak
		outbreak(cityToInfect)
		map.resetOutbreaks()
	infectionDeck.reshuffle()

func outbreak(cityOutbreaking) -> void:
	if cityOutbreaking.should_outbreak():
		print(cityOutbreaking.get_city_name() + " is outbreaking")
		cityOutbreaking.set_outbreak(true)
		outbreakLevel += 1
		outbreakMarker.move_local_y(40.0)
		outbreakMarker.move_local_x(pow(-1,outbreakLevel+1)*40)
		if outbreakLevel >= 8:
			gameEnd(false)
		for i in cityOutbreaking.get_num_of_connections():
			var chain = map.findCity(cityOutbreaking.get_connection_name(i)).infect(cityOutbreaking.get_colour())
			if chain: 
				outbreak(map.findCity(cityOutbreaking.get_connection_name(i)))

func check_for_win() -> bool:
	var allCured = cured["black"] && cured["blue"] && cured["red"] && cured["yellow"]
	return allCured
