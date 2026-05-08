class_name MathScaling

# Operaciones matemáticas de escalado
static var OPERATIONS: Dictionary = {
	"mul": func(x: float, a: float): return x * a,
	"div": func(x: float, a: float): return x / a,
	"pow": func(x: float, a: float): return pow(x, a),
}

# 'a' es el número fijo que opera con 'x'
# 'op' es el nombre de la operación entre 'a' y 'x'
static func scaling_function(a: float, op: String) -> Callable:
	if not OPERATIONS.has(op):
		push_error("Operación inválida: " + op)
		return Callable()

	return func(x: float):
		return OPERATIONS[op].call(x, a)
