class_name WeaponComponent extends Component

func get_type() -> StringName:
	return &"Weapon"

@export var weapon_coefficient: AttackCoefficient 
@export var basic_attack: SkillResource ## La habilidad que usa el arma como atque básico
@export var special_attack: SkillResource ## La habilidad que usa el arma como habilidad especial

var damage_function: Callable ## Función usada para calcular el daño del arma
var attack_speed_function: Callable ## Función usada para calcular la cadencia del ataque básico

func _init():
	damage_function = MathScaling.scaling_function(
		weapon_coefficient.num_operates_damage,
		weapon_coefficient.damage_operation
	)

	attack_speed_function = MathScaling.scaling_function(
		weapon_coefficient.num_operates_attack_speed,
		weapon_coefficient.attack_speed_operation
	)
