## Esta clase indica que un nodo se va a comportar como entidad
class_name EntityComponent extends Node

@export var initial_components: Array[Component] = []

var _components: Dictionary = {}

func _ready() -> void:
	for component in initial_components:
		add_component(component.duplicate())

	# Después los NodeComponents que ya son hijos en el árbol
	for child in get_children():
		if child is NodeComponent:
			_components[child.TYPE] = child

## Añade un componente a la entidad. El componente debe tener un tipo
func add_component(component: Object) -> void:
	var type: StringName
	if component is Component or component is NodeComponent:
		type = component.get_type()
	else:
		assert(false, "Objeto no reconocido como componente: %s" % component.get_class())
		return

	assert(type != &"", "Componente %s retornó TYPE vacío" % component.get_class())

	if component is Node:
		add_child(component)
		_components[component.TYPE] = component

## Devuelve un componente a partir de su tipo
func get_component(type: StringName) -> Object:
	return _components.get(type, null)

## Devuelve si la entidad tiene o no el tipo de componente
func has_component(type: StringName) -> bool:
	return _components.has(type)

## Remueve el componente de la entidad a partir del tipo
func remove_component(type: StringName) -> void:
	if not _components.has(type):
		return

	var component = _components[type]
	_components.erase(type)

	if component is Node:
		component.queue_free()
