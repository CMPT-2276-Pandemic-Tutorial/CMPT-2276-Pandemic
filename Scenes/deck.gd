extends Node2D

const CARD_SCENE_PATH = "res://Scenes/player_card.tscn"

var player_deck = ["player-yellow", "player-blue", "player-event", "player-epidemic", "player-black", "player-red"]

func _ready() -> void:
	#var card_scene = preload(CARD_SCENE_PATH)
	#shuffle deck initially
	shuffle(player_deck)
	
	#initial deck draw
	for i in 3:
		var card_drawn = player_deck[0]
		player_deck.erase(card_drawn)
		#card_scene.instantiate()
		#ref the card manager to add the new card to the player hand as a child
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = card_drawn
		$"../PlayerHand".add_card_to_hand(new_card)
		
#Fisher-Yates shuffle
func shuffle(deck):
	var deck_size = deck.size()
	for i in range(deck_size-1, 0, -1):
		var j = randi_range(0,i)
		var temp = deck[i]
		deck[i] = deck[j]
		deck[j] = temp

func draw_card():
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
=======
>>>>>>> Stashed changes
	if($"../PlayerHand".player_hands[GameManager.currentPlayer].size() == 6):
		print("player holds the max amount of cards!")
		print(infect_deck[0])
		return
>>>>>>> Stashed changes
	print("card drawn")
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	#ref the card manager to add the new card to the player hand as a child
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../CardManager".add_child(new_card)
	new_card.name = card_drawn
	$"../PlayerHand".add_card_to_hand(new_card)
