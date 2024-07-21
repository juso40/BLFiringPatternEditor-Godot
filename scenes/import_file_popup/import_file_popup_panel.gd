class_name ImportFilePopupPanel
extends PopupPanel

@onready var cancel_button: Button = %CancelButton
@onready var import_button: Button = %ImportButton

@onready var code_edit: CodeEdit = %CodeEdit
@onready var import_messages: RichTextLabel = %ImportMessages
@onready var import_pattern_scale: SpinBox = %ImportPatternScale


func _ready() -> void:
	cancel_button.pressed.connect(_on_cancel_button_pressed)
	import_button.pressed.connect(_on_import_button_pressed)


func _on_cancel_button_pressed() -> void:
	code_edit.text = ""
	hide()


func _on_import_button_pressed() -> void:
	var code: String = code_edit.text
	var pattern_scale: float = import_pattern_scale.value

	var regex: RegEx = RegEx.new()
	regex.compile(
		r"StartPoint\s*=\s*\(\s*Pitch\s*=\s*(?<pitch>-?\d+)\s*,\s*Yaw\s*=\s*(?<yaw>-?\d+)"
	)

	var matches: Array = regex.search_all(code)
	if matches.is_empty():
		import_messages.bbcode_text = "[color=red]No matches found[/color]"
		return

	HitMarkerManager.clear_hitmarkers()
	var mirror_backup_x: bool = HitMarkerManager.mirror_x
	var mirror_backup_y: bool = HitMarkerManager.mirror_y
	HitMarkerManager.mirror_x = false
	HitMarkerManager.mirror_y = false

	var warn_screen_bounds: bool = false
	for m in matches:
		var pitch: int = m.get_string("pitch").to_int()
		var yaw: int = m.get_string("yaw").to_int()

		var position: Vector2 = Vector2(
			HitMarkerManager.SIZE_X / 2 + pitch / pattern_scale,
			HitMarkerManager.SIZE_Y / 2 - yaw / pattern_scale
		)
		if (
			position.x < 0
			or position.x > HitMarkerManager.SIZE_X
			or position.y < 0
			or position.y > HitMarkerManager.SIZE_Y
		):
			warn_screen_bounds = true

		HitMarkerManager.marker_create_at.emit(position)

	if warn_screen_bounds:
		import_messages.bbcode_text = "[color=red]Some markers are outside the screen bounds.[/color]\nTry adjusting the pattern scale."
	else:
		import_messages.bbcode_text = "[color=green]Import successful[/color]"

	HitMarkerManager.mirror_x = mirror_backup_x
	HitMarkerManager.mirror_y = mirror_backup_y
