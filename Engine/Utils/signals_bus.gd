class_name SignalsBus extends Node

## Señal para enviar la velocidad computada de un enemigo
signal navigation_velocity_computed(
	enemy: CharacterBody3D,
	safe_velocity: Vector3
)

## Señal para enviar dos cajas de colisiones
signal hurtbox_entered(
	hurtbox: Area3D,
	other_area: Area3D
)
