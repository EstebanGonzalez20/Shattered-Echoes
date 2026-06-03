extends Area3D

var damage: float = 0.0
var attacker

var damage_system: DamageSystem

func _ready():

	damage_system = Systems.get_node("DamageSystem")

	body_entered.connect(_on_body_entered)

	# Duración de la hitbox
	await get_tree().create_timer(0.15).timeout
	queue_free()

func _on_body_entered(body):

	if body == attacker:
		return

	if body.get("health") == null:
		return

	damage_system.apply_damage(damage, body)
