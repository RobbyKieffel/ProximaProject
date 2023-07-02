extends KinematicBody2D

const bullet = preload("res://Scene/Bullet/BulletBallEnemy.tscn")

export var healt = 2000

signal death

func hurt(demage):
	healt -= demage
	if healt <= 0:
		emit_signal("death")
		queue_free()

func _on_ShootTimer_timeout():
	var a = bullet.instance()
	a.global_position = $Muzzle.global_position
	a.global_rotation = $Muzzle.global_rotation
	get_parent().get_parent().add_child(a)
	pass # Replace with function body.
