class_name ProjectileStats extends Component

func get_type() -> StringName:
	return &"ProjectileStats"

## Enum que representa que efectos se le pueden aplicar a la salud
enum health_effects {
	Healing,
	Damage,
	None
}

@export var uses: int:
	set(value):
		uses = max(value, 0)

@export var health_effect: health_effects

var status_effects: Array = []
