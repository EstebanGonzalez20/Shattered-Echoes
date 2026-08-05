class_name Movement extends StatComponent

func get_type() -> StringName:
	return &"Movement"

func _get_allowed_modifiers() -> Array[Global.ModifierType]:
	return [Globals.ModifierType.FLAT, Globals.ModifierType.MULTIPLIER]

@export var jump_velocity: float: ## Representa que tan fuerte salta la entidad
	set(value):
		jump_velocity = max(value, 0)

var velocity: Vector3 = Vector3.ZERO ## El vector de velocidad de la entidad
