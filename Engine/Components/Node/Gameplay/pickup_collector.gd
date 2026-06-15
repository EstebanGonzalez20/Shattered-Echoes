## Este componente representa el radio en el cual una entidad recolecta pickups
class_name PickupCollector extends NodeComponent

func get_type() -> StringName:
	return &"PickupCollector"

## Señal emitida cuando un pickup entra en el rango
signal pickup_entered(pickup_node: Node3D)

@export var radius: float = 24.0:
	set(value):
		radius = maxf(value, 0.0)
		if _shape:
			_shape.radius = radius

var _area: Area3D
var _shape: SphereShape3D

func _ready() -> void:
	_build_area()

## Construye el area de detección
func _build_area() -> void:
	_area = Area3D.new()
	_area.name = "PickupCollectionArea"
	
	# Solo detecta la capa de pickups, no todo
	_area.collision_layer = 0
	_area.collision_mask = 0 #CollisionLayers.PICKUPS  # constante tuya
	
	var col = CollisionShape3D.new()
	_shape = SphereShape3D.new()
	_shape.radius = radius
	col.shape = _shape
	
	_area.add_child(col)
	add_child(_area)
	
	_area.body_entered.connect(_on_body_entered)

## Emite pickup_entered con el cuerpo con el que hace contacto
func _on_body_entered(body: Node3D) -> void:
	pickup_entered.emit(body)
