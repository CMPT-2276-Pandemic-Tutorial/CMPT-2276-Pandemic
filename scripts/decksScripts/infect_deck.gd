extends Node2D

const INFECT_CARD_SCENE_PATH = "res://scenes/deckScenes/infect_card.tscn"

var infect_deck = []
var discard_pile = []

func _ready() -> void:
	GameManager.infectionDeck = self
	for i in Map.cities.size():
		var cityName = Map.cities[i].get_city_name()
		infect_deck.insert(0, cityName)
		#print("Added %s to infection deck" % infect_deck[0])
		
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
	print("Deck Reshuffled")
	shuffle(discard_pile)
	for i in discard_pile.size():
		var card = discard_pile[0]
		infect_deck.insert(0,card)
		discard_pile.erase(card)

func draw_infect_card() -> String:
	print(infect_deck.size())
	if !infect_deck:
		reshuffle()
	var card_drawn = infect_deck[0]
	infect_deck.erase(card_drawn)
	discard_pile.insert(0, card_drawn)
	var card_scene = preload(INFECT_CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	new_card.name = card_drawn
	animate_card_to_position(new_card)
	#CURRENTLY infection cards arent instantiated as card entities
	return card_drawn

func animate_card_to_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", $InfectSlot.position, 0.1)
