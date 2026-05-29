class_name InputSystem
extends Node

func process_actions(input_comp: InputComponent):
	input_comp.move_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	input_comp.jump_pressed = Input.is_action_just_pressed("ui_accept")
	


func process_mouse(event: InputEvent, input_comp: InputComponent, weapon_comp: WeaponComponent, player, AttackSystem):
	if event is InputEventMouseMotion:
		input_comp.mouse_delta = event.relative
	if Input.is_action_pressed("basic_attack"):
		AttackSystem.perform_attack(player,weapon_comp.basic_attack.damage_function , weapon_comp.weapon_coefficient)
	if Input.is_action_pressed("special_attack"):
		AttackSystem.perform_attack(player,weapon_comp.special_attack.damage_function , weapon_comp.weapon_coefficient)
