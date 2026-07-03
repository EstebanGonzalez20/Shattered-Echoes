class_name PlayerMovementSystem extends RefCounted

func movement_process(player: CharacterBody3D, player_entity: EntityComponent, delta: float):
	var player_move: Movement = player_entity.get_component(&"Movement")
	var player_input: PlayerInput = player_entity.get_component(&"Input")
	
	# gravedad
	if not player.is_on_floor():
		player_move.velocity += player.get_gravity() * delta
	
	# salto
	if player_input.jump_pressed and player.is_on_floor():
		player_move.velocity.y = player_move.jump_velocity

	# dirección de movimiento
	var dir = (player.transform.basis *
		Vector3(player_input.move_vector.x, 0, player_input.move_vector.y)).normalized()

	if dir:
		player_move.velocity.x = dir.x * player_move.speed
		player_move.velocity.z = dir.z * player_move.speed
	else:
		player_move.velocity.x = move_toward(player_move.velocity.x, 0, player_move.speed)
		player_move.velocity.z = move_toward(player_move.velocity.z, 0, player_move.speed)

	player.velocity = player_move.velocity
	player.move_and_slide()
	player_move.velocity = player.velocity
