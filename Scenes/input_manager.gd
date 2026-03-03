extends Node2D

#var card_dragged

#func _process(delta: float) -> void:
	#if card_dragged:
		#var mouse_pos = get_global_mouse_position()
		#card_dragged.position = mouse_pos

#detects clicking
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_at_cursor()
			#draws card when clicking on the deck
			if card:
				if card.name == "Deck":
					$"../Deck".draw_card()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		if event.pressed:
			var player_hand_ref = get_tree().get_first_node_in_group("player_hand")
			var card = raycast_at_cursor()
			player_hand_ref.remove_card_from_hand(card)
			#removes card upon double clicking

func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	#check if card is valid
	if result.size() > 0:
		print(result[0].collider.get_parent())
		return result[0].collider.get_parent()
	return null
