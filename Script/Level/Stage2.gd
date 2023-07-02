extends "res://Script/Level/StageDefault.gd"

const enemy_bos2 = preload("res://Scene/Enemy/EnemyBos2.tscn")
const enemy_basic2 = preload("res://Scene/Enemy/EnemyBasic2.tscn")
const enemy_ship4 = preload("res://Scene/Enemy/EnemyShip4.tscn")
const enemy_ship5 = preload("res://Scene/Enemy/EnemyShip5.tscn")
const enemy_ship6 = preload("res://Scene/Enemy/EnemyShip6.tscn")
const enemy_ship_mini_bos1 = preload("res://Scene/Enemy/EnemyMiniBos1.tscn")

const bgm_normal = preload("res://Asset/Audio/Bgm/Juhani Junkala [Retro Game Music Pack] Level 1.ogg")
const bgm_boss = preload("res://Asset/Audio/Bgm/Juhani Junkala [Retro Game Music Pack] Level 3.ogg")

const spawn_pos_enemy_ship4 = [Vector2(-20,-150), Vector2(500,-150), Vector2(80,-150), Vector2(400,-150), 
Vector2(180,-150), Vector2(300,-150)]

const spawn_pos_enemy_ship5 = [Vector2(0,-150), Vector2(480,-150), Vector2(160,-150), Vector2(320,-150)]

const spawn_pos_enemy_ship6 = [Vector2(50,-150), Vector2(430,-150), Vector2(150,-150), Vector2(330,-150)]

const spawn_pos_enemy_mini_bos1= [Vector2(100,-150), Vector2(380,-150)]


func _ready():
	if StageInfo.level == 5:
		var a = enemy_bos2.instance()
		add_child(a)
		$AudioStreamPlayer.stream = bgm_boss
	else:
		$AudioStreamPlayer.stream = bgm_normal
	$AudioStreamPlayer.play()
	pass

func _process(delta):
	if $Background2.region_rect.position.y > -350:
		$Background2.region_rect.position.y -= 30 * delta
	else:
		$Background2.region_rect.position.y = 0
	if $Background3.region_rect.position.y > -350:
		$Background3.region_rect.position.y -= 60 * delta
	else:
		$Background3.region_rect.position.y = 0

func spawn_enemy_ship4():
	var q = 0
	for i in spawn_pos_enemy_ship4.size()*0.5:
		for o in 2:
			var a = enemy_ship4.instance()
#			if i == 0:
			a.position = spawn_pos_enemy_ship4[q]
			a.rotation_degrees = -90
#			a.target.append(Vector2(spawn_pos_enemy_ship1[q].x, 70))
			add_child(a)
			q += 1
		yield(get_tree().create_timer(0.5), "timeout")

func spawn_enemy_ship5():
	var q = 0
	for i in spawn_pos_enemy_ship5.size()*0.5:
		for o in 2:
			var a = enemy_ship5.instance()
			a.position = spawn_pos_enemy_ship5[q]
			a.rotation_degrees = -90
			a.target.append(Vector2(spawn_pos_enemy_ship5[q].x, 80))
			add_child(a)
			q += 1
		yield(get_tree().create_timer(1), "timeout")

func spawn_enemy_ship6():
	var q = 0
	for i in spawn_pos_enemy_ship6.size()*0.5:
		for o in 2:
			var a = enemy_ship6.instance()
			a.position = spawn_pos_enemy_ship6[q]
			a.target.append(Vector2(spawn_pos_enemy_ship6[q].x, 80))
			a.rotation_degrees = -90
			add_child(a)
			q += 1
		yield(get_tree().create_timer(1), "timeout")

func spawn_enemy_ship_mini_bos1():
	var q = 0
	for i in spawn_pos_enemy_mini_bos1.size():
#		for o in 2:
		var a = enemy_ship_mini_bos1.instance()
		a.position = spawn_pos_enemy_mini_bos1[q]
		a.rotation_degrees = -90
		a.target.append(Vector2(spawn_pos_enemy_mini_bos1[q].x, 100))
		add_child(a)
		q += 1
#		yield(get_tree().create_timer(1), "timeout")

func _on_BasicEnemySpawnTimer_timeout():
	var a = enemy_basic2.instance()
	a.rotation_degrees = -90
	var random_spawn_pos_x = random.randi_range(0, 480)
	a.position = Vector2(random_spawn_pos_x, spawn_pos_y)
	add_child(a)
	pass # Replace with function body.


func _on_SpecialEnemySpawnTimer_timeout():
	var chose_another = true
	while chose_another:
		var random_enemy = random.randi_range(1, 4)
		if random_enemy == 1:
			spawn_enemy_ship4()
			chose_another = false
		elif random_enemy == 2:
				if get_tree().get_nodes_in_group("EnemyShip5").empty():
					spawn_enemy_ship5()
					chose_another = false
		elif random_enemy == 3:
			spawn_enemy_ship6()
			chose_another = false
		else:
			if get_tree().get_nodes_in_group("MiniBos").empty():
				spawn_enemy_ship_mini_bos1()
				chose_another = false
	pass # Replace with function body.
