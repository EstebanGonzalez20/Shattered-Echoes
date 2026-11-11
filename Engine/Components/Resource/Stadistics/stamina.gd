class_name Stamina extends Component

## Señal que se emite cuando current_stamina cambia.
signal stamina_changed(new_value, old_value)

@export var max_stamina : int 

## Almacena la cantidad de estamina actual.
var current_stamina : int :
	set(newValue):
		var old_value : int = current_stamina
		current_stamina = clamp(newValue, 0, max_stamina) 
		stamina_changed.emit(current_stamina, old_value)

## Flag que verifica si la estamina está agotada o no
var exhausted : bool :
	get:
		return current_stamina == 0

## Tiempo restante hasta empezar a regenerar la estamina.
var cooldown: float = 0.0:
	set(value):
		cooldown = max(value, 0.0)

func get_type() -> StringName:
	return &"Stamina"

func initialize() -> void:
	current_stamina = max_stamina

## Disminuye la estamina actual en una cantidad dada. 
func expend_stamina(amount : float) -> void:
	current_stamina -= amount
	cooldown = 1.25 if exhausted else 0.8

func update(delta: float):
	if cooldown > 0:
		cooldown -= delta
	
	else:
		current_stamina += delta * 10
