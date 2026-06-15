class_name EnemyBehavior extends Component

func get_type() -> StringName:
	return &"EnemyBehavior"

@export var max_player_distance: float
@export var min_player_distance: float
