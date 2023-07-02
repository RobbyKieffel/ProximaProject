extends "res://Script/Enemy/EnemyDefault.gd"

onready var wait_to_action = $WaitToAction

var is_action1 = false
var target_angle:float

func _ready():
	connect("finish", self, "action_1")

func _physics_process(delta):
	if target.empty():
		return
	if is_action1:
		global_rotation = lerp_angle(global_rotation, target_angle, 0.1)

func action_1():
	disconnect("finish", self, "action_1")
	is_action1 = true
	var cur_len = 0
	var q = false
	var player
	for i in get_tree().get_nodes_in_group("Player"):
		if q == false:
			q = true
			cur_len = (global_position - i.global_position).length()
		if (global_position - i.global_position).length() <= cur_len:
			cur_len = (global_position - i.global_position).length()
			player = i
	if player != null:
		target_angle = (global_position - player.global_position).angle()
	else:
		print("player is null")
	wait_to_action.connect("timeout", self, "action_2")
	wait_to_action.start(2)

func action_2():
	wait_to_action.disconnect("timeout", self, "action_2")
	wait_to_action.connect("timeout", self, "shoot_type2")
	speed = 400
	wait_to_action.wait_time = 0.2
	wait_to_action.one_shot = false
	wait_to_action.start()
	target.clear()
	pass
