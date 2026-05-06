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
	var direction = (next_location - current_location).normalized()
	var horizontal_velocity = direction * move.speed

	entity.nav_agent.velocity = Vector3(horizontal_velocity.x, move.velocity.y, horizontal_velocity.z)

func _on_velocity_computed(safe_velocity: Vector3, entity: CharacterBody3D) -> void:
	var move = entity.movement
	
	move.velocity = safe_velocity
	entity.velocity = move.velocity
	entity.move_and_slide()
