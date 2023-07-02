extends Node2D

onready var basic_enemy_spawn_timer = $BasicEnemySpawnTimer
onready var special_enemy_spawn_timer = $SpecialEnemySpawnTimer
onready var stage_timer = $StageTimer
onready var spawn_single_player = $PlayerSpawn
onready var spawn_P1 = $PlayerSpawn/P1SpawnPos
onready var spawn_P2 = $PlayerSpawn/P2SpawnPos

const player_DFR = preload("res://Scene/Player/PlayerShipDBFR.tscn")
const player_shield = preload("res://Scene/Player/PlayerShipShield.tscn")

var random = RandomNumberGenerator.new()
const spawn_pos_y = -150

var stage_time_out = false

func _ready():
	set_spawn_time()
	spawn_player()
	$HUD.set_exp()
	$HUD.set_hp()
	$HUD.set_shield()
	$HUD.set_skill_CD_pos()
	random.randomize()
	pass

func set_spawn_time():
	if StageInfo.play_co_op:
		if StageInfo.have_rocket or StageInfo.have_turret:
			basic_enemy_spawn_timer.wait_time = 0.5
			special_enemy_spawn_timer.wait_time = 5
		elif StageInfo.have_rocket and StageInfo.have_turret:
			basic_enemy_spawn_timer.wait_time = 0.4
			special_enemy_spawn_timer.wait_time = 4
		else:
			basic_enemy_spawn_timer.wait_time = 0.6
			special_enemy_spawn_timer.wait_time = 6
	else:
		if StageInfo.have_rocket or StageInfo.have_turret:
			basic_enemy_spawn_timer.wait_time = 0.9
			special_enemy_spawn_timer.wait_time = 9
		elif StageInfo.have_rocket and StageInfo.have_turret:
			basic_enemy_spawn_timer.wait_time = 0.8
			special_enemy_spawn_timer.wait_time = 8
		else:
			basic_enemy_spawn_timer.wait_time = 1
			special_enemy_spawn_timer.wait_time = 10
	if StageInfo.level != 5:
		basic_enemy_spawn_timer.start()
		special_enemy_spawn_timer.start()
		stage_timer.start()

func spawn_player():
	if StageInfo.play_co_op:
		for i in 2:
			var a
			if i == 0:
				if StageInfo.player1_ability == StageInfo.ability.DOBBLE_FIRE_RATE:
					a = player_DFR.instance()
				else:
					a = player_shield.instance()
				StageInfo.player1 = a
				a.player = 1
#				a.global_position
				spawn_P2.add_child(a)
			else:
				if StageInfo.player2_ability == StageInfo.ability.DOBBLE_FIRE_RATE:
					a = player_DFR.instance()
				else:
					a = player_shield.instance()
				StageInfo.player2 = a
				a.player = 2
				spawn_P1.add_child(a)
		StageInfo.player1.other_player = StageInfo.player2
		StageInfo.player2.other_player = StageInfo.player1
	else:
		var a
		if StageInfo.player1_ability == StageInfo.ability.DOBBLE_FIRE_RATE:
			a = player_DFR.instance()
		else:
			a = player_shield.instance()
		StageInfo.player1 = a
		a.player = 1
		spawn_single_player.add_child(a)
	pass

func _process(delta):
	check_enemy()
	pass

func check_enemy():
#	print("Enemy",get_tree().get_nodes_in_group("Enemy").size(), "\nBullet ", get_tree().get_nodes_in_group("Bullet").size(), "\nTimeout ", stage_time_out)
	if get_tree().get_nodes_in_group("Enemy").empty() and get_tree().get_nodes_in_group("Bullet").empty() and stage_time_out:
		stage_clear()
#		get_tree().call_group("Bullet", "instance_particle", enemy_bulet_partile.instance())
	pass

func stage_clear():
	AudioLoad.stop_shoot_sound()
	if StageInfo.player1.ready:
		$AnimationPlayer.play("End")
		StageInfo.player1.ready = false
		StageInfo.player1.remove_from_group("Target")
		if StageInfo.play_co_op:
			StageInfo.player2.ready = false
			StageInfo.player2.remove_from_group("Target")

func _on_StageTimer_timeout():
	basic_enemy_spawn_timer.stop()
	special_enemy_spawn_timer.stop()
	stage_time_out = true
	if get_tree().get_nodes_in_group("Enemy").size() <= 1:
		$AnimationPlayer.play("End")
		StageInfo.player1.ready = false
		StageInfo.player1.remove_from_group("Target")
		if StageInfo.play_co_op:
			StageInfo.player2.ready = false
			StageInfo.player2.remove_from_group("Target")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Begin":
		StageInfo.player1.ready = true
		StageInfo.player1.add_to_group("Target")
		if StageInfo.play_co_op:
			StageInfo.player2.ready = true
			StageInfo.player2.add_to_group("Target")
	elif anim_name == "End":
		if StageInfo.level == 5:
			StageInfo.level = 1
			StageInfo.stage += 1
		else:
			StageInfo.level += 1
		if StageInfo.stage == 2:
			get_tree().change_scene("res://Scene/Level/Stage2.tscn")
		elif StageInfo.stage == 3:
			StageInfo.reset_all_status()
			get_tree().change_scene("res://Scene/UI or HUD/CreditScene.tscn")
		else:
			get_tree().reload_current_scene()
	pass # Replace with function body.
