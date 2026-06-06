class_name AttackSystem
extends Node

func spawn_hitbox(attacker: CharacterBody3D, final_damage: float, attack_data: AttackData):
	var attack_instance = attack_data.projectile_scene.instantiate()

	attack_instance.damage = final_damage
	attack_instance.duration = attack_data.duration
	attack_instance.shot_speed = attack_data.shot_speed
	attack_instance.attacker = attacker

	get_tree().current_scene.add_child(attack_instance)

	attack_instance.scale = attack_data.hitbox_scale
	attack_instance.global_transform = attacker.global_transform
	attack_instance.global_position += -attacker.global_transform.basis.z * 1.1

func perform_attack(attacker: CharacterBody3D, attack_data: AttackData, weapon_damage = null):
	var final_damage: float
	var entity_damage: float = attacker.damage_comp.damage
	var attack_damage: Callable = attack_data.damage_function

	if weapon_damage == null:
		final_damage = attack_damage.call(entity_damage)
	else:
		final_damage = attack_damage.call(weapon_damage.call(entity_damage))
	spawn_hitbox(attacker, final_damage, attack_data)
