class_name EnemyMovementSystem
extends Node

func connect_navigation_signal(entity: CharacterBody3D) -> void:
	entity.nav_agent.connect(
		"velocity_computed",
		Callable(self, "_on_velocity_computed").bind(entity)
	)

func process(entity: CharacterBody3D,
			move: MovementComponent,
			delta: float):

	# gravedad
	if not entity.is_on_floor():
		move.velocity.y += entity.get_gravity().y * delta
	else:
		move.velocity.y = 0

	# dirección de movimiento
	var current_location = entity.global_transform.origin
	var next_location = entity.nav_agent.get_next_path_position()
	var direction = next_location - current_location
	var distance = direction.length()

	var target_velocity = Vector3.ZERO

	if distance > 0.1:
		direction = direction.normalized()
		target_velocity = direction * move.speed

	# aceleración de 0.5 segundos
	var accel_time = 0.5
	var acceleration = move.speed / accel_time

	var current_horizontal = Vector3(move.velocity.x, 0, move.velocity.z)

	if target_velocity.length() > 0:
		# acelerar suavemente
		current_horizontal = current_horizontal.move_toward(target_velocity, acceleration * delta)
	else:
		# frenar instantáneamente
		current_horizontal = Vector3.ZERO

	entity.nav_agent.velocity = Vector3(
		current_horizontal.x,
		move.velocity.y,
		current_horizontal.z
	)

func _on_velocity_computed(safe_velocity: Vector3, entity: CharacterBody3D) -> void:
	var move = entity.movement
	
	move.velocity = safe_velocity
	entity.velocity = move.velocity
	entity.move_and_slide()
