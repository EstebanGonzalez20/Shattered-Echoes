## Este componente representa el radio en el cual una entidad recolecta pickups
class_name PickupCollector extends Component

@export var radius: float = 24.0: set = _set_radius

func _set_radius(new_value: float):
	radius = max(new_value, 0)
