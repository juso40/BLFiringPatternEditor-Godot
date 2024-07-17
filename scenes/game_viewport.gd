class_name GameViewport
extends SubViewport

const HitMarkerScene: PackedScene = (
	preload("res://scenes/hit_marker/hit_marker.tscn") as PackedScene
)

enum GridSize { NONE = 0, SMALL = 16, MEDIUM = 32, LARGE = 64 }

var current_grid: GridSize = GridSize.NONE

var mirror_y: bool = false
var mirror_x: bool = false

@onready var grid_overlay: ColorRect = %GridOverlay


func _ready() -> void:
	%MirrorLineY.visible = mirror_y
	%MirrorLineX.visible = mirror_x
	toggle_grids()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			marker_at(event.position)

		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			HitMarkerManager.pop_hitmarker()

	if event is InputEventKey:
		var keyevent: InputEventKey = event as InputEventKey
		if keyevent.keycode == KEY_G and keyevent.is_pressed():
			toggle_grids()

		if event.keycode == KEY_Y and event.is_pressed():
			toggle_mirror_y()
		elif event.keycode == KEY_X and event.is_pressed():
			toggle_mirror_x()


func toggle_grids() -> void:
	match current_grid:
		GridSize.NONE:
			current_grid = GridSize.SMALL
		GridSize.SMALL:
			current_grid = GridSize.MEDIUM
		GridSize.MEDIUM:
			current_grid = GridSize.LARGE
		GridSize.LARGE:
			current_grid = GridSize.NONE

	(grid_overlay.material as ShaderMaterial).set_shader_parameter("columns", int(current_grid))
	(grid_overlay.material as ShaderMaterial).set_shader_parameter("rows", int(current_grid / 2))
	if current_grid == GridSize.NONE:
		grid_overlay.hide()
	else:
		grid_overlay.show()


func toggle_mirror_y() -> void:
	mirror_y = not mirror_y
	%MirrorLineY.visible = mirror_y


func toggle_mirror_x() -> void:
	mirror_x = not mirror_x
	%MirrorLineX.visible = mirror_x


func marker_at(pos: Vector2) -> void:
	var hit_marker: Control = HitMarkerScene.instantiate() as Control
	hit_marker.position = pos
	%HitMarkers.add_child(hit_marker)
	HitMarkerManager.append_hitmarker(hit_marker)

	if not mirror_x and not mirror_y:
		return

	var hit_marker_mirrored = HitMarkerScene.instantiate() as Control
	if mirror_y and mirror_x:
		hit_marker_mirrored.position = Vector2(1280 - pos.x, 720 - pos.y)
	elif mirror_y:
		hit_marker_mirrored.position = Vector2(pos.x, 720 - pos.y)
	elif mirror_x:
		hit_marker_mirrored.position = Vector2(1280 - pos.x, pos.y)
	%HitMarkers.add_child(hit_marker_mirrored)
	HitMarkerManager.append_hitmarker(hit_marker)
