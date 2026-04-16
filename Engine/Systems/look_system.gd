class_name LookSystem
extends Node

func process(entity: Node3D, look: LookComponent, input: InputComponent):
	look.yaw -= input.mouse_delta.x * look.mouse_sens
	look.pitch -= input.mouse_delta.y * look.mouse_sens
	
	look.pitch = clamp(look.pitch, -80, 80)

	entity.rotation_degrees.y = look.yaw
	entity.rotation_degrees.x = look.pitch

	input.mouse_delta = Vector2.ZERO
