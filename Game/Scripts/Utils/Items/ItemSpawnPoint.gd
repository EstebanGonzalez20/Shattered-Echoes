# engine/inventory/item_spawn_point.gd
class_name ItemSpawnPoint
extends Node3D

@export var pool: ItemPool

const ITEM_PICKUP_SCENE: PackedScene = preload("res://Game/scenes/Utils/ItemPickup.tscn")

func _ready() -> void:
	if pool == null:
		push_warning("ItemSpawnPoint sin pool asignado: %s" % name)
		return
	
	var chosen_item := pool.pick_random()
	if chosen_item == null:
		return
	
	var pickup: ItemPickup = ITEM_PICKUP_SCENE.instantiate()
	pickup.item = chosen_item
	pickup.transform = transform  # se copia ANTES de entrar al árbol, no requiere estar en el tree
	
	get_parent().add_child.call_deferred(pickup)
	queue_free()
