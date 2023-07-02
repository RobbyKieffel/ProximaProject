extends KinematicBody2D

const explode_particle = preload("res://Scene/Efx/ExplosionParticle.tscn")
const trail_target = preload("res://Scene/Efx/TrailTarget.tscn")

var have_turet_left = true
var have_turet_right = true

var target:Array = [Vector2(235, 80), Vector2(235, -150)]
var current_target:int = 0

var current_action:int = 1
var do_action = true

var current_enemy = 1
var second_spawn = false

var random = RandomNumberGenerator.new()

func _ready():
	if StageInfo.play_co_op:
		$MediumDor/BigTuret.healt = 10000
		$SmallDorL/SmallTuretL.healt = 2500
		$SmallDorR/SmallTuretR.healt = 2500
	else:
		$MediumDor/BigTuret.healt = 7000
		$SmallDorL/SmallTuretL.healt = 1500
		$SmallDorR/SmallTuretR.healt = 1500
	if StageInfo.have_turret:
		$MediumDor/BigTuret.healt += 2000
		$SmallDorL/SmallTuretL.healt += 1000
		$SmallDorR/SmallTuretR.healt += 1000
	if StageInfo.have_rocket:
		$MediumDor/BigTuret.healt += 2000
		$SmallDorL/SmallTuretL.healt += 1000
		$SmallDorR/SmallTuretR.healt += 1000
	random.randomize()

func _physics_process(_delta):
	global_position = lerp(global_position, target[current_target], 0.01)
	if do_action:
		if (global_position - target[current_target]).length() < 5:
			action_list()

func action_list():
	if current_action == 1:
		action1()
	if current_action == 2:
		action2()
	if current_action == 3:
		action3()
	pass

func action1():
	add_to_group("Target")
	do_action = false
	$TuretPopUpAnim.play("SmallTuretPopOut")

func action2():
	do_action = false
	if get_tree().has_group("Level"):
		var level = get_tree().get_nodes_in_group("Level")[0]
		if level.has_method("spawn_enemy_ship1") and level.has_method("spawn_enemy_ship2") and level.has_method("spawn_enemy_ship3"):
			level.spawn_enemy_ship1()
			current_enemy = 2
			$Action2Timer.start()
		else:
			print('tree doesn`t have method "spawn_enemy"')
	else:
		print('tree doesn`t have "Level" group')

func action3():
	do_action = false
	add_to_group("Target")
	$TuretPopUpAnim.play("BigTuretPopUp")

func _on_SmallTuretL_death():
	var a = explode_particle.instance()
	a.position = $SmallDorL/SmallTuretL.global_position
	$SmallDorL/Particles2D.emitting = true
	$SmallDorL/Particles2D2.emitting = true
	if get_tree().has_group("Level"):
		get_tree().get_nodes_in_group("Level")[0].add_child(a)
		drop_exp(5)
	else:
		print('tree doesn`t have "Level" group')
	
	have_turet_left = false
	if have_turet_right == false:
		current_action = 2
		do_action = true
		current_target = 1
		remove_from_group("Target")

func _on_SmallTuretR_death():
	var a = explode_particle.instance()
	a.position = $SmallDorR/SmallTuretR.global_position
	$SmallDorR/Particles2D.emitting = true
	$SmallDorR/Particles2D2.emitting = true
	if get_tree().has_group("Level"):
		get_tree().get_nodes_in_group("Level")[0].add_child(a)
		drop_exp(5)
	else:
		print('tree doesn`t have "Level" group')
	
#	for i in 10:
	
	have_turet_right = false
	if have_turet_left == false:
		current_action = 2
		do_action = true
		current_target = 1
		remove_from_group("Target")

func _on_BigTuret_death():
	remove_from_group("Target")
	var a = explode_particle.instance()
	a.position = $MediumDor/BigTuret.global_position
	$MediumDor/Particles2D.emitting = true
	$MediumDor/Particles2D2.emitting = true
	if get_tree().has_group("Level"):
		get_tree().get_nodes_in_group("Level")[0].add_child(a)
		drop_exp(10)
		get_tree().get_nodes_in_group("Level")[0].stage_time_out = true
#		get_tree().get_nodes_in_group("Level")[0].stage_clear()
	else:
		print('tree doesn`t have "Level" group')

func drop_exp(loops):
	for i in loops:
		var a = trail_target.instance()
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
				get_tree().get_nodes_in_group("HUD")[0].add_child(a)
				a.rect_global_position = get_global_transform_with_canvas().origin + random_pos
			else:
				print('"HUD" group doesn`t heve "MainContainer" node')
		else:
			print('tree doesn`t have "HUD" group')
		yield(get_tree().create_timer(0.2),"timeout")

func _on_Action2Timer_timeout():
	if get_tree().has_group("Level"):
		var level = get_tree().get_nodes_in_group("Level")[0]
		if level.has_method("spawn_enemy_ship1") and level.has_method("spawn_enemy_ship2") and level.has_method("spawn_enemy_ship3"):
			if current_enemy == 1:
				current_enemy = 2
				level.spawn_enemy_ship1()
			elif current_enemy == 2:
				current_enemy = 3
				level.spawn_enemy_ship2()
			elif current_enemy == 3:
				level.spawn_enemy_ship3()
				if second_spawn == false:
					current_enemy = 1
					second_spawn = true
				else:
					current_target = 0
					current_action = 3
					do_action = true
					$Action2Timer.stop()
				pass
		pass # Replace with function body.
