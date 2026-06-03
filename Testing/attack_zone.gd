extends Area3D

@export var damage: float = 0.0

var damage_system: DamageSystem

func _ready():
	damage_system = Systems.get_node("DamageSystem")
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(body):
	if not body.has_node("HealthComponent"):
		return

	var health = body.get_node("HealthComponent")

	damage_system.apply_damage(damage, body)
