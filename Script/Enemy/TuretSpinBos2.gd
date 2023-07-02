extends KinematicBody2D

const bullet = preload("res://Scene/Bullet/BulletBallEnemy.tscn")
const special_bullet = preload("res://Scene/Bullet/BulletBallSpecialEnemy.tscn")

export var max_healt = 12000
var healt = 12000
var ready = false
var half_healt = false

signal death
signal half_healt

func _ready():
	healt = max_healt

func _physics_process(delta):
#	print($CollisionPolygon2D.disabled)
	if not ready:
		return
	rotation_degrees += 50 * delta

func hurt(demage):
	healt -= demage
	if healt <= 0:
		emit_signal("death")
		queue_free()
	if healt <= max_healt/2 and half_healt == false:
		$ShootTimer.stop()
		$ShootTimer.wait_time = 4
		$CollisionPolygon2D.set_deferred("disabled", true)
		ready = false
		half_healt = true
		emit_signal("half_healt")

func _on_ShootTimer_timeout():
	for i in 4:
		var a
		if not half_healt:
			a = bullet.instance()
		else:
			a = special_bullet.instance()
		if i == 0:
			a.global_position = $Muzzle1.global_position
			a.global_rotation = $Muzzle1.global_rotation
		elif i == 1:
			a.global_position = $Muzzle2.global_position
			a.global_rotation = $Muzzle2.global_rotation
		elif i == 2:
			a.global_position = $Muzzle3.global_position
			a.global_rotation = $Muzzle3.global_rotation
		else:
			a.global_position = $Muzzle4.global_position
			a.global_rotation = $Muzzle4.global_rotation
		if get_tree().has_group("Level"):
			get_tree().get_nodes_in_group("Level")[0].add_child(a)
