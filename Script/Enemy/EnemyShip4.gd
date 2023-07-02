extends "res://Script/Enemy/EnemyDefault.gd"

onready var wait_to_action = $WaitToAction

func _ready():
	shoot_type1()
	wait_to_action.connect("timeout", self, "shoot_type1")
	wait_to_action.wait_time = 1.5
	wait_to_action.one_shot = false
	wait_to_action.start()
