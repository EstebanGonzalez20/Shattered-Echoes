extends Area3D

var damage: float
var duration: float
var shot_speed: float
var attacker: CharacterBody3D

var damage_system: DamageSystem
var movement_system: MovementSystem

func _ready():
	damage_system = Systems.get_node("DamageSystem")
	movement_system = Systems.get_node("MovementSystem")
	body_entered.connect(_on_body_entered)
	
	# Duración de la hitbox
	await get_tree().create_timer(duration).timeout
	queue_free()

func _on_body_entered(body):
	if body == attacker or body.get("health") == null:
		return
	damage_system.apply_damage(damage, body)

func _physics_process(delta):
	if shot_speed != 0.0:
		var parameters: MovementSystemParameters = MovementSystemParameters.new()
		parameters.set_projectile_parameters(self, shot_speed)
		
		movement_system.process('projectile', parameters, delta)
