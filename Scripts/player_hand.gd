extends Node2D

const MAX_HAND_COUNT = 8

const CARD_WIDTH = 150
const HAND_Y_POSITION = 300

var player_hand = {0:[],1:[],2:[],3:[]}
var center_screen_x

func _ready() -> void:
	#center_screen_x = 
	add_to_group("player_hand")
	


func add_card_to_hand(card):
	var player = GameManager.currentPlayer
	# Ensure card Node is parented under the hand manager
	if card.get_parent() != self:
		if card.get_parent():
			card.get_parent().remove_child(card)
		add_child(card)
	card.position = Vector2(0,0)
	card.scale = Vector2(0.35,0.35)
	player_hand[player].insert(0, card)
	update_hand_positions(player)


func update_hand_positions(player_index):
	for i in range(player_hand[player_index].size()):
		#retrieves new card position based on current number of cards in the player hand and index of mouse
		var card = player_hand[player_index][i]
		var new_position = Vector2(calculate_card_positions(i, player_index) -800, HAND_Y_POSITION)
		animate_card_to_position(card, new_position)


func calculate_card_positions(index, player_index):
	var total_width = (player_hand[player_index].size() - 1) * CARD_WIDTH
	var x_offset = (get_viewport().size.x / 2) + index * CARD_WIDTH - total_width / 2
	return x_offset


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)


func remove_card_from_hand(card):
	var curr_player = GameManager.currentPlayer
	if card in player_hand[curr_player]:
		player_hand[curr_player].erase(card)
		print("erased")
		print(card)
		# reset card transform
		card.position = Vector2(340, 60)
		card.get_node("Area2D/CollisionShape2D").disabled = true
		update_hand_positions(curr_player)
	else:
		print("card not found")
