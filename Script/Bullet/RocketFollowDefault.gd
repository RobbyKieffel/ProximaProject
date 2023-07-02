extends Area2D

const explosion_particle = preload("res://Scene/Efx/ExplosionParticle.tscn")

export(int, 20, 200) var move_speed = 120
export(int, 50, 300) var max_distance = 200
export(int, 50, 200) var attack = 100

var distance = 0

var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	pass

func _physics_process(delta):
	distance += 1
	if distance > max_distance:
		instance_particle()
		queue_free()
		return
	move_local_y(-move_speed*delta)
#	var random_plus = random.randi_range(0,20)
	global_rotation_degrees = lerp_angle(global_rotation_degrees, (global_rotation_degrees + 5) * random.randi_range(-120, 120), 2)

func instance_particle():
	if $VisibilityNotifier2D.is_on_screen():
		var a = explosion_particle.instance()
		a.global_position = global_position
		get_tree().get_nodes_in_group("Level")[0].add_child(a)
		queue_free()
	pass


func _on_RocketFollow_body_entered(body):
	if body.has_method("hurt"):
		body.hurt(attack)
		instance_particle()
		queue_free()
