## Este componente representa una hurtbox de una entidad
class_name Hurtbox extends NodeComponent

func get_type() -> StringName:
	return &"Hurtbox"

var _area: Area3D
var enemy_entity: EntityComponent
var enemy: CharacterBody3D

func _ready() -> void:
	enemy_entity = get_parent()
	enemy = enemy_entity.get_parent()
	_area = enemy.get_node("Hurtbox")
	_build_area()

## Construye la hurtbox
func _build_area() -> void:
	_area.area_entered.connect(_on_area_entered)

## Emite hurtbox_entered con el cuerpo con el que hace contacto
func _on_area_entered(area: Area3D) -> void:
	SignalBus.hurtbox_entered.emit(
		_area,
		area
	)
