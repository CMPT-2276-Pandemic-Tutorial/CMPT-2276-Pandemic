extends Node2D

signal hovering
signal hovering_off

@onready var card_label: Label = $CardName
@onready var card_bg: Sprite2D = $CardBG

var card_data : Dictionary

func _ready() -> void:
	#all cards need to be children of card manager
	#get_parent().connect_card_signals(self)
	$CardName.text = card_data.get("name", "NO NAME")
	

func setup(data: Dictionary) -> void:
	#await get_tree().process_frame
	card_data = data
	card_label.text = card_data["name"]
	match card_data["colour"]:
		"blue":card_bg.modulate = Color(0.2,0.4,1)
		"red":card_bg.modulate = Color(1, 0.2, 0.2)
		"yellow":card_bg.modulate = Color(1,1,0.2)
		"black":card_bg.modulate = Color(0.1,0.1,0.1)

func update_visuals():
	if typeof(card_data) == TYPE_DICTIONARY:
		$CardName.text = card_data.get("name", "NO NAME")

func get_colour():
	return card_data.get("colour")

func get_card_name():
	return card_data.get("name")
	
func get_num_connections():
	return card_data.get("num_of_connections")
	
func get_connections():
	return card_data.get("connections")
	
func get_station():
	return card_data.get("station")

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovering", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovering_off", self)
