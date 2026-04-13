extends CanvasLayer

@onready var flash: ColorRect = $Flash
@onready var alarm_text: Label = $AlarmText
@onready var alarm_sound = $AlarmSound

func _ready() -> void:
	add_to_group("Alarm")

func play_epidemic_flash():
	flash.color.a = 0.0
	var tween = create_tween()
	for i in 3:
		# Flash in
		tween.tween_property(flash, "color:a", 0.4, 0.2)
		# Flash out
		tween.tween_property(flash, "color:a", 0.0, 0.15)
	alarm_sound.play()
	await get_tree().create_timer(3.5).timeout  # play for 0.5 sec
	alarm_sound.stop()



func show_epidemic_alert(city_name: String):
	alarm_text.text = "⚠ EPIDEMIC in " + city_name + "! ⚠"	
	alarm_text.modulate.a = 0
	var tween = create_tween()
	# Fade + slide in
	tween.parallel().tween_property(alarm_text, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(alarm_text, "position:y", 150, 0.3)
	# Wait
	tween.tween_interval(2.5)
	# Fade out
	tween.tween_property(alarm_text, "modulate:a", 0.0, 0.5)
