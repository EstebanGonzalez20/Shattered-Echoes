class_name Health extends Component

signal damage_taken(amount: int)

func get_type() -> StringName:
	return &"Health"

@export var max_health: int:
	set(value):
		max_health = max(value, 1)
		if current_health > max_health:
			current_health = max_health

var current_health: int = max_health:
	set(value):
		current_health = min(max(value, 0), max_health)

func is_alive() -> bool:
	return current_health > 0

func heal(amount: float):
	current_health += amount

func take_damage(amount: float):
	current_health -= amount
	damage_taken.emit(amount)
