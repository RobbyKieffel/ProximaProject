extends Area2D

const bullet_particle = preload("res://Scene/Efx/BulletParticle.tscn")

export(int, 50, 500) var speed = 300
export(int, 10, 1000) var max_travel = 100
var attack:int = 20
var travel:int = 0

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	travel += 1
	if travel > max_travel:
		instance_particle(bullet_particle.instance())
	move_local_x(-speed * delta)

func _on_Bullet_body_entered(body):
	if body.has_method("hurt"):
		body.hurt(attack)
	else:
		print("body name ", body.name, ' doesn`t have "hurt" method')
	instance_particle(bullet_particle.instance())

func instance_particle(particle_instance:Particles2D):
	queue_free()
	pass
