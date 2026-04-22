extends Node
class_name DamageSystem

##Aplica daño a una entidad que tenga componente de vida
func apply_damage(amount: int, target):
	# Validaciones
	if target.health == null:
		return

	var health_comp = target.health
	# Aplicar daño
	health_comp.take_damage(amount)
	# Verificar muerte
	if not health_comp.is_alive():
		on_entity_died(target)

##Maneja la muerte de las entidades al sufrir daño letal
func on_entity_died(entity):
	print("Entidad murió: ", entity.name)

	if entity.has_method("die"):
		entity.die()
	else:
		entity.queue_free()
