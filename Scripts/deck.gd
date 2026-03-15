extends Node2D

const CARD_SCENE_PATH = "res://Scenes/player_card.tscn"



var player_deck = []

func _ready() -> void:
	#loads and stores the json map data
	var file_text = FileAccess.get_file_as_string("res://map/baseboard.json")
	var city_data = JSON.parse_string(file_text)
	var city_list = city_data["cities"]
	
	#adds each entry (city data) in the json file into the player deck
	for i in city_list:
		player_deck.append(i)
		#print("Added %s to player deck" % player_deck[0])
	
	#shuffle each deck at the start of the game
	shuffle(player_deck)
	
	#initial player deck draw
	#for i in 4:
		#GameManager.currentPlayer = i
		#for j in 3:
			#draw_card()
	#GameManager.currentPlayer = 0
	#PlayerHand.update_hand_positions()


#Fisher-Yates shuffle
func shuffle(deck):
	var deck_size = deck.size()
	for i in range(deck_size-1, 0, -1):
		var j = randi_range(0,i)
		var temp = deck[i]
		deck[i] = deck[j]
		deck[j] = temp



func draw_card():
	if(PlayerHand.player_hand[GameManager.currentPlayer].size() == 6):
		print("player holds the max amount of cards!")
		return
	
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
	$"../CardManager".add_child(new_card)
	new_card.setup(card_drawn)
	new_card.name = card_drawn["name"]
	PlayerHand.add_card_to_hand(new_card)
