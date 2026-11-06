extends Control

@onready var characters_name : Label = $PanelContainer/VBoxContainer/CharactersName
@onready var splashart: TextureRect = $PanelContainer/VBoxContainer/Splashart


func display_character(character_info : CharacterInfo) -> void:
	splashart.texture = character_info.characetr_splashart
	characters_name.text = character_info.character_name
