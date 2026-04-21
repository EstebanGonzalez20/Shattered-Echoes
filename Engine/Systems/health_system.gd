extends Node
class_name HealthSystem

func apply_damage(attacker, target):
	# Validaciones
	if attacker.damage == null:
		return
	if target.health == null:
		return

	var damage_comp = attacker.damage
	var health_comp = target.health

	# Aplicar daño
	health_comp.take_damage(damage_comp.damage)

	# Verificar muerte
	if not health_comp.is_alive():
		on_entity_died(target)

func apply_direct_damage(target, amount: float):
	if target.health == null:
		return

	target.health.take_damage(amount)

	if not target.health.is_alive():
		on_entity_died(target)

func on_entity_died(entity):
	print("Entidad murió: ", entity.name)

	if entity.has_method("die"):
		entity.die()
	else:
		entity.queue_free()
		
