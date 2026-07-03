class_name HealthSystem extends RefCounted

## Aplica daño a una entidad que tenga componente de vida
func apply_damage(task: DamageEntityTask) -> Node3D:
	var amount: float = task.damage_value
	var target: EntityComponent = task.entity
	# Validaciones
	var target_health: Health = target.get_component("Health")
	if target_health == null:
		return
	
	target_health.take_damage(amount)
	
	if not target_health.is_alive():
		return target.get_parent()
	
	return

## Aplica curación a una entidad que tenga componente de vida
func apply_heal(task: HealEntityTask):
	var amount: float = task.healing_value
	var target: EntityComponent = task.entity
	# Validaciones
	var target_health: Health = target.get_component("Health")
	if target_health == null:
		return
	target_health.heal(amount)
