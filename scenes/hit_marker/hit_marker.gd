class_name HitMarker
extends Control



var index: int = -1
var color: Color = Color() : set=_set_color, get=_get_color


func _set_color(value: Color) -> void:
    modulate = value

func _get_color() -> Color:
    return modulate

