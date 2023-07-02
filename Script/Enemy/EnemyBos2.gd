extends KinematicBody2D

const explode_particle = preload("res://Scene/Efx/ExplosionParticle.tscn")
const trail_target = preload("res://Scene/Efx/TrailTarget.tscn")

onready var turet_animation = $AnimationPlayer
onready var smoke_particle_turet_spin = $DorLarge/SmokeParticle
onready var smoke_particle_turet_front = $DorFront/SmokeParticle
onready var burn_particle_turet_spin = $DorLarge/BurnParticle
onready var burn_particle_turet_front = $DorFront/BurnParticle
onready var turet_front = $DorFront/FrontTuret
onready var turet_spin = $DorLarge/TuretSpin

var have_turet_front = true

var target:Array = [Vector2(235, 80), Vector2(235, -150)]
var current_target:int = 0

var current_action:int = 1
var do_action = true

var current_enemy = 1

var random = RandomNumberGenerator.new()

func _ready():
	if StageInfo.play_co_op:
		turet_front.healt = 12000
		turet_spin.max_healt = 28000
		turet_spin.healt = 28000
	else:
		turet_front.healt = 8000
		turet_spin.max_healt = 10000
		turet_spin.healt = 10000
	if StageInfo.have_turret:
		turet_front.healt += 1000
		turet_spin.max_healt += 2000
		turet_spin.healt += 2000
	if StageInfo.have_rocket:
		turet_front.healt += 1000
		turet_spin.max_healt += 2000
		turet_spin.healt += 2000
	random.randomize()

func _physics_process(_delta):
	global_position = lerp(global_position, target[current_target], 0.01)
	if do_action:
		if (global_position - target[current_target]).length() < 5:
			action_list()

func action_list():
	if current_action == 1:
		action1()
	elif current_action == 2:
		action2()
	elif current_action == 3:
		action3()
	elif current_action == 4:
		action4()
	pass

func action1():
	add_to_group("Target")
	do_action = false
	turet_animation.play("FrontTuretPopUp")
	pass

func action2():
	do_action = false
	if get_tree().has_group("Level"):
		var level = get_tree().get_nodes_in_group("Level")[0]
		if level.has_method("spawn_enemy_ship4") and level.has_method("spawn_enemy_ship5") and level.has_method("spawn_enemy_ship6") and level.has_method("spawn_enemy_ship_mini_bos1"):
			level.spawn_enemy_ship4()
			current_enemy = 2
			$ActionTimer.start()
			pass

func action3():
	add_to_group("Target")
	do_action = false
	turet_animation.play("SpinTuretPopUp")

func action4():
	add_to_group("Target")
	do_action = false
	turet_spin.ready = true
	turet_spin._on_ShootTimer_timeout()
	$DorLarge/TuretSpin/CollisionPolygon2D.disabled = false
	$DorLarge/TuretSpin/ShootTimer.start()

func instance_explode_particle(pos:Vector2):
	var a = explode_particle.instance()
	a.global_position = pos
	if get_tree().has_group("Level"):
		get_tree().get_nodes_in_group("Level")[0].add_child(a)
	pass

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

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FrontTuretPopUp":
		$DorFront/FrontTuret/ShootTimer.start()
		turet_animation.play("FontTuretRotareAround")
	if anim_name == "SpinTuretPopUp":
		$DorLarge/TuretSpin/ShootTimer.start()
		turet_spin.ready = true
	pass # Replace with function body.


func _on_FrontTuret_death():
	remove_from_group("Target")
	instance_explode_particle($DorFront.global_position)
	drop_exp(10)
	smoke_particle_turet_front.emitting = true
	burn_particle_turet_front.emitting = true
	current_action = 2
	current_target = 1
	do_action = true
	pass # Replace with function body.


func _on_ActionTimer_timeout():
	if get_tree().has_group("Level"):
		var level = get_tree().get_nodes_in_group("Level")[0]
		if level.has_method("spawn_enemy_ship5") and level.has_method("spawn_enemy_ship6") and level.has_method("spawn_enemy_ship_mini_bos1"):
			if current_enemy == 2:
				current_enemy = 3
				level.spawn_enemy_ship5()
			elif current_enemy == 3:
				current_enemy = 4
				level.spawn_enemy_ship6()
			elif  current_enemy == 4:
				current_enemy = 1
				level.spawn_enemy_ship_mini_bos1()
			else:
				if not turet_spin.half_healt:
					current_action = 3
				else:
					current_action = 4
				current_target = 0
				do_action = true
				$ActionTimer.stop()
				pass
	pass # Replace with function body.


func _on_TuretSpin_half_healt():
	remove_from_group("Target")
	instance_explode_particle($DorLarge.global_position)
	drop_exp(10)
	smoke_particle_turet_spin.emitting = true
	current_action = 2
	current_target = 1
	do_action = true
	pass # Replace with function body.


func _on_TuretSpin_death():
	remove_from_group("Target")
	instance_explode_particle($DorLarge.global_position)
	burn_particle_turet_spin.emitting = true
	if get_tree().has_group("Level"):
		get_tree().get_nodes_in_group("Level")[0].stage_time_out = true
		drop_exp(10)
	pass # Replace with function body.
