class_name Phases extends Component

func get_type() -> StringName:
	return &"Phases"

@export var total_phases: int = 1 ## Cantidad total de fases del enemigo
var current_phase: int = 1: ## Fase actuál del enemigo
	set(value):
		current_phase = min(max(value, 1), total_phases)
