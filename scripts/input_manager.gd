extends Node2D

var tooltip_ref
var last_hovered = null

func _ready():
	tooltip_ref = get_tree().get_root().get_node("/root/Board/Tooltip") # adjust path

func _process(delta):
	var hovered = raycast_at_cursor()
	if hovered and hovered.has_meta("tooltip_name") and hovered.has_meta("tooltip_desc"):
		var tooltip_text = hovered.get_meta("tooltip_name") + "\n" + hovered.get_meta("tooltip_desc")
		tooltip_ref.display(tooltip_text, get_viewport().get_mouse_position())
	else:
		tooltip_ref.hide_tooltip()
	if hovered != last_hovered:
		last_hovered = hovered
		if hovered:
			print("Hovering over: ", hovered.name)

#detects clicking
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_at_cursor()
			#draws card when clicking on the deck
			if card and card.name == "Deck":
				#if GameManager.actionCount <= 0:
				#	print("No actions remaining!")
				#	return
				$"../../Deck".draw_card()
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
		return result[0].collider.get_parent()
	return null
