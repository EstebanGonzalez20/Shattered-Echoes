class_name StatEffect extends SkillEffect

## Valor base de la estadística
@export var stat_value: float
## Constante usada en la operación de escalado
@export var num_operates_stat: float = 1.0
## Operación usada para escalar la estadística
@export var stat_operation: MathScaling.OPERATIONS

## Función de escalado para la estadística
var stat_scaling_function: Callable

func _init():
	stat_scaling_function = MathScaling.scaling_function(
		num_operates_stat,
		stat_operation
	)
