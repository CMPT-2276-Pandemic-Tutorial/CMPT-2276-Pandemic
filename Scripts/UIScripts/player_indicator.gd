extends Node

@onready var player_rects = [$Player1/BlueRect, $Player2/BrownRect, $Player3/GrayRect, $Player4/RedRect]

@onready var player_card_lists = [$Player1/BlueCards, $Player2/BrownCards, $Player3/GrayCards, $Player4/RedCards]

func change_player():
	for rect in player_rects:
		rect.global_position = Vector2(1850, rect.global_position.y)
		
	player_rects[GameManager.currentPlayer].global_position = Vector2(1800, player_rects[GameManager.currentPlayer].global_position.y)

var player_card_positions = [Vector2(1650, 370), Vector2(1650, 470), Vector2(1650, 570), Vector2(1650, 670)]

# makes a copy of each players hand and clears and readds the cards every time its called
# does each players hands to account for card trading
func side_card_display():
	for i in range(4):
		for child in player_card_lists[i].get_children(): 
			child.free()
			
		var offset = 0
		for card in PlayerHand.get_cards_from_hand(i):
			var newCard = Sprite2D.new()
			var cardBG = card.get_node("CardBG") # creates and gets the image for the card
			
			newCard.texture = cardBG.texture
			newCard.modulate = cardBG.modulate # retextures and sizes
			newCard.scale = Vector2(0.1, 0.1)
			
			newCard.position = player_card_positions[i] + Vector2(offset, 0) # the cards position
			offset += 40
			
			player_card_lists[i].add_child(newCard) # add cards to hand
