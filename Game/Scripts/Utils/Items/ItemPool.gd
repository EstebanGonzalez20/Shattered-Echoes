# engine/inventory/item_pool.gd
class_name ItemPool extends Resource

## Lista de Items que contiene la pool.
@export var entries: Array[Item] = []

## Devuelve un Item aleatorio que esté dentro de entries.
func pick_random() -> Item:
	return entries.pick_random()
