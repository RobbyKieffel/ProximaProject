extends "res://Script/Level/StageDefault.gd"

const enemy_bos1 = preload("res://Scene/Enemy/EnemyBos1.tscn")
const enemy_basic1 = preload("res://Scene/Enemy/EnemyBasic1.tscn")
const enemy_ship1 = preload("res://Scene/Enemy/EnemyShip1.tscn")
const enemy_ship2 = preload("res://Scene/Enemy/EnemyShip2.tscn")
const enemy_ship3 = preload("res://Scene/Enemy/EnemyShip3.tscn")

const bgm_normal = preload("res://Asset/Audio/Bgm/Juhani Junkala [Retro Game Music Pack] Level 1.ogg")
const bgm_boss = preload("res://Asset/Audio/Bgm/Juhani Junkala [Retro Game Music Pack] Level 3.ogg")

const spawn_pos_enemy_ship1 = [Vector2(-20,-150), Vector2(500,-150), Vector2(80,-150), Vector2(400,-150), 
Vector2(180,-150), Vector2(300,-150)]

const spawn_pos_enemy_ship2 = [Vector2(50,-150), Vector2(430,-150), Vector2(150,-150), Vector2(330,-150)]

const spawn_pos_enemy_ship3 = [Vector2(0,-150), Vector2(480,-150), Vector2(160,-150), Vector2(320,-150)]

func _ready():
	if StageInfo.level == 5:
		var a = enemy_bos1.instance()
		add_child(a)
		$AudioStreamPlayer.stream = bgm_boss
	else:
		$AudioStreamPlayer.stream = bgm_normal
	$AudioStreamPlayer.play()
	

func _process(delta):
	if $Background2.region_rect.position.y > -350:
		$Background2.region_rect.position.y -= 30 * delta
	else:
		$Background2.region_rect.position.y = 0
	if $Background3.region_rect.position.y > -350:
		$Background3.region_rect.position.y -= 60 * delta
	else:
		$Background3.region_rect.position.y = 0

func spawn_enemy_ship1():
	var q = 0
	for i in spawn_pos_enemy_ship1.size()*0.5:
		for o in 2:
			var a = enemy_ship1.instance()
#			if i == 0:
			a.position = spawn_pos_enemy_ship1[q]
			a.rotation_degrees = -90
			a.target.append(Vector2(spawn_pos_enemy_ship1[q].x, 70))
			add_child(a)
			q += 1
		yield(get_tree().create_timer(0.5), "timeout")

func spawn_enemy_ship2():
	var q = 0
	for i in spawn_pos_enemy_ship2.size()*0.5:
		for o in 2:
			var a = enemy_ship2.instance()
			a.position = spawn_pos_enemy_ship2[q]
			a.rotation_degrees = -90
			a.target.append(Vector2(spawn_pos_enemy_ship2[q].x, 130))
			add_child(a)
			q += 1
		yield(get_tree().create_timer(1), "timeout")

func spawn_enemy_ship3():
	var q = 0
	for i in spawn_pos_enemy_ship3.size()*0.5:
		for o in 2:
			var a = enemy_ship3.instance()
			a.position = spawn_pos_enemy_ship3[q]
#			a.target.append(Vector2(spawn_pos_enemy_ship3[q].x, - 150))
			a.rotation_degrees = -90
			add_child(a)
			q += 1
		yield(get_tree().create_timer(1), "timeout")

func _on_BasicEnemySpawnTimer_timeout():
	var a = enemy_basic1.instance()
	a.rotation_degrees = -90
	var random_spawn_pos_x = random.randi_range(0, 480)
	a.position = Vector2(random_spawn_pos_x, spawn_pos_y)
	add_child(a)
	pass # Replace with function body.


func _on_SpecialEnemySpawnTimer_timeout():
	var random_enemy = random.randi_range(1, 3)
	if random_enemy == 1:
		spawn_enemy_ship1()
	elif random_enemy == 2:
		spawn_enemy_ship2()
	else:
		spawn_enemy_ship3()
	pass # Replace with function body.
