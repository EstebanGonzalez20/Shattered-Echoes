class_name Damage extends StatComponent

func get_type() -> StringName:
	return &"Damage"

func _get_allowed_modifiers() -> Array[Global.ModifierType]:
	return [Globals.ModifierType.FLAT, Globals.ModifierType.MULTIPLIER]
