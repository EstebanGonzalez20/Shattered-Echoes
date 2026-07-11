class_name AttackSpeed extends StatComponent

func get_type() -> StringName:
	return &"AttackSpeed"

func _get_allowed_modifiers() -> Array[Global.ModifierType]:
	return [Globals.ModifierType.MULTIPLIER]

## Tiempo restante hasta poder atacar otra vez
var cooldown: float = 0.0:
	set(value):
		cooldown = max(value, 0.0)

func can_attack() -> bool:
	return cooldown <= 0.0

func trigger_attack():
	cooldown = 1.0 / get_final()

func update(delta: float):
	cooldown -= delta
