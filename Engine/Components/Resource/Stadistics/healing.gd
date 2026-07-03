class_name Healing extends Component

func get_type() -> StringName:
	return &"Healing"

@export var healing: float:
	set(value):
		healing = max(value, 1)
