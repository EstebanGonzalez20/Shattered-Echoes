## Clase base para los componentes que representan estadísticas.
class_name StatComponent extends Component

## Valor base de la estadística.
@export var base_value: float 

## Diccionario que almacena los modificadores de la estadística usando la id de la fuente como llave y clasificandolos según su tipo.
var _modifiers: Dictionary[Global.ModifierType, Dictionary] = {}

## Devuelve los tipos de modificadores que la estadística admite.
func _get_allowed_modifiers() -> Array[Global.ModifierType]:
	return []

func add_modifier(source_id: StringName, amount: float, type: Global.ModifierType) -> void:
	if type in _get_allowed_modifiers():
		_modifiers[type][source_id] = amount

func remove_modifier(source_id: StringName, type: Global.ModifierType) -> void:
	_modifiers[type].erase(source_id)

## Devuelve el valor de la estadística luego de aplicarle todos los modificadores.
func get_final() -> float:
	var total := base_value
	if _modifiers.has(Global.ModifierType.FLAT):
		for value in _modifiers[Global.ModifierType.FLAT].values():
			total += value
	
	if _modifiers.has(Global.ModifierType.MULTIPLIER):
		var multiplier := 1.0
		for value in _modifiers[Global.ModifierType.MULTIPLIER].values():
			multiplier += value
		total *= multiplier
	
	return total
