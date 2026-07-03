class_name SkillSystem extends RefCounted

var tasks: Array[Task] = []

## Procesa cada efecto de una habilidad
func process_skill(skill: SkillResource,
	entity: CharacterBody3D,
	entity_component: EntityComponent,
	weapon: Weapon = null) -> Array[Task]:
	var effects: Dictionary = skill.effects
	var proj_scene_effect: ProjectileSceneEffect = effects.get(Global.EffectType.ProjectileScene)
	
	if proj_scene_effect:
		var perform_attack_task := PerformAttackTask.new()
		perform_attack_task.proj_scene_effect = proj_scene_effect
		process_attack(effects, entity, entity_component, perform_attack_task, weapon)
	
	return tasks


func process_attack(effects: Dictionary,
	entity: CharacterBody3D,
	entity_component: EntityComponent,
	perform_attack_task: PerformAttackTask,
	weapon: Weapon) -> void:
	var damage_effect: ScalableStatEffect = effects.get(Global.EffectType.Damage)
	var healing_effect: ScalableStatEffect = effects.get(Global.EffectType.Healing)
	var shot_speed_effect: ScalableStatEffect = effects.get(Global.EffectType.ShotSpeed)
	var attack_speed_effect: ScalableStatEffect = effects.get(Global.EffectType.AttackSpeed)
	var duration_effect: ScalableStatEffect = effects.get(Global.EffectType.Duration)
	var uses_effect: FixedStatEffect = effects.get(Global.EffectType.Uses)
	
	var entity_dmg: Damage = entity_component.get_component(&"Damage")
	var entity_healing: Healing = entity_component.get_component(&"Healing")
	var entity_atk_speed: AttackSpeed = entity_component.get_component(&"AttackSpeed")
	
	perform_attack_task.attacker = entity
	perform_attack_task.uses = uses_effect.stat_value
	
	perform_attack_task.shot_speed = scale_stat(shot_speed_effect, 0)
	var final_damage = scale_stat(damage_effect, entity_dmg.damage) if damage_effect != null else null
	var final_healing = scale_stat(healing_effect, entity_healing.healing) if healing_effect != null else null
	var final_attack_speed = scale_stat(attack_speed_effect, entity_atk_speed.attacks_per_second)
	
	if weapon != null:
		var weapon_damage_effect := weapon.scaling_damage
		var weapon_healing_effect := weapon.scaling_healing
		var weapon_atk_speed_effect := weapon.scaling_attack_speed
		
		final_damage = scale_stat(weapon_damage_effect, final_damage) if final_damage != null else null
		final_healing = scale_stat(weapon_healing_effect, final_healing) if final_healing != null else null
		final_attack_speed = scale_stat(weapon_atk_speed_effect, final_attack_speed)
	
	perform_attack_task.duration = scale_stat(duration_effect, final_attack_speed)
	perform_attack_task.damage = final_damage
	perform_attack_task.healing = final_healing
	
	tasks.append(perform_attack_task)

## Escala una estadística, sumada a un valor
func scale_stat(stat_effect: ScalableStatEffect, value: float) -> float:
	var stat_scal_fn := stat_effect.stat_scaling_function
	return stat_scal_fn.call(value + stat_effect.stat_value)
