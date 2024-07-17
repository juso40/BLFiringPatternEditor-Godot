class_name Export
extends Control

const CENTER_X: int = 1280 / 2
const CENTER_Y: int = 720 / 2

const MAGIC_MULTIPLIER: int = 20

const EXPORT_TEMPLATE: String = """(StartPoint=(Pitch=%d,Yaw=%d,Roll=0),EndPoint=(Pitch=0,Yaw=0,Roll=0),\
bUseStartPointOnly=True,CustomWaveMotion=(bUseCustomWaveMotion=False,WaveFreq=(X=0.000000,Y=0.000000,Z=0.000000),\
WaveAmp=(X=0.000000,Y=0.000000,Z=0.000000),WavePhase=(X=0.000000,Y=0.000000,Z=0.000000))),"""

@onready var text_edit: TextEdit = $TextEdit


func _ready() -> void:
	HitMarkerManager.markers_changed.connect(update_export_command)


func update_export_command(markers: Array[HitMarker]) -> void:
	if markers.is_empty():
		text_edit.text = "set FiringModeDefinition FiringPatternLines ()"
		return

	var export_command: String = ""
	for marker in markers:
		export_command += (
			EXPORT_TEMPLATE
			% [
				(marker.position.x - CENTER_X) * HitMarkerManager.MAGIC_MULTIPLIER,
				(CENTER_Y - marker.position.y) * HitMarkerManager.MAGIC_MULTIPLIER
			]
		)

	export_command = "set FiringModeDefinition FiringPatternLines (" + export_command.left(-1) + ")"
	text_edit.text = export_command
