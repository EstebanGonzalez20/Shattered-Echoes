extends Component
class_name AttackSpeedComponent

# Ataques por segundo (ej: 2 = 2 ataques por segundo)
@export var attacks_per_second: float = 1.0

# Tiempo restante hasta poder atacar otra vez
var cooldown: float = 0.0

func can_attack() -> bool:
	return cooldown <= 0.0

func trigger_attack():
	cooldown = 1.0 / attacks_per_second

func update(delta: float):
	if cooldown > 0.0:
		cooldown -= delta
