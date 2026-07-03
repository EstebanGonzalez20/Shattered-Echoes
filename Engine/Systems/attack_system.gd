class_name AttackSystem extends RefCounted

func perform_attack(task: PerformAttackTask, current_scene: Node) -> void:
	var proj_scene_effect = task.proj_scene_effect
	var attack_instance = proj_scene_effect.projectile_scene.instantiate()
	var attack_instance_entity: EntityComponent = attack_instance.get_node("EntityComponent")
	var health_effects := ProjectileStats.health_effects
	
	var health_effect := health_effects.None 
	if task.damage != null:
		health_effect = health_effects.Damage
		var damage_comp := Damage.new()
		damage_comp.damage = task.damage
		attack_instance_entity.add_component(damage_comp)
	
	if task.healing != null:
		health_effect = health_effects.Healing
		var healing_comp := Healing.new()
		healing_comp.healing = task.healing
		attack_instance_entity.add_component(healing_comp)
	
	var duration_comp := Duration.new()
	duration_comp.duration = task.duration
	attack_instance_entity.add_component(duration_comp)
	
	var shot_speed_comp := ShotSpeed.new()
	shot_speed_comp.shot_speed = task.shot_speed
	attack_instance_entity.add_component(shot_speed_comp)
	
	var proj_stats_comp := ProjectileStats.new()
	proj_stats_comp.uses = task.uses
	proj_stats_comp.health_effect = health_effect
	attack_instance_entity.add_component(proj_stats_comp)
	
	current_scene.add_child(attack_instance)
	
	attack_instance.scale = proj_scene_effect.projectile_scalar
	
	var attacker_camera: Camera3D = task.attacker.get_node("Head/Camera3D")
	if proj_scene_effect.has_spawn_coordinates:
		attack_instance.global_position = task.attacker.global_transform * proj_scene_effect.spawn_coordinates
		
		var rot = attack_instance.global_rotation
		rot.y = attacker_camera.global_rotation.y
		attack_instance.global_rotation = rot
	else:
		attack_instance.global_position = attacker_camera.global_position
		attack_instance.global_rotation = attacker_camera.global_rotation
		attack_instance.global_position += -attacker_camera.global_transform.basis.z * 1.1
