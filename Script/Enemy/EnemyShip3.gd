extends "res://Script/Enemy/EnemyDefault.gd"

onready var wait_to_action = $WaitToAction

func _ready():
	shoot_type2()
	wait_to_action.connect("timeout", self, "shoot_type2")
	wait_to_action.wait_time = 0.8
	wait_to_action.one_shot = false
	wait_to_action.start()
