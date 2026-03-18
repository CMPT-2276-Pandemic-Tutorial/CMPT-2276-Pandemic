extends Button

@export var action_handler:Node
@export var colour:String
@export var action:String

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("Sending Action")
	action_handler.run_action(action,colour)
