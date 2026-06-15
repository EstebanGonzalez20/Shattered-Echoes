class_name Damage extends Component

func get_type() -> StringName:
	return &"Damage"

@export var damage: float:
	set(value):
		damage = max(value, 1)
