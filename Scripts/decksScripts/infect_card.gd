extends Node2D

@onready var card_label: Label = $CardName
@onready var card_bg: Sprite2D = $Sprite2D

var card_data : Dictionary

func _ready() -> void:
	$CardName.text = card_data.get("name", "NO NAME")


func setup(data: Dictionary) -> void:
	card_data = data
	$CardName.text = card_data["name"]
	match card_data["colour"]:
		"blue":$Sprite2D.modulate = Color(0.2,0.4,1)
		"red":$Sprite2D.modulate = Color(1, 0.2, 0.2)
		"yellow":$Sprite2D.modulate = Color(1,1,0.2)
		"black":$Sprite2D.modulate = Color(0.1,0.1,0.1)

func update_visuals():
	if typeof(card_data) == TYPE_DICTIONARY:
		$CardName.text = card_data.get("name", "NO NAME")
