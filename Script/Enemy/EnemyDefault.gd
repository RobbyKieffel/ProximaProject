extends KinematicBody2D

const ball_bullet = preload("res://Scene/Bullet/BulletBallEnemy.tscn")
const explosion_particle = preload("res://Scene/Efx/ExplosionParticle.tscn")
const trail_target = preload("res://Scene/Efx/TrailTarget.tscn")

export(int, 100, 2500) var healt = 200
export(int, 10, 500) var speed = 50
export(int, 20, 80) var destroy_demage = 30

var velocity = Vector2.ZERO
var speed_acceleration = speed
var target:Array
var curent_target:int = 0

var random = RandomNumberGenerator.new()

signal finish

func _ready():
	random.randomize()
	pass

func _physics_process(delta):
	if target.empty():
		move_local_x(-speed * delta)
		if global_position.y > 350:
			queue_free()
			get_tree().call_group("Level", "check_enemy")
		return
	move_to_target()
	velocity = move_and_slide(velocity.normalized() * speed_acceleration)

func move_to_target():
	if global_position.distance_to(target[curent_target]) > speed:
		speed_acceleration = speed
	else:
		speed_acceleration = global_position.distance_to(target[curent_target])
		if global_position.distance_to(target[curent_target]) < 5:
			emit_signal("finish")
	if not target.empty():
		velocity = global_position.direction_to(target[curent_target])

func hurt(demage):
	$Sprite.get_path()
	healt -= demage
	if healt <= 0:
		var a = explosion_particle.instance()
		a.global_position = global_position
		get_tree().get_nodes_in_group("Level")[0].add_child(a)
		drop_exp()
		queue_free()
#		if get_tree().has_group('Level'):
#			get_tree().call_group("Level", "check_enemy")
#		else:
#			print('tree doesn`t have "Level" group')

func drop_exp():
	var a
	if is_in_group("BasicEnemy"):
		a = trail_target.instance()
		a.trail_target = Vector2(25, 25)
		if get_tree().has_group("HUD"):
			if get_tree().get_nodes_in_group('HUD'):
				a.rect_global_position = get_global_transform_with_canvas().origin
				get_tree().get_nodes_in_group("HUD")[0].add_child(a)
			else:
				print('"HUD" group doesn`t heve "MainContainer" node')
		else:
			print('tree doesn`t have "HUD" group')
	elif is_in_group("SpecialEnemy"):
		for i in 2:
			a = trail_target.instance()
			a.trail_target = Vector2(25, 25)
			if get_tree().has_group("HUD"):
				if get_tree().get_nodes_in_group('HUD'):
					var random_pos = Vector2.ZERO
					for c in 2:
						var generate_pos = random.randi_range(-30, 30)
						if c == 0:
							random_pos.x = generate_pos
						else:
							random_pos.y = generate_pos
					a.rect_global_position = get_global_transform_with_canvas().origin + random_pos
					get_tree().get_nodes_in_group("HUD")[0].add_child(a)
				else:
					print('"HUD" group doesn`t heve "MainContainer" node')
			else:
				print('tree doesn`t have "HUD" group')
	elif is_in_group("MiniBos"):
		for i in 3:
			a = trail_target.instance()
			a.trail_target = Vector2(25, 25)
			if get_tree().has_group("HUD"):
				if get_tree().get_nodes_in_group('HUD'):
					var random_pos = Vector2.ZERO
					for c in 2:
						var generate_pos = random.randi_range(-30, 30)
						if c == 0:
							random_pos.x = generate_pos
						else:
							random_pos.y = generate_pos
					a.rect_global_position = get_global_transform_with_canvas().origin + random_pos
					get_tree().get_nodes_in_group("HUD")[0].add_child(a)
				else:
					print('"HUD" group doesn`t heve "MainContainer" node')
			else:
				print('tree doesn`t have "HUD" group')
	pass

func destroy(player):
	if player.has_method("hurt"):
		player.hurt(destroy_demage)
	else:
		print('body name ',player.name, ' doesn`t have "hurt" method')
	var a = explosion_particle.instance()
	a.global_position = global_position
	if get_tree().has_group('Level'):
		get_tree().get_nodes_in_group("Level")[0].add_child(a)
		queue_free()
#		get_tree().call_group("Level", "check_enemy")
	else:
		print('tree doesn`t have "Level" group')
#	get_tree().get_nodes_in_group("Level")[0].add_child(a)
#	queue_free()
#	get_tree().call_group("Level", "check_enemy")

func shoot_type1():
	var a = ball_bullet.instance()
	a.global_position = global_position
	var cur_len = 0
	var q = false
	var player
	for i in get_tree().get_nodes_in_group("Player"):
		if q == false:
			q = true
			cur_len = (global_position - i.global_position).length()
		if (global_position - i.global_position).length() <= cur_len:
			cur_len = (global_position - i.global_position).length()
			player = i
	if player != null:
		a.global_rotation  = (global_position - player.global_position).angle()
	else:
		print("player is null")
	
#	a.global_rotation = (global_position - get_tree().get_nodes_in_group("Player")[0].global_position).angle()
	if get_tree().has_group("Level"):
		get_tree().get_nodes_in_group("Level")[0].add_child(a)
	else:
		print('tree does not have "LEVEL" group')

func shoot_type2():
	for i in 2:
		var a = ball_bullet.instance()
		a.global_position = global_position
		if i == 0:
			a.global_rotation_degrees = global_rotation_degrees + 45
		else:
			a.global_rotation_degrees = global_rotation_degrees - 45
		if get_tree().has_group("Level"):
			get_tree().get_nodes_in_group("Level")[0].add_child(a)
		else:
			print('tree doesn`t have "Level" group')

func shoot_type3():
	var c = 1
	for i in 3:
		var a = ball_bullet.instance()
		a.global_position = global_position
		a.global_rotation_degrees = (global_rotation_degrees - 60) + ((90 / 3) * c)
		c += 1
		if get_tree().has_group("Level"):
			get_tree().get_nodes_in_group("Level")[0].add_child(a)
		else:
			print('tree doesn`t have "Level" group')

func _on_VisibilityNotifier2D_screen_exited():
	if has_node("CollisionPolygon2D"):
		get_node("CollisionPolygon2D").disabled = true


func _on_VisibilityNotifier2D_screen_entered():
	if has_node("CollisionPolygon2D"):
		get_node("CollisionPolygon2D").disabled = false
	else:
		print(name, ' can`t found "CollisionPolygon2D" node')
