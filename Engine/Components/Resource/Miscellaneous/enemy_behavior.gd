class_name EnemyBehavior extends Component

func get_type() -> StringName:
	return &"EnemyBehavior"

@export var max_player_distance: float ## Distancia máxima que debe estar el jugador para mover al enemigo
@export var min_player_distance: float ## Distancia mínima que debe estar el jugador para mover al enemigo
var is_still: bool = false ## Indica si el enemigo está quieto
