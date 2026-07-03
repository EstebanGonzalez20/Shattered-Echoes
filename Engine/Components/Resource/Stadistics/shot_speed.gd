class_name ShotSpeed extends Component

func get_type() -> StringName:
	return &"ShotSpeed"

@export var shot_speed: float:
	set(value):
		shot_speed = max(value, 0)
