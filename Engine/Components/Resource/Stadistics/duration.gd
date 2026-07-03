class_name Duration extends Component

func get_type() -> StringName:
	return &"Duration"

@export var duration: float:
	set(value):
		duration = max(value, 0)
