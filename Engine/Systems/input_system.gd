class_name InputSystem extends RefCounted

func process_movement(input_comp: PlayerInput):
	input_comp.move_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	input_comp.jump_pressed = Input.is_action_just_pressed("jump")

func process_mouse_motion(event: InputEvent, player_input: PlayerInput):
	player_input.mouse_delta = event.relative
