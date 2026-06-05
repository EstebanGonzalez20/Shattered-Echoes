class_name InputSystem
extends Node

func process_actions(input_comp: InputComponent):
	input_comp.move_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	input_comp.jump_pressed = Input.is_action_just_pressed("ui_accept")
	


func process_mouse(event: InputEvent, input_comp: InputComponent, weapon_comp: WeaponComponent, player, attack_system: AttackSystem):
	if event is InputEventMouseMotion:
		input_comp.mouse_delta = event.relative
	if Input.is_action_pressed("basic_attack"):
		var effects = weapon_comp.basic_attack.effects
		var attack_data = effects.filter(func(obj): return obj is AttackData).get(0)
		attack_system.perform_attack(player, attack_data.damage_function, weapon_comp.damage_function)
	if Input.is_action_pressed("special_attack"):
		var effects = weapon_comp.special_attack.effects
		var attack_data = effects.filter(func(obj): return obj is AttackData).get(0)
		attack_system.perform_attack(player, attack_data.damage_function, weapon_comp.damage_function)
