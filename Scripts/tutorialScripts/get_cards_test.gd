extends Button



func _on_pressed() -> void:
	$"../../Deck".draw_card()
	var cardNodes = PlayerHand.get_cards_from_hand(0) #gets cards from player 0, first player
	var cardData = cardNodes[0].card_data #reads card data from the first card in the players hand
	print(cardNodes) #prints the node name of the card, useful for adding/removing card to/from hands
	print(cardData) #displays the full data of the card
	print(cardData.get("colour")) #reads the colour property of the first card in the first players hand
