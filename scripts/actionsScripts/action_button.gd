extends Button

@export var action_handler:Node
@export var colour:String
@export var action:String

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("Sending Action")
	if PlayerHand.can_cure(colour):
		action_handler.run_action(action,colour)
