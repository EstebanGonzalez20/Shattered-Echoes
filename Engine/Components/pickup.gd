## Este componente determina que una entidad es un pickup
class_name PickupComponent extends Component

enum PickupType {
	COIN,
	HEAL
}

@export var type: PickupType
@export var amount: int = 1
## Guardia para evitar doble recolección
var is_collected: bool = false
