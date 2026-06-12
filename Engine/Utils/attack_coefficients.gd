class_name AttackCoefficient extends Resource

@export var num_operates_damage: float = 1.0 ## Constante usada en la operación de daño
@export var num_operates_attack_speed: float = 1.0 ## Constante usada en la operación de velocidad de ataque

@export var damage_operation: MathScaling.OPERATIONS ## Operación usada para calcular el daño
@export var attack_speed_operation: MathScaling.OPERATIONS ## Operación usada para calcular la velocidad de ataque
