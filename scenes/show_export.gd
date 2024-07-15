extends Button

const EXPORT_Y_SIZE: int = 128

@export_range(0.0, 1.0, 0.02, "suffix:s") var tween_show_duration: float = 0.5
@export_range(0.0, 1.0, 0.02, "suffix:s") var tween_hide_duration: float = 0.5

var shows_export: bool = false
var tween: Tween = null

@onready var export: Control = %Export


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if shows_export:
		hide_export()
	else:
		show_export()


func show_export() -> void:
	shows_export = true

	if tween:
		tween.kill()

	tween = create_tween()
	(
		tween
		. tween_property(export, "custom_minimum_size:y", EXPORT_Y_SIZE, tween_show_duration)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BOUNCE)
	)


func hide_export() -> void:
	shows_export = false
	
	if tween:
		tween.kill()

	tween = create_tween()
	(
		tween
		. tween_property(export, "custom_minimum_size:y", 0, tween_show_duration)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BOUNCE)
	)
