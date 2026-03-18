extends Node2D


func connect_card_signals(card):
	card.connect("hovering", on_hovering_over_card)
	card.connect("hovering_off", on_hovering_off_card)

func show_player_hand(player_index):
	# remove ALL cards currently in the scene
	for player in PlayerHand.player_hand.keys():
		for card in PlayerHand.player_hand[player]:
			if card.get_parent():
				card.get_parent().remove_child(card)
	# now add the correct player's cards
	var hand = PlayerHand.player_hand[player_index]
	for card in hand:
		add_child(card)
	PlayerHand.update_hand_positions(player_index)


func on_hovering_over_card(card):
	#print("hovering")
	pass

func on_hovering_off_card(card):
	#print("hovering off")
	pass
