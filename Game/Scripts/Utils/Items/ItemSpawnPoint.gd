# engine/inventory/item_spawn_point.gd
class_name ItemSpawnPoint
extends Node3D

@export var pool: ItemPool

const ITEM_PICKUP_SCENE: PackedScene = preload("res://Game/scenes/Utils/ItemPickup.tscn")

func spawn() -> void:
	if pool == null:
		push_warning("ItemSpawnPoint sin pool asignado: %s" % name)
		return
	
	var chosen_item := pool.pick_random()
	if chosen_item == null:
		return
	
	var pickup: ItemPickup = ITEM_PICKUP_SCENE.instantiate()
	pickup.item = chosen_item  # se asigna ANTES de entrar al árbol
	get_parent().add_child(pickup)
	pickup.global_position = global_position
	
	queue_free()  # el marcador se reemplaza por el pickup real
