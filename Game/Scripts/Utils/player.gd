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
	
	## Realiza todas las conexiones para la vida.
	var player_health : Health = entity_component.get_component("Health")
	player_health.damage_taken.connect(_on_damage_taken)
	player_health.health_restore.connect(_on_health_restore)
	player_health.die.connect(_on_die)
	
	## Realiza todas las conexiones para la estamina.
	if entity_component.has_component("Stamina"):
		var player_stamina : Stamina = entity_component.get_component("Stamina")
		player_stamina.stamina_changed.connect(_on_stamina_changed)
	
	## Realiza todas las conexiones para el input.
	if entity_component.has_component("Input"):
		var player_input : PlayerInput = entity_component.get_component("Input")
		player_input.player_action.connect(_on_action_done)

func _on_damage_taken(amount) -> void:
	var player_health : Health = entity_component.get_component("Health")
	hud.healthBar.set_health(player_health.current_health)

func _on_health_restore(amount) -> void:
	var player_health : Health = entity_component.get_component("Health")
	hud.healthBar.set_health(player_health.current_health)

func _on_stamina_changed(new_value, old_value) -> void:
	hud.update_stamina(entity_component.get_component("Stamina").current_stamina)

func _on_action_done(action_name) -> void:
	match action_name:
		&"basic_attack", &"special_attack":
			entity_component.get_component("Stamina").expend_stamina(30)

func _on_die() -> void:
	player_died.emit()

func _process(delta: float) -> void:
	if Input.is_action_pressed("accept"):
		print(entity_component.get_component("Stamina").current_stamina)
