extends CanvasLayer

@onready var healthBar = $Control/HealthBar
@onready var currencyCounter = $Control/CurrencyCounter
@onready var stamina_bar: ProgressBar = $Control/StaminaBar

func initialize(max_health, stamina : Stamina = null):
	healthBar.initialize(max_health)
	if stamina:
		stamina_bar.initialize(stamina)

func update_health(current):
	healthBar.set_health(current)

func update_stamina(current):
	stamina_bar.set_stamina(current)

func update_coins(amount):
	currencyCounter.set_coins(amount)
