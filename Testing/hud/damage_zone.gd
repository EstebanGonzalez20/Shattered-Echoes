extends MeshInstance3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	body.entity_component.get_component("Health").take_damage(1)
	print("hola")
