extends Node2D



func connect_card_signals(card):
	card.connect("hovering", on_hovering_over_card)
	card.connect("hovering_off", on_hovering_off_card)

func on_hovering_over_card(card):
	#print("hovering")
	pass

func on_hovering_off_card(card):
	#print("hovering off")
	pass
