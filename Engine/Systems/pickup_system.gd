# pickup_system.gd
class_name PickupSystem extends Node

# Si tu arquitectura tiene un EventBus para entidades nuevas, úsalo aquí
func on_entity_added(entity: Node) -> void:
	if entity.has_component(PickupCollector):
		_register_collector(entity)

func _register_collector(entity: Node) -> void:
	var collector: PickupCollector = entity.get_component(PickupCollector)
	# Conectamos la señal del componente al sistema
	collector.pickup_entered.connect(_on_pickup_entered.bind(entity))

func _on_pickup_entered(pickup_node: Node3D, collector_entity: Node) -> void:
	var pickup: Pickup = pickup_node.get_component(Pickup)
	if not pickup or pickup.is_collected:
		return
	
	pickup.is_collected = true
	
	match pickup.type:
		Pickup.PickupType.HEAL:
			var health = collector_entity.get_component(Health)
			if health:
				health.heal(pickup.amount)
				
		Pickup.PickupType.COIN:
			var wallet = collector_entity.get_component(Wallet)
			if wallet:
				wallet.gain(pickup.amount)
	
	pickup_node.queue_free()
