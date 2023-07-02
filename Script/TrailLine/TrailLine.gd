extends Line2D

class_name TrailLine

var target
export (NodePath) var target_path
var point = Vector2.ZERO
export var trail_lenght = 10

func _ready():
	target = get_node(target_path)
	pass


func _process(delta):
#	global_position = Vector2.ZERO
#	global_rotation = 0
#	point = target.global_position
	add_point(Vector2.ZERO)
	print(points)
	while get_point_count() > trail_lenght:
		remove_point(0)
