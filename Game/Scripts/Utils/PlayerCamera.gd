extends Camera3D

var _currently_hovered: ItemPickup = null

func _process(_delta: float) -> void:
	var hovered := get_hovered_item_pickup()

	if hovered != _currently_hovered:
		print("hola")
		if _currently_hovered != null:
			_currently_hovered.set_mouse_hover(false)
		if hovered != null:
			hovered.set_mouse_hover(true)
		_currently_hovered = hovered

func get_hovered_item_pickup() -> ItemPickup:
	var mouse_pos := get_viewport().get_mouse_position() ## Esta variable almacena la posición del mouse.
	var ray_origin := project_ray_origin(mouse_pos) ## Poscición desde la que se dispara el ray.
	var ray_direction := project_ray_normal(mouse_pos) ## Dirección que sigue el ray.
	var ray_length := 1000.0  ## Longitud del ray.
	var ray_end := ray_origin + ray_direction * ray_length ## Punto final del ray.
	
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = Globals.CollisionLayers.PICKUPS  # ajustar al bit de capa donde están los ItemPickup
	query.collide_with_areas = true   # Permite al raycast interactuar con Area3D
	query.collide_with_bodies = false # Evita chocar contra el jugador/paredes acá
	
	var space_state := get_world_3d().direct_space_state
	var result := space_state.intersect_ray(query)
	
	if result.is_empty():
		return null
	var collider: Node = result.collider
	var pickup := collider.get_owner() as ItemPickup

	if pickup != null:
		return pickup
	return null
