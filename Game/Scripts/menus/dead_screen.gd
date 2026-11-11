extends Control

@onready var button: Button = $PanelContainer/VBoxContainer/Button

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/scenes/ui/menus/main_menu.tscn")
