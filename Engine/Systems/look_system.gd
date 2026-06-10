class_name LookSystem
extends Node

func process(player: CharacterBody3D, camera_pivot: Node3D, look: LookComponent, input: InputComponent):
	look.yaw -= input.mouse_delta.x * look.mouse_sens
	look.pitch -= input.mouse_delta.y * look.mouse_sens

	look.pitch = clamp(look.pitch, -80, 80)

	player.rotation_degrees.y = look.yaw
	camera_pivot.rotation_degrees.x = look.pitch

	input.mouse_delta = Vector2.ZERO
