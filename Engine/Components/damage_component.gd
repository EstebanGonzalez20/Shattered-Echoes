extends Component
class_name DamageComponent

@export var damage: float = 10.0

func get_damage() -> float:
	return damage

func set_damage(new_damage: float):
	damage = max(new_damage, 1.0)
