extends Node2D

const enemy_basic1 = preload("res://Scene/Enemy/EnemyBasic1.tscn")
const enemy_ship1 = preload("res://Scene/Enemy/EnemyShip1.tscn")
const enemy_ship2 = preload("res://Scene/Enemy/EnemyShip2.tscn")
const enemy_ship3 = preload("res://Scene/Enemy/EnemyShip3.tscn")
const enemy_basic2 = preload("res://Scene/Enemy/EnemyBasic2.tscn")
const enemy_ship4 = preload("res://Scene/Enemy/EnemyShip4.tscn")
const enemy_ship5 = preload("res://Scene/Enemy/EnemyShip5.tscn")
const enemy_ship6 = preload("res://Scene/Enemy/EnemyShip6.tscn")
const enemy_ship_mini_bos1 = preload("res://Scene/Enemy/EnemyMiniBos1.tscn")


const spawn_pos_enemy_ship1 = [Vector2(-20,350), Vector2(500,350), Vector2(80,350), Vector2(400,350), 
Vector2(180,350), Vector2(300,350)]

const spawn_pos_enemy_ship2 = [Vector2(50,-150), Vector2(430,-150), Vector2(150,-150), Vector2(330,-150)]

const spawn_pos_enemy_ship3 = [Vector2(0,350), Vector2(480,350), Vector2(160,350), Vector2(320,350)]

const spawn_pos_enemy_ship4 = [Vector2(-20,-150), Vector2(500,-150), Vector2(80,-150), Vector2(400,-150), 
Vector2(180,-150), Vector2(300,-150)]

const spawn_pos_enemy_ship5 = [Vector2(0,-150), Vector2(480,-150), Vector2(160,-150), Vector2(320,-150)]

const spawn_pos_enemy_ship6 = [Vector2(50,-150), Vector2(430,-150), Vector2(150,-150), Vector2(330,-150)]

const spawn_pos_enemy_mini_bos1= [Vector2(100,-150), Vector2(380,-150)]


var random = RandomNumberGenerator.new()
const spawn_pos_y = -150

var stage_time_out = false


func _ready():
	StageInfo.player1 = $PlayerShipDBFR
	StageInfo.player2 = $PlayerShipShield
	$HUD.set_hp()
	$HUD.set_skill_CD_pos()
	random.randomize()

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

func spawn_enemy_ship2():
	var q = 0
	for i in spawn_pos_enemy_ship2.size()*0.5:
		for o in 2:
			var a = enemy_ship2.instance()
			a.position = spawn_pos_enemy_ship2[q]
			a.rotation_degrees = -90
			a.target.append(Vector2(spawn_pos_enemy_ship2[q].x, spawn_pos_enemy_ship2[q].y + 200))
			add_child(a)
			q += 1
		yield(get_tree().create_timer(1), "timeout")

func spawn_enemy_ship3():
	var q = 0
	for i in spawn_pos_enemy_ship3.size()*0.5:
		for o in 2:
			var a = enemy_ship3.instance()
			a.position = spawn_pos_enemy_ship3[q]
			a.target.append(Vector2(spawn_pos_enemy_ship3[q].x, - 150))
			add_child(a)
			q += 1
		yield(get_tree().create_timer(1), "timeout")

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

func _on_Timer_timeout():
	var random_enemy = random.randi_range(1, 3)
	var a = enemy_basic1.instance()
	a.rotation_degrees = -90
	var random_spawn_pos_x = random.randi_range(0, 480)
	a.position = Vector2(random_spawn_pos_x, spawn_pos_y)
	add_child(a)
	pass # Replace with function body.
