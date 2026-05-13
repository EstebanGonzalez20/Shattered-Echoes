extends Area3D
class_name Attack

@export var attack_data: AttackData

var damage_function: Callable
var attack_speed_function: Callable

func _ready():
	damage_function = MathScaling.scaling_function(
		attack_data.num_operates_damage,
		attack_data.damage_operation
	)

	attack_speed_function = MathScaling.scaling_function(
		attack_data.num_operates_attack_speed,
		attack_data.attack_speed_operation
	)
