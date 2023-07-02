class_name PathFollow2DTarget extends PathFollow2D

export(Array, float, 1) var target #Set Target to know where the path will stop, it will get value form Offset

export(float, 3600) var wait_time #if Unit_Offset equal target it self will wait and after the time over it will continue go to the next target

export(float, 1) var move_speed

export var enable:bool# setget set_enable

var curent_path = 0
var stop = false
var timer_obj = Timer.new()
var looping = false

func _ready():
	if loop:
		looping = true
	loop = false
	timer_obj.wait_time = wait_time
	timer_obj.one_shot = true
	timer_obj.connect("timeout", self, "timeout")
	add_child(timer_obj)
	target.append(1)
	pass

func _physics_process(delta):
	print(curent_path)
#	print(target, " ", curent_path, " and ", target[curent_path], " ", target.size())
	if not enable:
		return
	
#	if not stop:
	if unit_offset < target[curent_path]:
		unit_offset += move_speed*delta
		if unit_offset == 1 and looping:
			unit_offset = 0
			curent_path = 0
	else:
		if unit_offset < 1:
			if timer_obj.time_left == 0:
				timer_obj.start()

func timeout():
	if curent_path < target.size() - 1:
		curent_path += 1
	else:
		curent_path = 0
		unit_offset = 0
#	wait = false
	print("timeout")
	pass


#func set_enable(value) -> void:
#	pause_mode = Node.PAUSE_MODE_STOP
#	pass
