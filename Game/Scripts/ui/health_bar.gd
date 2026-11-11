extends ProgressBar

@onready var timer = $Timer
@onready var damageBar = $DamageBar
@onready var health_label: Label = $HealthLabel

var health := 0

func initialize(max_health: int):
	max_value = max_health
	
	health = max_health
	value = max_health
	
	damageBar.max_value = max_health
	damageBar.value = max_health
	
	health_label.text = "%s/%s" % [max_health, max_health]

func set_health(new_health: int):
	var previous_health = health
	
	health = clamp(new_health, 0, max_value)
	value = health
	
	if health < previous_health:
		timer.start()
		
	else:
		damageBar.value = health
	
	health_label.text = "%s/%s" % [value, max_value]

func _on_timer_timeout() -> void:
	damageBar.value = value
