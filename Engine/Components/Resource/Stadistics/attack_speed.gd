class_name AttackSpeed extends Component

func get_type() -> StringName:
	return &"AttackSpeed"

## Ataques por segundo (ej: 2 = 2 ataques por segundo)
@export var attacks_per_second: float:
	set(value):
		attacks_per_second = max(value, 0.1)

## Tiempo restante hasta poder atacar otra vez
var cooldown: float = 0.0:
	set(value):
		cooldown = max(value, 0.0)

func can_attack() -> bool:
	return cooldown <= 0.0

func trigger_attack():
	cooldown = 1.0 / attacks_per_second

func update(delta: float):
	cooldown -= delta
