extends "res://Script/Bullet/BulletDefault.gd"

const particle_material = preload("res://Asset/Material/BulletBallEnemy.material")

func _ready():
	$Sprite.global_rotation = 0

func _process(_delta):
	if speed < 20:
		return
	speed -= 0.1

func instance_particle(particle_instance:Particles2D):
#	get_tree().get_nodes_in_group("Level")[0].check_enemy()
	queue_free()
	if not $VisibilityNotifier2D.is_on_screen():
		return
	particle_instance.global_position = global_position
	particle_instance.process_material = particle_material
	if get_tree().has_group("Level"):
		get_tree().get_nodes_in_group("Level")[0].add_child(particle_instance)
	else:
		print('tree doesn`t have "Level" group')
#	queue_free()

