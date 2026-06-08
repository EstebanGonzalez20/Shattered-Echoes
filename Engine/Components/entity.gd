## Esta clase indica que un nodo se va a comportar como entidad
class_name EntityComponent extends Node

@export var initial_components: Array[Component] = []

var _components: Dictionary = {}

func _ready() -> void:
	for component in initial_components:
		add_component(component)
	
	# Después los NodeComponents que ya son hijos en el árbol
	for child in get_children():
		if child is NodeComponent:
			_components[child.TYPE] = child

## Añade un componente a la entidad. El componente debe tener un tipo
func add_component(component: Object) -> void:
	# Si es nodo, necesita entrar al árbol para funcionar
	assert("TYPE" in component, 
		"El componente %s no tiene la constante TYPE definida" % component.get_class())
	
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
	
	# La limpieza depende del tipo
	if component is Node:
		component.queue_free()
	# Si es RefCounted, el reference counting de Godot lo libera solo
	# cuando nadie más lo referencia — no hay que hacer nada
