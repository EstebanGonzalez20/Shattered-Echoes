class_name Health extends Component

signal damage_taken(amount: int)
signal health_restore(amount : int)
signal die

func get_type() -> StringName:
	return &"Health"

@export var max_health: float:
	set(value):
		max_health = max(value, 1)
		if current_health > max_health or current_health == -1:
			current_health = max_health

var current_health: float :
	set(value):
		current_health = min(max(value, 0), max_health)

func initialize() -> void:
	current_health = max_health

func is_alive() -> bool:
	return current_health > 0

func heal(amount: float):
	current_health += amount
	health_restore.emit(amount)

func take_damage(amount: float):
	current_health -= amount
	damage_taken.emit(amount)
	if current_health == 0:
		die.emit()
