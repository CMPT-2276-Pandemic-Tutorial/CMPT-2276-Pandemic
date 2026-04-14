extends CanvasLayer

@onready var highlight = $Highlight
@onready var text_label = $Highlight/Label

var stages = []
var current_stage = 0
var tutorial_active = false

func _ready() -> void:
	visible = false

func start_tutorial():
	visible = true
	tutorial_active = true
	
	#each stage cycles to a different node on the board and describes its function and how to use it
	stages = [
		{
			"node": $"../cardsAndDecks/playerDeck/Deck",
			"text": "This is the player deck, 2 cards are drawn from here and put into the current players hand at the end of the turn.
			\nIf there arent any cards remaining on the next players turn then you will lose the game!"
		},
		{
			"node": $"../cityNodes/Atlanta",
			"text": "This city serves as the starting point for all players, it already has a research station that can cure disease"
		},
		{
			"node": $"../players/Player1",
			"text": "This is your player icon, showing where you are on the map, you can click on the city nodes adjecent to move directly to them"
		},
		{
			"node": $"../Markers/InfectionMarker",
			"text": "This shows the current infection rate, once a players turn ends infection cards will be drawn based on the rate.
			\nThings start to get really scary once this climbs up!"
		},
		{
			"node": $"../cardsAndDecks/infectionDeck/InfectDeck",
			"text": "This is where infection cards are drawn from, they spread disease cubes to cities around the globe. 
			\nOnce a city recieves 4 disease cubes it will cause an outbreak spread its infection to neighboring cities! Don't let the disease build up!"
		},
		{
			"node": $"../Markers/OutbreakMarker",
			"text": "This shows the current outbreak level, you lose once it reaches the red skull (level 8)!"
		},
		{
			"node": $"../ActionHandler/ActionButtons/BuildStation",
			"text": "Press this to build a research station on the city you are currently on, research stations can be used for movement and curing disease!"
		},
		{
			"node": $"../ActionHandler/ActionButtons/CureYellow",
			"text": "These buttons can be used to cure disease once you have enough city cards of the same color and are on a city with a research station."
		},
		{
			"node": $"../ActionHandler/ActionButtons/TreatYellow",
			"text": "These buttons can be used to remove disease cubes from the city you are currently on"
		},
		{
			"node": $"../Markers/CureMarkerRed",
			"text": "Here you can see which diseases have been cured and which still remain, cure all 4 to win the game!"
		},
		{
			"node": $"../cardsAndDecks/cardSlots/playercard1",
			"text": "The cards currently in your hand will appear here, you can only have up to 7 at any time"
		},
		{
			"node": $"../cardsAndDecks/cardSlots/playerclass",
			"text": "This shows the current player's role card, each have their own unique ability that should be used as part of your strategy"
		},
		{
			"node": $"../ActionHandler/ActionButtons/Trade",
			"text": "This button opens up the trade menu where you can trade selected cards with players who are in the same city"
		},
		{
			"node": $"../endTurnButton",
			"text": "Click this button to end your turn and start the next players turn"
		},
	]
	current_stage = 0
	show_stage()


func show_stage():
	var stage = stages[current_stage]
	var node = stage["node"]
	if node is Control:
		highlight_control(node)
	else:
		highlight_node2d(node)
	text_label.text = stage["text"]


func next_stage():
	current_stage += 1
	print("Current tutorial stage: ", current_stage)
	if current_stage >= stages.size():
		end_tutorial()
	else:
		show_stage()


func previous_stage():
	print("Current tutorial stage: ", current_stage)
	if current_stage == 0:
		print("Already at the start of the tutorial!")
		return
	else:
		current_stage -= 1
		show_stage()


func end_tutorial():
	visible = false
	tutorial_active = false
	print("Tutorial over!")


func highlight_control(control: Control):
	var rect = control.get_global_rect()
	var canvas_transform = get_viewport().get_canvas_transform()
	var screen_pos = canvas_transform * rect.position
	var padding = 10
	highlight.global_position = screen_pos - Vector2(padding, padding)
	highlight.size = rect.size + Vector2(padding * 2, padding * 2)


func highlight_node2d(node: Node2D):
	var canvas_transform = get_viewport().get_canvas_transform()
	var screen_pos = canvas_transform * node.global_position
	var padding = 10
	var size = Vector2(100, 100)
	highlight.global_position = screen_pos - Vector2(padding+50, padding+50)
	highlight.size = size + Vector2(padding * 2, padding * 2)


#func _input(event: InputEvent) -> void:
	#if not tutorial_active:
		#return
	#if event is InputEventMouseButton and event.pressed:
		#next_stage()
#

func _on_previous_pressed() -> void:
	previous_stage()

func _on_next_pressed() -> void:
	next_stage()

func _on_end_tutorial_pressed() -> void:
	end_tutorial()
