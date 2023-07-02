extends Particles2D


func _ready():
	if get_tree().has_group("Camera"):
		get_tree().get_nodes_in_group("Camera")[0].shake_camera(2, 15)
	$Particles2D.emitting = true
	emitting = true


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
