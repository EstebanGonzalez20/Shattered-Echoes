class_name ProjectileMovementSystem
extends Node

func process(projectile: Area3D, speed: float, delta: float):    
	var forward = -projectile.transform.basis.z.normalized()
	projectile.translate(forward * speed * delta)
