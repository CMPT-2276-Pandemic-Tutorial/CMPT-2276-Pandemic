extends Node2D

const INFECT_CARD_SCENE_PATH = "res://scenes/deckScenes/infect_card.tscn"
const MAP_JSON_PATH = "res://boardInformation.json"

var infect_deck = []
var discard_pile = []


func _ready() -> void:
	GameManager.infectionDeck = self
	set_meta("tooltip_name", "Infection Deck")
	set_meta("tooltip_desc", "Cards drawn from here will spread infection cubes on cities!")
	var file_text = FileAccess.get_file_as_string(MAP_JSON_PATH)
	var city_data = JSON.parse_string(file_text)
	var city_list = city_data["cities"]
	for i in city_list:
		infect_deck.append(i)
	shuffle(infect_deck)


#Fisher-Yates shuffle
func shuffle(deck):
	var deck_size = deck.size()
	for i in range(deck_size-1, 0, -1):
		var j = randi_range(0,i)
		var temp = deck[i]
		deck[i] = deck[j]
		deck[j] = temp

func reshuffle():
	print("Infect Deck Reshuffled!")
	shuffle(discard_pile)
	for i in discard_pile.size():
		var card = discard_pile[0]
		infect_deck.insert(0,card)
		discard_pile.erase(card)

func draw_infect_card() -> String:
	print("infect deck is at:", infect_deck.size())
	if infect_deck.is_empty():
		reshuffle()
	var card_drawn = infect_deck[0]
	infect_deck.erase(card_drawn)
	discard_pile.insert(0, card_drawn)
	var card_scene = preload(INFECT_CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	new_card.setup(card_drawn)
	new_card.name = card_drawn["name"]
	new_card.set_meta("tooltip_name", card_drawn["name"])
	new_card.set_meta("tooltip_desc", "Infects the specified city when drawn")
	add_child(new_card)
	animate_card_to_position(new_card)
	#CURRENTLY infection cards arent instantiated as card entities
	return card_drawn.get("name")

func draw_infect_card_bottom() -> String:
	if !infect_deck:
		reshuffle()
	var card_drawn = infect_deck[infect_deck.size() - 1]
	infect_deck.erase(card_drawn)
	discard_pile.insert(0, card_drawn)
	return card_drawn.get("name")
	


func animate_card_to_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", $InfectSlot.position, 0.1)
