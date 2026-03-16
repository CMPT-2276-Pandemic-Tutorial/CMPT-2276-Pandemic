extends Node2D

const CARD_SCENE_PATH = "res://scenes/deckScenes/player_card.tscn"
const MAP_JSON_PATH = "res://boardInformation.json"

var card_manager_ref
var player_deck = []

func _ready() -> void:
	card_manager_ref = $"../CardManager"
	#loads and stores the json map data
	var file_text = FileAccess.get_file_as_string(MAP_JSON_PATH)
	var city_data = JSON.parse_string(file_text)
	var city_list = city_data["cities"]
	
	#adds each entry (city data) in the json file into the player deck
	for i in city_list:
		player_deck.append(i)
	set_meta("tooltip_name", "Player Deck")
	set_meta("tooltip_desc", "Draw a city card from the player deck by clicking on it.")
	#shuffle each deck at the start of the game
	shuffle(player_deck)


#Fisher-Yates shuffle
func shuffle(deck):
	var deck_size = deck.size()
	for i in range(deck_size-1, 0, -1):
		var j = randi_range(0,i)
		var temp = deck[i]
		deck[i] = deck[j]
		deck[j] = temp



func draw_card():
	if(PlayerHand.player_hand[GameManager.currentPlayer].size() == 7):
		print("player holds the max amount of cards!")
		return
	GameManager.actionCount -= 1
	var card_drawn = player_deck[0]
	print("card drawn %s" % card_drawn["name"])
	print("card drawn data", card_drawn)
	player_deck.erase(card_drawn)
	
	#disables the deck sprite when the deck runs out of cards
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		
	#ref the card manager to add the new card to the player hand as a child
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	card_manager_ref.add_child(new_card)
	new_card.setup(card_drawn)
	new_card.name = card_drawn["name"]
	new_card.z_index = 10
	new_card.set_meta("tooltip_name", card_drawn["name"])
	new_card.set_meta("tooltip_desc", "City card used for travel and curing diseases.")
	PlayerHand.add_card_to_hand(new_card)
