class_name FirstAttackCooldown extends Component

func get_type() -> StringName:
	return &"FirstAttackCooldown"

signal can_attack()

@export var base_cooldown: int ## Tiempo total que tiene que pasar hasta poder empezar a atacar
var has_cooldown_ended: bool = false ## Indica si el cooldown terminó
var cooldown: float = 0.0: ## Tiempo restante hasta poder empezar a atacar
	set(value):
		cooldown = min(max(value, 0.0), base_cooldown)
		if cooldown == 0.0 and !has_cooldown_ended:
			has_cooldown_ended = true
			can_attack.emit()
		if cooldown != 0.0 and has_cooldown_ended:
			has_cooldown_ended = false

func update(delta: float):
	cooldown -= delta
