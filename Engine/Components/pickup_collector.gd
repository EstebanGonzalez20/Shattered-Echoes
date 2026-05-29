## Este componente representa el radio en el cual una entidad recolecta pickups
class_name PickupCollector extends NodeComponent

signal pickup_entered(pickup_node: Node3D)

@export var radius: float = 24.0: set = _set_radius

var _area: Area3D
var _shape: SphereShape3D

func _ready() -> void:
	_build_area()

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

func _on_body_entered(body: Node3D) -> void:
	# El componente solo notifica, no decide qué hacer
	pickup_entered.emit(body)

func _set_radius(new_value: float) -> void:
	radius = maxf(new_value, 0.0)
	if _shape:
		_shape.radius = radius
