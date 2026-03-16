extends Node

var map
var infectionMarker: Node
var outbreakMarker: Node
var infectionDeck: Node

var turnNum = 0
var playerCount = 4
var currentPlayer = 0
var actionCount = 4
var infectionIndex = 0
var infectionRate = [2,2,2,3,3,4,4]
var outbreakLevel = 0
var cured = {"black": false, "blue": false, "red": false, "yellow": false}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map = Map

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Functions to handle start/end of turn
func beginNextTurn() -> void:
	turnNum += 1
	#Start the next players turn
	currentPlayer = turnNum % playerCount
	actionCount = 4
	CardManager.show_player_hand(currentPlayer)

func endTurn() -> void:
	#Draw two player cards
	infectCities()

#Game end function, parameter is bool - true means won, false means lost
func gameEnd(won) -> void:
	if won:
		print("game won")
	else:
		print("game lost")

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
	beginNextTurn()

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
