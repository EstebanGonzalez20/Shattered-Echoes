extends Component
class_name WeaponComponent

@export var weapon_coefficient: AttackCoefficient
@export var basic_attack: AttackData
@export var special_attack: AttackData

var damage_function: Callable
var attack_speed_function: Callable


func _ready():
	damage_function = MathScaling.scaling_function(
		weapon_coefficient.num_operates_damage,
		weapon_coefficient.damage_operation
	)

	attack_speed_function = MathScaling.scaling_function(
		weapon_coefficient.num_operates_attack_speed,
		weapon_coefficient.attack_speed_operation
	)
