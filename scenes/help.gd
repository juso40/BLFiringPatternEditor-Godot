extends PanelContainer


@onready var help_message_panel: PanelContainer = %HelpMessagePanelContainer

func _ready() -> void:
    mouse_entered.connect(_on_mouse_entered)
    help_message_panel.mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
    hide()
    help_message_panel.show()


func _on_mouse_exited() -> void:
    help_message_panel.hide()
    show()