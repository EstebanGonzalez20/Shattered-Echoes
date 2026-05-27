extends Component
class_name HealthComponent

@export var max_health: float
var current_health: float

func _init():
	current_health = max_health

func set_max_health(new_max_health: int):
	max_health = min(new_max_health, 1)
	
	if current_health > max_health:
		set_current_health(max_health)

func get_max_health() -> int:
	return max_health

func set_current_health(new_current_health: int):
	current_health = min(max(new_current_health, 0), max_health)
	
func get_current_health() -> int:
	return current_health

func is_alive() -> bool:
	return current_health > 0

func heal(amount: float):
	set_current_health(current_health + amount)

func take_damage(amount: float):
	set_current_health(current_health - amount)
