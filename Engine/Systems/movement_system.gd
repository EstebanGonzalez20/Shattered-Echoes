class_name MovementSystem
extends Node

func process(entity: Node3D, delta: float):
	var entity_type: StringName = entity.get_groups()[0]
	match entity_type:
		'players':
			players_process(entity, delta)
		'projectile':
			projectiles_process(entity, delta)
		'enemies':
			enemies_process(entity, delta)
		_:
			assert(false, "Valor inválido de entidad: " + str(entity_type))

func players_process(entity: Node3D, delta: float):
	var move = entity.move_component
	var input = entity.input_component

	# gravedad
	if not entity.is_on_floor():
		move.velocity += entity.get_gravity() * delta

	# salto
	if input.jump_pressed and entity.is_on_floor():
		move.velocity.y = move.jump_velocity

	# dirección de movimiento
	var dir = (entity.transform.basis *
		Vector3(input.move_vector.x, 0, input.move_vector.y)).normalized()

	if dir:
		move.velocity.x = dir.x * move.speed
		move.velocity.z = dir.z * move.speed
	else:
		move.velocity.x = move_toward(move.velocity.x, 0, move.speed)
		move.velocity.z = move_toward(move.velocity.z, 0, move.speed)

	entity.velocity = move.velocity
	entity.move_and_slide()
	move.velocity = entity.velocity


func enemies_process(entity: Node3D, delta: float):
	var move = entity.move_component
	
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

func connect_navigation_signal(entity: CharacterBody3D) -> void:
	entity.nav_agent.connect(
		"velocity_computed",
		Callable(self, "_on_velocity_computed").bind(entity)
	)

func _on_velocity_computed(safe_velocity: Vector3, entity: CharacterBody3D) -> void:
	var move = entity.movement
	
	move.velocity = safe_velocity
	entity.velocity = move.velocity
	entity.move_and_slide()


func projectiles_process(entity: Node3D, delta: float):   
	var projectile = entity.entity
	var speed = entity.speed
	 
	var forward = -projectile.transform.basis.z.normalized()
	projectile.translate(forward * speed * delta)
