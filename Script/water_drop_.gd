extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Gamemanager.collected_positions.append(global_transform.origin)
		Gamemanager.update_score(1)
		queue_free()
		
