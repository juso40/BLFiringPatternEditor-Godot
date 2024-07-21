extends Node

signal markers_changed(hit_markers: Array[HitMarker])
signal marker_create_at(pos: Vector2)

const SIZE_X = 1280
const SIZE_Y = 720

var MAGIC_MULTIPLIER: int = 20

var hit_markers: Array[HitMarker] = []
var mirror_y: bool = false
var mirror_x: bool = false


func clear_hitmarkers() -> void:
	for marker in hit_markers:
		marker.queue_free()
	hit_markers.clear()
	markers_changed.emit(hit_markers)


func append_hitmarker(hit_marker: HitMarker) -> void:
	hit_marker.index = hit_markers.size()
	hit_markers.append(hit_marker)
	markers_changed.emit(hit_markers)


func pop_hitmarker(index: int = -1) -> void:
	if hit_markers.is_empty():
		return
	var marker: HitMarker = hit_markers.pop_at(index)
	marker.queue_free()
	for i in range(marker.index, hit_markers.size()):
		hit_markers[i].index = i
	markers_changed.emit(hit_markers)


func move_marker(marker: HitMarker, index: int) -> void:
	index = min(index, hit_markers.size() - 1)
	var old_index: int = marker.index
	hit_markers.erase(marker)
	if index >= hit_markers.size():
		hit_markers.append(marker)
	else:
		hit_markers.insert(index, marker)

	for i in range(min(old_index, index), max(old_index, index) + 1):
		hit_markers[i].index = i
	markers_changed.emit(hit_markers)
