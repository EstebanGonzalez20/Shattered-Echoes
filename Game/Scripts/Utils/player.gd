extends CharacterBody3D

@export var character_data : int
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var entity_component: EntityComponent = $EntityComponent
@onready var hud : Hud = get_node("../Hud")

func _ready() -> void:
	await hud.ready
	var player_health : Health = entity_component.get_component("Health")
	hud.initialize(player_health.max_health)
	player_health.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(amount) -> void:
	var player_health : Health = entity_component.get_component("Health")
	print(player_health.current_health)
	hud.healthBar.set_health(player_health.current_health - amount)
