## Este componente determina que una entidad es un pickup
class_name Pickup extends Component

func get_type() -> StringName:
	return &"Pickup"

enum PickupType {
	COIN,
	HEAL
}

@export var type: PickupType ## El tipo de pikcup
@export var amount: int = 1 ## Cuanta cantidad de su tipo da al ser agarrado
var is_collected: bool = false ## Guardia para evitar doble recolección
