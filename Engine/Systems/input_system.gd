class_name InputSystem extends Node

func process_actions(input_comp: PlayerInput):
	input_comp.move_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	input_comp.jump_pressed = Input.is_action_just_pressed("ui_accept")
	


func process_mouse(event: InputEvent, input_comp: PlayerInput, weapon_comp: Weapon, entity: CharacterBody3D, attack_system: AttackSystem):
	if event is InputEventMouseMotion:
		input_comp.mouse_delta = event.relative

	if Input.is_action_pressed("basic_attack") or Input.is_action_pressed("special_attack"):
		var attack_type: String = "basic_attack" if Input.is_action_pressed("basic_attack") else "special_attack"
		var effects = weapon_comp.get(attack_type).effects
		var attack_data = effects.filter(func(obj): return obj is AttackData).get(0)

		attack_system.perform_attack(entity, attack_data, weapon_comp.damage_function)
