class_name MovementComponent extends Component

func get_type() -> StringName:
	return &"Movement"

@export var speed: float: ## Representa que tan rápido se mueve la entidad
	set(value):
		speed = max(value, 0)

@export var jump_velocity: float: ## Representa que tan fuerte salta la entidad
	set(value):
		jump_velocity = max(value, 0)

var velocity: Vector3 = Vector3.ZERO ## El vector de velocidad de la entidad
