extends Control

export var trail_target:Vector2 = Vector2.ZERO
var speed = 0.1

var finish = true

func _process(delta):
	if (rect_global_position - trail_target).length() > 5:
		rect_global_position = lerp(rect_global_position, trail_target, speed)
	else:
		if finish:
			finish = false
			get_tree().get_nodes_in_group("HUD")[0].add_exp()
			$Timer.start()


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
