extends Node3D
@onready var light: OmniLight3D = $OmniLight3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		queue_free()
		print("+1")
