extends "res://Script/Bullet/BulletDefault.gd"

const explode_scene = preload("res://Scene/Efx/ExplosionParticle.tscn")

const bullet = preload("res://Scene/Bullet/BulletBallEnemy.tscn")
var bullet_count = 20

var bullet_array:Array

func _ready():
	for i in bullet_count:
		var a = bullet.instance()
		bullet_array.append(a)
	$Sprite.global_rotation = 0
	attack = 60

func _process(delta):
	scale.x += 0.5 * delta
	scale.y += 0.5 * delta
	if speed < 20:
		return
	speed -= 0.1

func instance_particle(particle_instance:Particles2D):
	queue_free()
	var b = explode_scene.instance()
	b.global_position = global_position
	if get_tree().has_group("Level"):
		get_tree().get_nodes_in_group("Level")[0].add_child(b)
	else:
		print('tree doesn`t have "Level" group')
	
	if travel < max_travel - 3:
		return
	var c = 0
	for i in bullet_array:
		c += 1
		i.global_position = global_position
		i.global_rotation_degrees = 360 / bullet_count * c
		if get_tree().has_group("Level"):
			get_tree().get_nodes_in_group("Level")[0].add_child(i)
		else:
			print('tree doesn`t have "Level" group')
	
	

