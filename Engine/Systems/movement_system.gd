class_name MovementSystem
extends Node

func process(entity: CharacterBody3D,
			move: MovementComponent,
			input: InputComponent,
			delta: float):

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
