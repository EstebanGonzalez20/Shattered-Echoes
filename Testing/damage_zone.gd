extends Area3D

@export var damage: float = 10.0

var damage_system: DamageSystem

func _ready():
	damage_system = Systems.get_node("DamageSystem")
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(body):
	# Verificamos que tenga health
	if body.health == null:
		return

	damage_system.apply_direct_damage(body, damage)
