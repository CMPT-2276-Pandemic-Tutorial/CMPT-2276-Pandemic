extends Node2D

signal hovering
signal hovering_off

func _ready() -> void:
	#all cards need to be children of card manager
	get_parent().connect_card_signals(self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovering", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovering_off", self)
