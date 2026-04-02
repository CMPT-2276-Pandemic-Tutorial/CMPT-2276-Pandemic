extends Node2D

@export var thickness: float = 4
@export var radius: float = 25
@export var color: Color = Color(1, 1, 0, 1) # bright yellow
var pulse_speed = 0.5
var base_scale = 1

func _ready():
	start_animation()
	
func _draw():
	draw_arc(Vector2.ZERO, radius, 0, TAU, 64, color, thickness)

func start_animation():
	var tween = create_tween()
	tween.set_loops()
	
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), pulse_speed)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), pulse_speed)
