extends SubViewport

const HitMarker: PackedScene = preload("res://scenes/hit_marker.tscn") as PackedScene

enum GridSize { NONE = 0, SMALL = 32, MEDIUM = 64, LARGE = 128, HUGE = 256 }

var current_grid: GridSize = GridSize.NONE
var hit_markers: Array[Control] = []

@onready var export: Export = %Export
@onready var grid_overlay: ColorRect = %GridOverlay


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var hit_marker: Control = HitMarker.instantiate() as Control
			hit_marker.position = event.position
			%HitMarkers.add_child(hit_marker)
			hit_markers.append(hit_marker)
			export.update_export_command(hit_markers)

		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if hit_markers.is_empty():
				return
			var remove_me: Control = hit_markers.pop_back()
			remove_me.queue_free()
			export.update_export_command(hit_markers)

	if event is InputEventKey:
		var keyevent: InputEventKey = event as InputEventKey
		if keyevent.keycode == KEY_G and keyevent.is_pressed():
			toggle_grids()


func toggle_grids() -> void:
	match current_grid:
		GridSize.NONE:
			current_grid = GridSize.SMALL
		GridSize.SMALL:
			current_grid = GridSize.MEDIUM
		GridSize.MEDIUM:
			current_grid = GridSize.LARGE
		GridSize.LARGE:
			current_grid = GridSize.HUGE
		GridSize.HUGE:
			current_grid = GridSize.NONE

	(grid_overlay.material as ShaderMaterial).set_shader_parameter("grid_size", int(current_grid))
