class_name AttackSystem
extends Node
	
func spawn_hitbox(attacker, final_damage: float):
	var load_attack = load("res://Content/Weapons/melee.tscn")
	var melee_instance = load_attack.instantiate()

	get_tree().current_scene.add_child(melee_instance)

	var attack_hitbox = melee_instance.get_node("hitbox")

	attack_hitbox.damage = final_damage
	attack_hitbox.attacker = attacker
	
	attack_hitbox.scale = Vector3(2, 1.5, 1)
	melee_instance.global_position = attacker.global_position + (-attacker.global_transform.basis.z * 1.5)
# Called when the node enters the scene tree for the first time.
func perform_attack(attacker, attack_damage, weapon_damage = null):
	var final_damage: float = 0.0
	var entity_damage = attacker.damage_comp.damage
	
	if weapon_damage == null:
		final_damage = attack_damage.call(entity_damage)
		return final_damage
	else:
		final_damage = attack_damage.call(weapon_damage.call(entity_damage))
		spawn_hitbox(attacker, final_damage)
		return final_damage
