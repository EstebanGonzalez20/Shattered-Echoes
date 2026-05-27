extends Component
class_name AttackSpeedComponent

## Ataques por segundo (ej: 2 = 2 ataques por segundo)
@export var attacks_per_second: float = 1.0

# Tiempo restante hasta poder atacar otra vez
var cooldown: float = 0.0

func get_attacks_per_second() -> float:
	return attacks_per_second

func set_attacks_per_second(new_attacks_per_second: float):
	attacks_per_second = max(new_attacks_per_second, 0.1)

func set_cooldown(new_cooldown: float):
	cooldown = max(new_cooldown, 0.0)

func can_attack() -> bool:
	return cooldown <= 0.0

func trigger_attack():
	cooldown = 1.0 / attacks_per_second

func update(delta: float):
	set_cooldown(cooldown - delta)
