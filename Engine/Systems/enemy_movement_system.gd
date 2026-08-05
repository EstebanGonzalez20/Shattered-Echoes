class_name EnemyMovementSystem extends RefCounted

func process_movement(enemy: CharacterBody3D, delta: float):
	var enemy_entity: EntityComponent = enemy.get_node("EntityComponent")
	var enemy_nav_agent: NavigationAgent3D = enemy.get_node("NavigationAgent3D")
	var enemy_move: Movement = enemy_entity.get_component(&"Movement")
	# gravedad
	if not enemy.is_on_floor():
		enemy_move.velocity += enemy.get_gravity() * delta

	# dirección de movimiento
	var current_location = enemy.global_transform.origin
	var next_location = enemy_nav_agent.get_next_path_position()
	var direction = next_location - current_location
	var distance = direction.length()

	var target_velocity = Vector3.ZERO

	if distance > 0.1:
		direction = direction.normalized()
		target_velocity = direction * enemy_move.base_value

	# aceleración de 0.5 segundos
	var accel_time = 0.5
	var acceleration = enemy_move.base_value / accel_time

	var current_horizontal = Vector3(enemy_move.velocity.x, 0, enemy_move.velocity.z)

	if target_velocity.length() > 0:
		# acelerar suavemente
		current_horizontal = current_horizontal.move_toward(target_velocity, acceleration * delta)
	else:
		# frenar instantáneamente
		current_horizontal = Vector3.ZERO

	enemy_nav_agent.velocity = Vector3(
		current_horizontal.x,
		enemy_move.velocity.y,
		current_horizontal.z
	)

func on_velocity_computed(safe_velocity: Vector3, enemy: CharacterBody3D) -> void:	
	var enemy_entity: EntityComponent = enemy.get_node("EntityComponent")
	var enemy_move: Movement = enemy_entity.get_component(&"Movement")
	
	enemy_move.velocity = safe_velocity
	enemy.velocity = enemy_move.velocity
	enemy.move_and_slide()
