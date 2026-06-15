extends StaticBody3D

@export var health: Health

func _ready():
	if health:
		health.current_health = health.max_health

func take_damage(amount: float):
	health.take_damage(amount)

	print("Daño recibido:", amount)
	print("Vida restante:", health.current_health)

	if not health.is_alive():
		die()

func die():
	print("Zona destruida")
	queue_free()
