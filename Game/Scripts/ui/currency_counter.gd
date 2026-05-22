extends HBoxContainer

@onready var label = $Label

func set_coins(amount: int):
	label.text = "x " + str(amount)
