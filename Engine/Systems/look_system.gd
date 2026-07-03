class_name LookSystem extends RefCounted

func look_process(player: CharacterBody3D, player_entity: EntityComponent):
	var camera_pivot: Node3D = player.get_node("Head")
	var look: Look = player_entity.get_component(&"Look")
	var input: PlayerInput = player_entity.get_component(&"Input")
	
	look.yaw -= input.mouse_delta.x * look.mouse_sens
	look.pitch -= input.mouse_delta.y * look.mouse_sens
	
	look.pitch = clamp(look.pitch, -80, 80)
	
	player.rotation_degrees.y = look.yaw
	camera_pivot.rotation_degrees.x = look.pitch
	
	input.mouse_delta = Vector2.ZERO
