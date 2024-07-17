class_name HitMarkerInfo
extends Control

var hit_marker: HitMarker = null

@onready var grab_button: Button = %GrabButton
@onready var color_picker_button: ColorPickerButton = %ColorPickerButton
@onready var x_val: SpinBox = %XSpinBox
@onready var y_val: SpinBox = %YSpinBox
@onready var remove_button: Button = %RemoveButton


func _ready() -> void:
	color_picker_button.color_changed.connect(_on_color_changed)
	x_val.value_changed.connect(_on_x_changed)
	y_val.value_changed.connect(_on_y_changed)
	remove_button.pressed.connect(_on_removed_pressed)


func setup(marker: HitMarker) -> void:
	if not is_node_ready():
		await ready
	hit_marker = marker
	grab_button.text = str(hit_marker.index)
	color_picker_button.color = hit_marker.color
	x_val.value = hit_marker.position.x - (HitMarkerManager.SIZE_X / 2)
	y_val.value = (HitMarkerManager.SIZE_Y / 2) - hit_marker.position.y


func _on_color_changed(color: Color) -> void:
	hit_marker.color = color


func _on_x_changed(value: float) -> void:
	hit_marker.position.x = value + (HitMarkerManager.SIZE_X / 2)


func _on_y_changed(value: float) -> void:
	hit_marker.position.y = (HitMarkerManager.SIZE_Y / 2) - value


func _on_removed_pressed() -> void:
	HitMarkerManager.pop_hitmarker(hit_marker.index)


func _get_drag_data(at_position: Vector2) -> Variant:
	if grab_button.get_rect().has_point(at_position):
		var preview: HitMarkerInfo = self.duplicate()
		preview.top_level = true
		preview.modulate.a = 0.8
		set_drag_preview(preview)
		return self

	return null
