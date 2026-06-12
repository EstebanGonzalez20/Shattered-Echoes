## Esta clase representa una función de escalado
class_name MathScaling

## Operaciones posibles
enum OPERATIONS {
	## Multiplicación
	MULTIPLICATION,
	## División
	DIVISION,
	## Potenciación
	POWER
}

## Operaciones matemáticas de escalado
static var OPERATIONS_MAP: Dictionary = {
	OPERATIONS.MULTIPLICATION : func(x: float, a: float): return x * a,
	OPERATIONS.DIVISION : func(x: float, a: float): return x / a,
	OPERATIONS.POWER : func(x: float, a: float): return pow(x, a),
}

## Esta método crea un callable que realiza una operacion entre una constante a una variable.[br]
## 'a' es el número fijo que opera con 'x' la variable.[br]
## 'op' es el nombre de la operación entre 'a' y 'x'. 'op' puede ser:[br]
## - MULTIPLICATION: multiplica 'a' * 'x'[br]
## - DIVISION: divide 'x' / 'a'[br]
## - POWER: potencia 'x' a la 'a' 'x' ** 'a'[br]
static func scaling_function(a: float, op: OPERATIONS) -> Callable:
	return func(x: float):
		return OPERATIONS_MAP[op].call(x, a)
