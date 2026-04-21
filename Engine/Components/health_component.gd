extends Component
class_name HealthComponent

@export var max_health: float = 100.0
var current_health: float

func _init():
	current_health = max_health

func is_alive() -> bool:
	return current_health > 0

func heal(amount: float):
	current_health = min(current_health + amount, max_health)

func take_damage(amount: float):
	current_health -= amount
	current_health = max(current_health, 0)
