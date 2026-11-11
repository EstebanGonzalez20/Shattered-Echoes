class_name Player extends CharacterBody3D

@onready var entity_component: EntityComponent = $EntityComponent
@onready var hud: CanvasLayer = $"../Hud"

signal player_died

## Datos del personaje del jugador.
var character_data : CharacterData

## Hace todas las preparaciones y lógicas de arranque que no puedan hacerse en _ready()
func initialize() -> void:
	for component in character_data.initial_components:
		entity_component.add_component(component)
	
	var player_health : Health = entity_component.get_component("Health")
	player_health.damage_taken.connect(_on_damage_taken)
	player_health.die.connect(_on_die)

func _on_damage_taken(amount) -> void:
	var player_health : Health = entity_component.get_component("Health")
	print(player_health.current_health)
	hud.healthBar.set_health(player_health.current_health)

func _on_die() -> void:
	player_died.emit()
