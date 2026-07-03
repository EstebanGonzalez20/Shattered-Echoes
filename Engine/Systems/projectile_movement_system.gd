class_name ProjectileMovementSystem extends RefCounted

func movement_process(projectile: Area3D, projectile_shot_speed: ShotSpeed, delta: float):   
	var forward = -projectile.transform.basis.z.normalized()
	projectile.translate(forward * projectile_shot_speed.shot_speed * delta)
