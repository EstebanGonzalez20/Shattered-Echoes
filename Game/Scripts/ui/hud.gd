extends CanvasLayer

@onready var healthBar = $Control/HealthBar
@onready var currencyCounter = $Control/CurrencyCounter

func initialize(max_health):
	healthBar.initialize(max_health)

func update_health(current):
	healthBar.set_health(current)

func update_coins(amount):
	currencyCounter.set_coins(amount)
