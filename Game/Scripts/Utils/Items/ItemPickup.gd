class_name ItemPickup
extends Node3D

## El recurso del objeto que contiene el ItemPickup.
@export var item: Item
## Modelo (por ahora un sprite) que representa al objeto en el mundo.
@onready var visual: Sprite3D = $Sprite3D
## Area que detecta colisión con otras entidades.
@onready var _detection_area: Area3D = $DetectionArea

func _ready() -> void:
	_spawn_visual()
	_detection_area.body_entered.connect(_on_body_entered)

func _spawn_visual() -> void:
	if item == null or item.sprite == null:
		push_warning("ItemPickup sin item o sin pickup_model asignado: %s" % name)
		return
	
	var visual: Sprite3D = item.sprite.instantiate()

func _on_body_entered(body: Node3D) -> void:
	# Duck typing: cualquier cosa con un Inventory accesible puede recoger.
	# Evita acoplar el pickup a una clase Player concreta.
	var entity : EntityComponent = body.get_node("EntityComponent")
	if not entity.has_component(&"Inventory"):
		return
	
	var inventory: Inventory = entity.get_component(&"Inventory")
	inventory.add_passive_item(item)
	queue_free()
