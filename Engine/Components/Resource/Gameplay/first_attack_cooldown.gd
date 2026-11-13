class_name FirstAttackCooldown extends Component

func get_type() -> StringName:
	return &"FirstAttackCooldown"

@export var base_cooldown: int ## Tiempo total que tiene que pasar hasta poder empezar a atacar

## Tiempo restante hasta poder empezar a atacar
var cooldown: float = 0.0:
	set(value):
		cooldown = min(max(value, 0.0), base_cooldown)

func update(delta: float):
	cooldown -= delta
