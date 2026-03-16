extends Node2D

signal hovering
signal hovering_off

@onready var card_label: Label = $CardName
@onready var card_bg: Sprite2D = $CardBG

var card_data

func _ready() -> void:
	#all cards need to be children of card manager
	#get_parent().connect_card_signals(self)
	$CardName.text = "TEST"

func setup(data: Dictionary) -> void:
	await get_tree().process_frame
	card_data = data
	card_label.text = card_data["name"]
	match card_data["colour"]:
		"blue":card_bg.modulate = Color(0.2,0.4,1)
		"red":card_bg.modulate = Color(1, 0.2, 0.2)
		"yellow":card_bg.modulate = Color(1,1,0.2)
		"black":card_bg.modulate = Color(0.1,0.1,0.1)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovering", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovering_off", self)
