class_name CollisionSystem extends RefCounted

## Aplica cierta lógica a la colisión de una hurtbox
func process_collision(hurtbox: Area3D, other_entity: EntityComponent) -> Array[Task]:
	#if not hurtbox.enabled or not other_entity.enabled:
	#	return
	# Se fijaría si la entidad tiene invencibilidad
	
	var tasks: Array[Task] = []
	
	var proj_stats: ProjectileStats = other_entity.get_component(&"ProjectileStats")
	#if proj_stats.status_effects.size() > 0:
	#	Se aplicarán bufos y debufos a la entidad
	
	if proj_stats != null:
		match proj_stats.health_effect:
			proj_stats.health_effects.Healing:
				var task: HealEntityTask = HealEntityTask.new()
				var other_entity_healing: Healing = other_entity.get_component(&"Healing")
				
				task.healing_value = other_entity_healing.healing
				task.entity = hurtbox.get_parent().get_node("EntityComponent")
				tasks.append(task)
			
			proj_stats.health_effects.Damage:
				var task: DamageEntityTask = DamageEntityTask.new()
				var other_entity_damage: Damage = other_entity.get_component("Damage")
				
				task.damage_value = other_entity_damage.damage
				task.entity = hurtbox.get_parent().get_node("EntityComponent")
				tasks.append(task)
		
		proj_stats.uses -= 1
		if proj_stats.uses <= 0:
			other_entity.get_parent().queue_free()
	
	return tasks
