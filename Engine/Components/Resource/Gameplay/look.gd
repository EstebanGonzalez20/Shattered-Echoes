class_name Look extends Component

func get_type() -> StringName:
	return &"Look"

@export var mouse_sens: float = 2.0 ## Sensibilidad de la camara
var yaw: float = 0.0 ## Movimiento horizontal de la camara
var pitch: float = 0.0 ## Movimiento vertical de la camara
