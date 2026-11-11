extends Node3D

@onready var player: Player = $Player
@onready var hud: CanvasLayer = $Hud

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.character_data = GameSession.selected_character
	player.initialize()
	player.player_died.connect(_on_player_dead)
	hud.initialize(player.entity_component.get_component("Health").max_health)
	

func _on_player_dead() -> void:
	get_tree().change_scene_to_file("res://Game/scenes/ui/menus/dead_screen.tscn")
