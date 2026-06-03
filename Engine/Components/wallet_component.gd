class_name Wallet extends Component

signal currency_changed(new_value: int)

@export var min_amount : int = 0:
	set(value):
		min_amount = min(value, max_amount - 1)
		if current < min_amount:
			current = min_amount

@export var max_amount : int = 99:
	set(value):
		max_amount = max(value, min_amount + 1)
		if current > max_amount:
			current = max_amount
			
@export var current : int = 0: 
	set(value): 
		current = clampi(value, min_amount, max_amount)
		currency_changed.emit(current)

func gain(amount : int) -> void:
	current += amount

func lose(amount : int) -> void:
	current -= amount
