class_name GameViewport
extends SubViewport

const HitMarkerScene: PackedScene = (
	preload("res://scenes/hit_marker/hit_marker.tscn") as PackedScene
)

enum GridSize { NONE = 0, SMALL = 16, MEDIUM = 32, LARGE = 64 }

var current_grid: GridSize = GridSize.NONE

@onready var grid_overlay: ColorRect = %GridOverlay


func _ready() -> void:
	%MirrorLineY.visible = false
	%MirrorLineX.visible = false
	toggle_grids()
	HitMarkerManager.marker_create_at.connect(marker_at)


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
	HitMarkerManager.mirror_y = not HitMarkerManager.mirror_y
	%MirrorLineY.visible = HitMarkerManager.mirror_y


func toggle_mirror_x() -> void:
	HitMarkerManager.mirror_x = not HitMarkerManager.mirror_x
	%MirrorLineX.visible = HitMarkerManager.mirror_x


func marker_at(pos: Vector2) -> void:
	var hit_marker: Control = HitMarkerScene.instantiate() as Control
	hit_marker.position = pos
	%HitMarkers.add_child(hit_marker)
	HitMarkerManager.append_hitmarker(hit_marker)

	if not HitMarkerManager.mirror_x and not HitMarkerManager.mirror_y:
		return

	var hit_marker_mirrored = HitMarkerScene.instantiate() as Control
	if HitMarkerManager.mirror_y and HitMarkerManager.mirror_x:
		var hit_marker_mirrored2 = HitMarkerScene.instantiate() as Control
		var hit_marker_mirrored3 = HitMarkerScene.instantiate() as Control
		hit_marker_mirrored2.position = Vector2(1280 - pos.x, 720 - pos.y)
		hit_marker_mirrored3.position = Vector2(pos.x, 720 - pos.y)
		hit_marker_mirrored.position = Vector2(1280 - pos.x, pos.y)
		%HitMarkers.add_child(hit_marker_mirrored2)
		HitMarkerManager.append_hitmarker(hit_marker_mirrored2)
		%HitMarkers.add_child(hit_marker_mirrored3)
		HitMarkerManager.append_hitmarker(hit_marker_mirrored3)
		
	elif HitMarkerManager.mirror_y:
		hit_marker_mirrored.position = Vector2(pos.x, 720 - pos.y)
	elif HitMarkerManager.mirror_x:
		hit_marker_mirrored.position = Vector2(1280 - pos.x, pos.y)
	%HitMarkers.add_child(hit_marker_mirrored)
	HitMarkerManager.append_hitmarker(hit_marker_mirrored)
