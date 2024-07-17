extends VBoxContainer


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is HitMarkerInfo


func _drop_data(at_position: Vector2, data: Variant) -> void:
	# find closes existing control in the children
	var closest: int = 0
	var closest_dist: float = INF
	var child_index: int = 0
	for child: Control in get_children():
		var child_dist: float = abs(
			(child.position.y + child.get_rect().size.y / 2) - at_position.y
		)
		if child_dist < closest_dist:
			closest = child_index
			closest_dist = child_dist
		child_index += 1

	# insert the dropped data above or below the closest control
	if at_position.y <= get_child(closest).position.y + get_child(closest).get_rect().size.y / 2:
		HitMarkerManager.move_marker(data.hit_marker, closest)
	else:
		HitMarkerManager.move_marker(data.hit_marker, closest + 1)
