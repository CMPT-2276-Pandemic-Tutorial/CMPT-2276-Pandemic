extends Node

var map

var turnNum = 0
var playerCount = 4
var currentPlayer = 0
var actionCount = 0
var infectionIndex = 0
var infectionRate = [2,2,2,3,3,4,4]
var outbreakLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map = get_node("Map")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func beginNextTurn()-> void:
	currentPlayer = turnNum % playerCount
	actionCount = 4

func endTurn() -> void:
	#Draw two player cards
	infectCities()

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

func gameEnd(won) -> void:
	if won:
		print("game won")
	else:
		print("game lost")


func _on_button_pressed() -> void:
	endTurn()
