extends Area3D

class_name Attack

@export var shot_speed: float
@export var duration: float

@export var num_operates_damage: float = 1.0
@export var num_operates_attack_speed: float = 1.0

@export var damage_operation: String = "mul"
@export var attack_speed_operation: String = "mul"

var damage_function: Callable
var attack_speed_function: Callable

func _ready():
	damage_function = MathScaling.scaling_function(
		num_operates_damage,
		damage_operation
	)

	attack_speed_function = MathScaling.scaling_function(
		num_operates_attack_speed,
		attack_speed_operation
	)
