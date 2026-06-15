class_name AttackData extends Resource

@export var attack_coefficient: AttackCoefficient
@export var shot_speed: float
@export var duration: float
@export var hitbox_scale: Vector3
@export var projectile_scene: PackedScene

var damage_function: Callable ## Función usada para calcular el daño del arma
var attack_speed_function: Callable ## Función usada para calcular la cadencia de ataque

func _init():
	damage_function = MathScaling.scaling_function(
		attack_coefficient.num_operates_damage,
		attack_coefficient.damage_operation
	)

	attack_speed_function = MathScaling.scaling_function(
		attack_coefficient.num_operates_attack_speed,
		attack_coefficient.attack_speed_operation
	)
