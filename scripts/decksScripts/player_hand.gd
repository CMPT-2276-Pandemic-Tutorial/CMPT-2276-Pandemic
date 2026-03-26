extends Node2D

const MAX_HAND_COUNT = 7
const CARD_WIDTH = 150
const HAND_Y_POSITION = 950

var player_hand = {0:[],1:[],2:[],3:[]}
var trade_card_mapping = {}
var center_screen_x

var viewed_player = null
var selected_card = null
var selected_from_player = null
var highlighted_card = null

var trade_container: Control

func _ready() -> void:
	#center_screen_x = 
	add_to_group("player_hand")
	#await get_tree().process_frame
	trade_container = get_tree().get_first_node_in_group("trade_container")



func add_card_to_hand(card, player_index = GameManager.currentPlayer):
	#ensures duplicate cards arent added to the player hand
	if card.has_meta("is_duplicate"):
		print("ERROR: Attempted to add duplicate card to hand!")
		return
	# Ensure card Node is parented under the hand manager
	if card.get_parent() != self:
		if card.get_parent():
			card.get_parent().remove_child(card)
		add_child(card)
	card.scale = Vector2(0.35,0.35)
	player_hand[player_index].insert(0, card)
	card.get_node("Area2D/CollisionShape2D").disabled = false
	update_hand_positions(player_index)


func update_hand_positions(player_index = GameManager.currentPlayer):
	if player_index != GameManager.currentPlayer:
		return
	for i in range(player_hand[player_index].size()):
		#retrieves new card position based on current number of cards in the player hand and index of mouse
		var card = player_hand[player_index][i]
		var new_position = Vector2(calculate_card_positions(i, player_index) +100, HAND_Y_POSITION)
		animate_card_to_position(card, new_position)


func calculate_card_positions(index, player_index):
	var total_width = (player_hand[player_index].size() - 1) * CARD_WIDTH
	var x_offset = (get_viewport().size.x / 2) + index * CARD_WIDTH - total_width / 2
	return x_offset


func animate_card_to_position(card, new_position):
	if card.has_meta("tween"):
		var old_tween = card.get_meta("tween")
		if old_tween:
			old_tween.kill()
	var tween = get_tree().create_tween()
	card.set_meta("tween", tween)
	tween.tween_property(card, "position", new_position, 0.1)
	await get_tree().process_frame


func show_trade_hand(player_index):
	trade_container = get_tree().get_first_node_in_group("trade_container")
	#clear previous cards
	for child in trade_container.get_children():
		child.queue_free()
	trade_card_mapping.clear()
	#clear highlighted card
	clear_card_highlight()
	#shows the hand of the selected player inside the trade panel
	viewed_player = player_index
	var hand = player_hand[player_index]
	for i in range(hand.size()):
		var original_card = hand[i]
		var card = original_card.duplicate()
		card.card_data = original_card.card_data.duplicate()
		card.set_meta("is_duplicate", true)
		card.update_visuals()
		trade_container.add_child(card)
		card.scale = Vector2(0.4, 0.4)
		card.position = Vector2((200 * i) + 100, 300)
		trade_card_mapping[card] = original_card

func trade_card(card, playerFrom, playerTo):
	if GameManager.actionCount <= 0:
		print("Can't trade cards, no actions remaining!")
		return
	if player_hand[playerTo].size() >= MAX_HAND_COUNT:
		print("Can't trade cards, max cards reached for target player!")
		return
	#ensures no duplicate cards are added to the hands
	if card in trade_card_mapping:
		card = trade_card_mapping[card]
	remove_traded_card(card, playerFrom)
	add_card_to_hand(card, playerTo)
	GameManager.actionCount -= 1

func remove_traded_card(card, player_index = GameManager.currentPlayer):
	if card in player_hand[player_index]:
		player_hand[player_index].erase(card)
		card.position = Vector2(5010,700)
		print("erased ", card)
		update_hand_positions(player_index)
	else:
		print("card not found")

#called from action_handler._on_trade_partner_selected()
func _on_trade_requested(player_a, player_b):
	viewed_player = player_b
	show_trade_hand(player_b)


func select_card_via_raycast(card):
	if not card:
		return
	#check if the card is a duplicate
	if card in trade_card_mapping:
		selected_card = trade_card_mapping[card]
		selected_from_player = viewed_player
		highlight_selected_card(card)
		return
	for player_idx in player_hand.keys():
		if card in player_hand[player_idx]:
			selected_card = card
			selected_from_player = player_idx
			print("Selected card from player ", player_idx, " card: ",card.card_data.get("name"))
			highlight_selected_card(card)
			break


func _on_card_clicked(from_player, card, viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		selected_card = card
		selected_from_player = from_player
		print("Selected card from player ", from_player)
		highlight_selected_card(card)


func highlight_selected_card(card):
	if highlighted_card and highlighted_card != card:
		highlighted_card.modulate = Color(1,1,1)
	highlighted_card = card
	card.modulate = Color(0.431, 0.896, 0.441, 1.0)


func clear_card_highlight():
	if highlighted_card:
		highlighted_card.modulate = Color(1,1,1)
	highlighted_card = null
	selected_card = null
	selected_from_player = null


func confirm_trade():
	if selected_card == null:
		print("No card selected")
		return
	var from_player = selected_from_player
	var to_player
	if from_player == GameManager.currentPlayer:
		to_player = viewed_player
	else:
		to_player = GameManager.currentPlayer
	print("Trading card from player ", from_player, " to player ", to_player)
	if to_player == null or from_player == null:
		print("No trading partner selected!")
		return
	trade_card(selected_card, from_player, to_player)
	clear_card_highlight()
	update_hand_positions(from_player)
	update_hand_positions(to_player)
	show_trade_hand(viewed_player)

#takes in the string colour name and determines if a cure can be made
func can_cure(cure_colour):
	var player = GameManager.currentPlayer
	var current_hand = player_hand[player]
	var cure_cards = []
	for card in range(current_hand.size()):
		#load the card data
		var data = current_hand[card].card_data
		if typeof(data) == TYPE_DICTIONARY and data.get("colour") == cure_colour:
			cure_cards.append(current_hand[card])
	#if the player is the scientist then they only need 4 cards to cure
	if GameManager.playerRole[player] == "Scientist" and cure_cards.size() >= 4:
		print("Cured %s disease!" % cure_colour)
		for card in range(4):
			remove_card_from_hand(cure_cards[card])
		return true
	#if the player has five cards of the same color they can cure
	if cure_cards.size() >= 5:
		print("Cured %s disease!" % cure_colour)
		for card in range(5):
			remove_card_from_hand(cure_cards[card])
		return true
	#returns that the player cannot cure
	else:
		print("Cannot cure ", cure_colour)
		return false



#returns an array nodes of every card in a players hand
#data from cards can be retrieved via get_cards_from_hand(player_index)[cardNum].card_data.get("attribute")
func get_cards_from_hand(player_index):
	return player_hand[player_index]



#takes in the card node
func remove_card_from_hand(card, player_index = GameManager.currentPlayer):
	if card in player_hand[player_index]:
		player_hand[player_index].erase(card)
		print("erased ", card)
		# reset card transform
		card.position = Vector2(1310,700)
		card.get_node("Area2D/CollisionShape2D").disabled = true
		await get_tree().process_frame
		update_hand_positions()
	else:
		print("card not found")
