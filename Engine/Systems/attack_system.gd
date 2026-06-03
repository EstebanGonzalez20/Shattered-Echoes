class_name AttackSystem
extends Node



func spawn_hitbox():
	
		var load_attack = load("res://Content/Weapons/melee.tscn")
		var melee_instance = load_attack.instantiate()
		get_tree().current_scene.add_child(melee_instance)
		var attack_hitbox = melee_instance.get_node("hitbox")
		attack_hitbox.scale = Vector3(2, 1.5, 1)
# Called when the node enters the scene tree for the first time.
func perform_attack(entity_damage, attack_damage, weapon_damage = null):
	print(type_string(typeof(entity_damage)))
	print(type_string(typeof(attack_damage)))
	print(type_string(typeof(weapon_damage)))
	
	var final_damage: float = 0.0
	if weapon_damage == null:
		final_damage = attack_damage.call(entity_damage)
		return final_damage
	else:
		final_damage = attack_damage.call(weapon_damage.call(entity_damage))
		spawn_hitbox()
		return final_damage
