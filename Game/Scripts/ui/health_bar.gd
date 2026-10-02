extends ProgressBar

@onready var timer : Timer = $Timer
@onready var damageBar : ProgressBar = $DamageBar
@onready var health_label: Label = $HealthLabel


var health := 0

func initialize(max_health: int):
	max_value = max_health
	health = max_health
	value = max_health
	damageBar.max_value = max_health
	damageBar.value = max_health
	update_label()

func update_label() -> void:
	health_label.text = str(value) + "/" + str(max_value)

func set_health(new_health: int):
	var previous_health = health
	
	health = clamp(new_health, 0, max_value)
	value = health
	update_label()
	
	if health < previous_health:
		timer.start()
		
	else:
		damageBar.value = health

func _on_timer_timeout() -> void:
	damageBar.value = value
