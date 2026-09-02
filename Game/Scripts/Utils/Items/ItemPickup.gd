class_name ItemPickup
extends Node3D

## El recurso del objeto que contiene el ItemPickup.
@export var item: Item
## Modelo (por ahora un sprite) que representa al objeto en el mundo.
@onready var visual: Sprite3D = $Sprite3D
## Area que detecta colisión con otras entidades.
@onready var _detection_area: Area3D = $DetectionArea
## Area que detecta al jugador para mostrar o no el tooltip.
@onready var _tooltip_area: Area3D = $TooltipArea

## Flag que verifica la proximidad del usuario para mostrar el tooltip.
var _player_nearby: bool = false
## Flag que verifica el hover del mouse para mostrar el tooltip.
var _mouse_hovering: bool = false

func _ready() -> void:
	_spawn_visual()
	_detection_area.body_entered.connect(_on_body_entered)
	_tooltip_area.body_entered.connect(_on_player_entered)
	_tooltip_area.body_exited.connect(_on_player_exited)
	_tooltip_area.input_ray_pickable = true

func _spawn_visual() -> void:
	if item == null:
		push_warning("ItemPickup sin item asignado: %s" % name)
		return
	
	if item.pickup_model != null:
		# Modelo 3D completo: se instancia aparte y se oculta el sprite fijo
		visual.hide()
		var model: Node3D = item.pickup_model.instantiate()
		add_child(model)
	elif item.pickup_texture != null:
		# Sprite simple: se usa el Sprite3D que ya trae la escena
		visual.texture = item.pickup_texture
		visual.scale.x *= 3
		visual.scale.y *= 3
		visual.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST 
	else:
		push_warning("Item '%s' no tiene pickup_texture ni pickup_model asignado" % item.id)

func _on_body_entered(body: Node3D) -> void:
	# Duck typing: cualquier cosa con un Inventory accesible puede recoger.
	# Evita acoplar el pickup a una clase Player concreta.
	if body.has_node("EntityComponent"):
		var entity : EntityComponent = body.get_node("EntityComponent")
		if not entity.has_component(&"Inventory"):
			return
		
		var inventory: Inventory = entity.get_component(&"Inventory")
		inventory.add_passive_item(item)
		queue_free()

func _on_player_entered(body: Node3D) -> void:
	if body.has_node("Inventory"):
		_player_nearby = true
		_update_tooltip()

func _on_player_exited(body: Node3D) -> void:
	if body.has_node("Inventory"):
		_player_nearby = false
		_update_tooltip()

func set_mouse_hover(is_hovering: bool) -> void:
	print("1")
	_mouse_hovering = is_hovering
	_update_tooltip()

func _update_tooltip() -> void:
	if _player_nearby and _mouse_hovering:
		ItemTooltip.show_for(item)
	else:
		ItemTooltip.hide_tooltip()

func _exit_tree() -> void:
	# si el pickup se destruye (lo recogen) mientras el tooltip lo muestra,
	# hay que esconderlo explícitamente o queda pegado en pantalla
	if _mouse_hovering and _player_nearby:
		ItemTooltip.hide_tooltip()
