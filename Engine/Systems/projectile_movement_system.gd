class_name ProjectileMovementSystem extends RefCounted

func movement_process(projectile: Area3D, projectile_shot_speed: ShotSpeed, delta: float):   
	projectile.global_position += -projectile.global_basis.z * projectile_shot_speed.shot_speed * delta
