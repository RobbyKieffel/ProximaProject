extends Particles2D

func _ready():
	emitting = true
	one_shot = true


func _on_Timer_timeout():
	queue_free()
