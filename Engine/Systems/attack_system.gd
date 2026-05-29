extends Node
class_name AttackSystem



# Called when the node enters the scene tree for the first time.
func perfom_attack(entity_damage, attack_damage, weapon_damage = null):
	var final_damage: float = 0.0
	if weapon_damage == null:
		final_damage = attack_damage.call(entity_damage)
		return final_damage
	else:
		final_damage = attack_damage.call(weapon_damage.call(entity_damage))
		var load_attack = load("res://Content/Weapons/melee.tscn")
		var melee_instance = load_attack.instantiate()
		var attack_hitbox = melee_instance.get_node("hitbox")
		attack_hitbox.scale = Vector3(2, 1.5, 1)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
