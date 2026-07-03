## Este componente representa la navegación que un enemigo puede y debe hacer
class_name EnemyNavigation extends NodeComponent

func get_type() -> StringName:
	return &"EnemyNavigation"

var _navigation: NavigationAgent3D
var enemy_entity: EntityComponent
var enemy: CharacterBody3D

func _ready() -> void:
	enemy_entity = get_parent()
	enemy = enemy_entity.get_parent()
	_navigation = enemy.get_node("NavigationAgent3D")
	_build_navigation()

## Construye el agente de navegación
func _build_navigation() -> void:
	_navigation.velocity_computed.connect(_on_velocity_computed)
	_navigation.avoidance_enabled = true

## Emite como señal la velocidad computada del enemigo
func _on_velocity_computed(safe_velocity: Vector3) -> void:
	SignalBus.navigation_velocity_computed.emit(
		enemy,
		safe_velocity
	)
