extends Control

@onready var slides = $TutorialSlides
var board = "res://scenes/boardMain.tscn"

var current_slide = 0

func _ready():
	update_slide()

func next_slide():
	if current_slide < slides.get_child_count() - 1:
		current_slide += 1
		update_slide()

func prev_slide():
	if current_slide > 0:
		current_slide -= 1
		update_slide()

func update_slide():
	slides.current_tab = current_slide

func _on_back_button_pressed() -> void:
	prev_slide()

func _on_next_button_pressed() -> void:
	next_slide()

func _on_close_button_pressed() -> void:
	get_tree().change_scene_to_file(board)
