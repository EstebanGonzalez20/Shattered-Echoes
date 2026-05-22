extends Resource
class_name AttackData

@export var attack_coefficient: AttackCoefficient
@export var shot_speed: float
@export var duration: float

var damage_function: Callable
var attack_speed_function: Callable
 

func _ready():
	damage_function = MathScaling.scaling_function(
		attack_coefficient.num_operates_damage,
		attack_coefficient.damage_operation
	)

	attack_speed_function = MathScaling.scaling_function(
		attack_coefficient.num_operates_attack_speed,
		attack_coefficient.attack_speed_operation
	)
