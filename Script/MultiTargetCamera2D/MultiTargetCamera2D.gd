extends Camera2D

class_name MTCamera2D

export var zoom_speed:float = 0.05
export var move_speed:float = 0.5
export var max_zoom:float  = 3
export var min_zoom:float = 1
export var min_zoom_single_target:float = 1
export var margin:Vector2
export var target_group:String

var shake_amount = 0
var shake_time = 0

var random = RandomNumberGenerator.new()

var targets

func _ready():
	random.randomize()
	if target_group != "":
		targets = get_tree().get_nodes_in_group(target_group)
	else:
		print('please enter "Target Group" tap')

#func _process(delta):

func _physics_process(delta):
	get_target_and_generate_pos_zoom()
	
	if shake_amount != 0:
	
		shake_time -= 1
		if shake_time > 0:
			offset = Vector2(random.randf_range(-1, 1) * shake_amount, random.randf_range(-1, 1) *shake_amount)
		else:
			shake_amount = 0
			shake_time = 0
			offset = Vector2.ZERO
	

func get_target_and_generate_pos_zoom():
	if get_tree().get_nodes_in_group(target_group).empty():
		return
	
	targets = get_tree().get_nodes_in_group(target_group)
	var center_pos = Vector2.ZERO
	for target in targets:
		center_pos += target.global_position
	center_pos /= targets.size()
	global_position = lerp(global_position, center_pos, move_speed)
	
	var r = Rect2(global_position, Vector2.ONE)
	for target in targets:
		r = 	r.expand(target.global_position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var d = max(r.size.x,r.size.y)
	var z
	if r.size.x > r.size.y * get_viewport_rect().size.aspect():
		z = clamp(r.size.x / get_viewport_rect().size.x, min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / get_viewport_rect().size.y, min_zoom, max_zoom)

	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)
	if targets.size() == 1:
		zoom = Vector2(max(zoom.x, min_zoom_single_target), max(zoom.y, min_zoom_single_target))

func shake_camera(value, time):
	if not StageInfo.screen_shake:
		return
	shake_amount = value
	shake_time = time


