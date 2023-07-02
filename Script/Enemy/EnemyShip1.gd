extends "res://Script/Enemy/EnemyDefault.gd"

onready var wait_to_action = $WaitToAction

var next_target:Array

func _ready():
	connect("finish", self, "action_1")
	pass

func action_1():
	wait_to_action.connect("timeout", self, "action_2")
	wait_to_action.start(0.5)
	disconnect("finish", self, "action_1")
	pass

func action_2():
	shoot_type1()
	wait_to_action.disconnect("timeout", self, "action_2")
	wait_to_action.connect("timeout", self, "action_3")
	wait_to_action.start(0.5)
	pass

func action_3():
	wait_to_action.disconnect("timeout", self, "action_3")
	wait_to_action.connect("timeout", self, "shoot_type1")
	wait_to_action.wait_time = 0.5
	wait_to_action.one_shot = false
	wait_to_action.start()
	speed = 200
	target.clear()
