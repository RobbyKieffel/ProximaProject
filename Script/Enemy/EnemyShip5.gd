extends "res://Script/Enemy/EnemyDefault.gd"

onready var wait_to_action = $WaitToAction

var next_target:Array

func _ready():
	connect("finish", self, "action_1")
	pass

func action_1():
	$AnimationPlayer.play("TurretPopUp")
	$WaitToAction2.start()
	disconnect("finish", self, "action_1")
	pass


func _on_WaitToAction2_timeout():
	target.clear()
	pass # Replace with function body.
