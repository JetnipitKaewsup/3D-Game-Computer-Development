extends MeshInstance3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Gamemanager.collected_positions.append(global_transform.origin)
		queue_free()
		print("+1")
