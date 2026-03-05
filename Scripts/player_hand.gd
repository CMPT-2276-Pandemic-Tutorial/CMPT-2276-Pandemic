extends Node2D

const MAX_HAND_COUNT = 6

const CARD_WIDTH = 280
const HAND_Y_POSITION = 500

var player_hands = {0:[],1:[],2:[],3:[]}
var curr_player = 1

#var player_hand = []
var center_screen_x

func _ready() -> void:
	#center_screen_x = 
	add_to_group("player_hand")
	
		
func add_card_to_hand(card):
	player_hands[curr_player].insert(0, card)
	update_hand_positions()

func update_hand_positions():
	for i in range(player_hands[curr_player].size()):
		#retrieves new card position based on current number of cards in the player hand and index of mouse
		var new_position = Vector2(calculate_card_positions(i) - 1300, HAND_Y_POSITION)
		var card = player_hands[curr_player][i]
		animate_card_to_position(card, new_position)

func calculate_card_positions(index):
	var total_width = (player_hands[curr_player].size() - 1) * CARD_WIDTH
	var x_offset = (get_viewport().size.x / 2) + index * CARD_WIDTH - total_width / 2
	return x_offset
	
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)


func remove_card_from_hand(card):
	
	if card in player_hands[curr_player]:
		player_hands[curr_player].erase(card)
		print("erased")
		print(card)
		card.position = $"../CardSlot".position
		card.get_node("Area2D/CollisionShape2D").disabled = true
		update_hand_positions()
		for i in player_hands[curr_player]:
			print(i.name)
	else:
		print("card not found")
