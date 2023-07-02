extends "res://Script/Enemy/EnemyDefault.gd"

onready var wait_to_action = $WaitToAction

var next_target:Array

func _ready():
	connect("finish", self, "action_1")
	pass

func action_1():
	shoot_type3()
	wait_to_action.connect("timeout", self, "shoot_type3")
	wait_to_action.wait_time = 1
	wait_to_action.one_shot = false
	wait_to_action.start()
	$WaitToAction2.start()
	disconnect("finish", self, "action_1")
	pass

func _on_WaitToAction2_timeout():
	target.clear()
	wait_to_action.wait_time = 0.5
	speed = 200
	pass # Replace with function body.
