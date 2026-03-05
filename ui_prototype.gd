extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in Map.cityCoords.size():
		var add_city = $Area2D.duplicate()
		add_city.position = Map.cityCoords[i]
		add_city.name = Map.cities[i].get_city_name()
		add_child(add_city)
	$Area2D.visible = false # hide our template area at 0,0


func _on_button_pressed() -> void:
	GameManager.endTurn()
	$InfectDeck.draw_infect_card()
	$TurnLabel.text = "player " + str(GameManager.currentPlayer + 1) + "'s turn"
