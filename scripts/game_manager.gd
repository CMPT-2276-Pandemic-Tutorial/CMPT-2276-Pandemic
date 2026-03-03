extends Node

var map

var turnNum = 0
var playerCount = 4
var currentPlayer = 0
var actionCount = 0
var infectionIndex = 0
var infectionRate = [2,2,2,3,3,4,4]
var outbreakLevel = 0
var cured = {"black": false, "blue": false, "red": false, "yellow": false}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map = get_node("Map")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Functions to handle start/end of turn
func beginNextTurn()-> void:
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
var action
var instructions_tooltip
var selected_cards
var selected_city
var selected_player
var selected_colour

func action_move_drive() -> void:
	action = "drive"
	instructions_tooltip = "Select a city connected to the city you are on to move to that location."

func action_move_direct() -> void:
	action = "direct"
	instructions_tooltip = "Select a city card to move to that location."

func action_move_charter() -> void:
	action = "charter"
	instructions_tooltip = "Select a city card and player to move them to that location."

func action_move_shuttle() -> void:
	action = "shuttle"
	instructions_tooltip = "Select a city card with a research station to move to that location."

func action_treat_disease() -> void:
	action = "treat"
	instructions_tooltip = "Select a colour to treat the disease of that colour from your location."

func action_cure_disease() -> void:
	action = "cure"
	instructions_tooltip = "Select a colour and five city cards of that colour to cure that disease."

func action_confirm() -> void:
	if action >= 1:
		match action:
			"drive":
				if selected_city: #check for connection to player's current city
					#set player location to new city
					action -= 1
			"direct":
				#set player location to selected_cards[i]
				action -= 1
			"charter":
				#set selected_player location to selected_cards[i]
				action -= 1
			"shuttle":
				if selected_city: #check for station AND check current city for station 
					#set player location to new city
					action -= 1
			"treat":
				#call treat disease on player's location. city.treat_diease(selected_colour, cured[selected_colour])
				action -= 1
			"cure":
				if !cured[selected_colour]:
					for i in selected_cards.length():
						if !selected_colour: #check that selected_cards[i]'s colour matches selected_colour
							return
					cured[selected_colour] = true
					action -= 1


func _on_button_pressed() -> void: #test button
	endTurn()
