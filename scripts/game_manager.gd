extends Node

var map
var input_handler

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
	currentPlayer = turnNum % playerCount
	actionCount = 4

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
		cityToInfect = map.findCity("New York") #Replace New York with draw
		if cityToInfect.infect(cityToInfect.get_colour()): #Infects City and checks for outbreak
			outbreak(cityToInfect)
			map.resetOutbreaks()
	beginNextTurn()

func outbreak(cityOutbreaking) -> void:
	if cityOutbreaking.should_outbreak():
		print(cityOutbreaking.get_city_name() + " is outbreaking")
		cityOutbreaking.set_outbreak(true)
		outbreakLevel += 1
		if outbreakLevel >= 8:
			gameEnd(false)
		for i in cityOutbreaking.get_num_of_connections():
			var chain = map.findCity(cityOutbreaking.get_connection_name(i)).infect(cityOutbreaking.get_colour())
			if chain: 
				outbreak(map.findCity(cityOutbreaking.get_connection_name(i)))


#Action functions
var selected_cards #array of selected cards
var selected_city
var selected_player
var selected_colour

func action_cure_disease() -> void:
	if !cured[selected_colour]:
		for i in selected_cards.length():
			if !selected_colour: #check that selected_cards[i]'s colour matches selected_colour
				return
		cured[selected_colour] = true
		if check_for_win():
			gameEnd(true)
		actionCount -= 1

func check_for_win() -> bool:
	var allCured = true
	for i in 4:
		allCured = allCured && cured[i]
	return allCured

func _on_button_pressed() -> void: #test button
	endTurn()
