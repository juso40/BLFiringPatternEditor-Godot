class_name SettingsPanel
extends Panel

const HitMarkerInfoScn: PackedScene = preload("hit_marker_info/hit_marker_info.tscn")

@onready var hit_marker_info_container: VBoxContainer = %HitMarkerInfoContainer
@onready var pattern_scale_spin_box: SpinBox = %PatternScaleSpinBox
@onready var import_button: Button = %ImportButton
@onready var import_file_popup: ImportFilePopupPanel = %ImportFilePopupPanel


func _ready() -> void:
	HitMarkerManager.markers_changed.connect(update_hit_marker_info)
	pattern_scale_spin_box.value_changed.connect(_on_pattern_scale_changed)
	import_button.pressed.connect(import_file_popup.show)


func update_hit_marker_info(markers: Array[HitMarker]) -> void:
	for child in hit_marker_info_container.get_children():
		child.queue_free()
	for marker in markers:
		var hit_marker_info: HitMarkerInfo = HitMarkerInfoScn.instantiate()
		hit_marker_info.setup(marker)
		hit_marker_info_container.add_child(hit_marker_info)


func _on_pattern_scale_changed(value: int) -> void:
	HitMarkerManager.MAGIC_MULTIPLIER = value
	HitMarkerManager.markers_changed.emit(HitMarkerManager.hit_markers)

