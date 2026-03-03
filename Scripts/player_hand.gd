extends Node2D

const MAX_HAND_COUNT = 8

const CARD_WIDTH = 200
const HAND_Y_POSITION = 890

var player_hand = []
var center_screen_x

func _ready() -> void:
	#center_screen_x = 
	add_to_group("player_hand")
	
		
func add_card_to_hand(card):
	player_hand.insert(0, card)
	update_hand_positions()

func update_hand_positions():
	for i in range(player_hand.size()):
		#retrieves new card position based on current number of cards in the player hand and index of mouse
		var new_position = Vector2(calculate_card_positions(i), HAND_Y_POSITION)
		var card = player_hand[i]
		animate_card_to_position(card, new_position)

func calculate_card_positions(index):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = (get_viewport().size.x / 2) + index * CARD_WIDTH - total_width / 2
	return x_offset
	
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)


func remove_card_from_hand(card):
	
	if card in player_hand:
		player_hand.erase(card)
		print("erased")
		print(card)
		card.position = $"../CardSlot".position
		card.get_node("Area2D/CollisionShape2D").disabled = true
		update_hand_positions()
		for i in player_hand:
			print(i.name)
	else:
		print("card not found")
