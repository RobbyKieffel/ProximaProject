extends CanvasLayer
#refrance node
onready var healt_bar = $MainContainer/HealtBar
onready var healt_bar_text = $MainContainer/HealtBar/Label
onready var shield_bar = $MainContainer/ShieldBar
onready var shield_bar_text = $MainContainer/ShieldBar/Label
onready var fps_counter = $MainContainer/FpsCounter
onready var player_skill_container = $MainContainer/PlayerSkillCountainer
onready var level_bar = $MainContainer/LevelProgressBar
onready var level_bar_text = $MainContainer/LevelProgressBar/Label
onready var power_up_sprite = $MainContainer/PowUP/Sprite
onready var power_up_deskripsi = $MainContainer/PowUpDescription
onready var power_up_label = $MainContainer/GetPowUp

var chose_pow_up = false
var stop_pressed = false
var time_pow_up = 0.1
var random = RandomNumberGenerator.new()

const skill_CD_progress = preload("res://Scene/UI or HUD/SkillCDProgress.tscn")
const trail_target = preload("res://Scene/Efx/TrailTarget.tscn")

enum pow_up {
	INCREASE_MAX_HEALT
	INCREASE_MAX_SHIED
	SHOOT_ROCKET
	LITTLE_CANNON
}

var curent_pow_up = pow_up.INCREASE_MAX_HEALT

var lvl_up = false
var is_pause = false

const skill_pos_mobile = [Vector2(0, 150), Vector2(432, 150)]

func _ready():
	random.randomize()
#	set_exp()
#	set_hp()
#	set_shield()
	pass

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_cancel") and lvl_up == false:
		if is_pause:
#			self.set_pause_mode(PAUSE_MODE_INHERIT)
			is_pause = false
			get_tree().paused = false
			$Pause.hide()
		else:
#			self.set_pause_mode(PAUSE_MODE_PROCESS)
			is_pause = true
			get_tree().paused = true
			$Pause.show()


func _process(delta):
	set_opacity()
	fps_counter.text = String(Engine.get_frames_per_second()) + " FPS"

func set_opacity():
	if StageInfo.player1 and StageInfo.player2 and StageInfo.play_co_op:
		var p1_global_canvas_pos = StageInfo.player1.get_global_transform_with_canvas().origin
		var p2_global_canvas_pos = StageInfo.player2.get_global_transform_with_canvas().origin
		if ((p2_global_canvas_pos.x > healt_bar.rect_global_position.x and p2_global_canvas_pos.x < healt_bar.rect_global_position.x + healt_bar.rect_size.x) and p2_global_canvas_pos.y > healt_bar.rect_global_position.y) or ((p1_global_canvas_pos.x > healt_bar.rect_global_position.x and p1_global_canvas_pos.x < healt_bar.rect_global_position.x + healt_bar.rect_size.x) and p1_global_canvas_pos.y > healt_bar.rect_global_position.y):
			shield_bar.self_modulate = Color("60ffffff")
			healt_bar.self_modulate = Color("60ffffff")
		else:
			shield_bar.self_modulate = Color("ffffff")
			healt_bar.self_modulate = Color("ffffff")
		return
	if StageInfo.player1 and StageInfo.play_co_op == false:
		var p1_global_canvas_pos = StageInfo.player1.get_global_transform_with_canvas().origin
		if (p1_global_canvas_pos.x > healt_bar.rect_global_position.x and p1_global_canvas_pos.x < healt_bar.rect_global_position.x + healt_bar.rect_size.x) and p1_global_canvas_pos.y > healt_bar.rect_global_position.y:
			shield_bar.self_modulate = Color("60ffffff")
			healt_bar.self_modulate = Color("60ffffff")
		else:
			shield_bar.self_modulate = Color("ffffff")
			healt_bar.self_modulate = Color("ffffff")

func set_exp():
	level_bar.max_value = StageInfo.player_max_exp
	level_bar.value = StageInfo.player_exp
	level_bar_text.text = String(StageInfo.player_level)
	pass

func add_exp():
	level_bar.value += 1
	pass

func set_hp():
	healt_bar.max_value = StageInfo.max_healt
	healt_bar.value = StageInfo.healt
	healt_bar_text.text = str(healt_bar.value, "/", healt_bar.max_value)
	healt_bar.rect_size.x = healt_bar.max_value
	healt_bar.rect_position = Vector2(get_viewport().get_visible_rect().size.x / 2
	 - healt_bar.rect_size.x / 2, healt_bar.rect_position.y)
	if healt_bar.value <= (healt_bar.max_value / 10) * 5:
		get_tree().call_group("Player", "emit_smoke", true)

func set_shield():
	shield_bar.max_value = StageInfo.max_shield
	shield_bar.value = StageInfo.shield
	shield_bar_text.text = str(shield_bar.value, "/", shield_bar.max_value)
	shield_bar.rect_size.x = shield_bar.max_value
	shield_bar.rect_position = Vector2(get_viewport().get_visible_rect().size.x / 2
	 - shield_bar.rect_size.x / 2, shield_bar.rect_position.y)

func set_skill_CD_pos():
	if StageInfo.play_co_op:
		if OS.get_name() == "Android":
			for i in 2:
				var a = skill_CD_progress.instance()
				if i == 0:
					a.player_id = 1
					a.rect_global_position = skill_pos_mobile[0]
					a.connect_pressed_signal(1)
				elif i == 1:
					a.player_id = 2
					a.rect_global_position = skill_pos_mobile[1]
					a.connect_pressed_signal(2)
				a.rect_scale = Vector2.ONE * 1.5
				add_child(a)
		else:
			for i in 2:
				var a = skill_CD_progress.instance()
				if i == 0:
					a.player_id = 1
					a.connect_pressed_signal(1)
				elif i == 1:
					a.player_id = 2
					a.connect_pressed_signal(2)
				player_skill_container.add_child(a)
	else:
		var a = skill_CD_progress.instance()
		a.player_id = 1
		a.connect_pressed_signal(1)
		player_skill_container.add_child(a)

#func set_joystick_pos():
#	if not OS.get_name() == "Android" or not OS.get_name() == "iOS":
#		return
#
	

#func set_skill_CD_pos_mobile():
#	if StageInfo.play_co_op:
#		for i in 2:
#			var a = skill_CD_progress.instance()
#			if i == 0:
#				a.player_id = 1
#				a.rect_global_position = skill_pos_mobile[0]
#				a.connect_pressed_signal(1)
#			elif i == 1:
#				a.player_id = 2
#				a.rect_global_position = skill_pos_mobile[1]
#				a.connect_pressed_signal(2)
#			add_child(a)
#	else:
#		var a = skill_CD_progress.instance()
#		a.player_id = 1
#		a.connect_pressed_signal(1)
#		player_skill_container.add_child(a)

func hurt(demage, player):
#	demage = 0
	if shield_bar.value > demage:
		shield_bar.value -= demage
	
	else:
		demage -= shield_bar.value
		healt_bar.value -= demage
		shield_bar.value = 0
	
	if healt_bar.value <= (healt_bar.max_value / 10) * 5:
		get_tree().call_group("Player", "emit_smoke", true)
	else:
		get_tree().call_group("Player", "emit_smoke", false)
	
	StageInfo.healt = healt_bar.value
	StageInfo.shield = shield_bar.value
	
	healt_bar_text.text = str(healt_bar.value, "/", healt_bar.max_value)
	shield_bar_text.text = str(shield_bar.value, "/", shield_bar.max_value)
	
	$HurtSound.play()
	
	if healt_bar.value == 0:
		get_tree().change_scene("res://Scene/UI or HUD/MainMenu.tscn")
		StageInfo.reset_all_status()
		AudioLoad.stop_shoot_sound()

func generate_pow_up():
	var currnet_frame = 0
	curent_pow_up = pow_up.INCREASE_MAX_HEALT
	while chose_pow_up == false:
		var random_frame = 0
		var while_loop = false
		while random_frame == currnet_frame or (StageInfo.have_rocket and curent_pow_up == pow_up.SHOOT_ROCKET) or (StageInfo.have_turret and curent_pow_up == pow_up.LITTLE_CANNON):
			random_frame = random.randi_range(0, 3)
			if random_frame == 0:
#				power_up_deskripsi.text = "Increase Max HP"
				curent_pow_up = pow_up.INCREASE_MAX_HEALT
			elif random_frame == 1:
#				power_up_deskripsi.text = "Increase Max Shield"
				curent_pow_up = pow_up.INCREASE_MAX_SHIED
			elif random_frame == 2:
#				power_up_deskripsi.text = "Player Can Shoot Rocket"
				curent_pow_up = pow_up.SHOOT_ROCKET
			elif random_frame == 3:
#				power_up_deskripsi.text = "Player Can Have a Little Cannon"
				curent_pow_up = pow_up.LITTLE_CANNON
		power_up_sprite.frame = random_frame
		if random_frame == 0:
			power_up_deskripsi.text = "Increase Max HP"
			curent_pow_up = pow_up.INCREASE_MAX_HEALT
		elif random_frame == 1:
			power_up_deskripsi.text = "Increase Max Shield"
			curent_pow_up = pow_up.INCREASE_MAX_SHIED
		elif random_frame == 2:
			power_up_deskripsi.text = "Player Can Shoot Rocket"
			curent_pow_up = pow_up.SHOOT_ROCKET
		elif random_frame == 3:
			power_up_deskripsi.text = "Player Can Have a Little Cannon"
			curent_pow_up = pow_up.LITTLE_CANNON
		currnet_frame = random_frame
		if stop_pressed:
			time_pow_up += 0.025
		$PouUpSound.play()
		yield(get_tree().create_timer(time_pow_up),"timeout")
		if time_pow_up >= 0.6:
			chose_pow_up = true
#			yield(get_tree().create_timer(0.5),"timeout")
			$AnimationPlayer.play("GetPowUp")
	pass

func _on_RestoreShield_Timer_timeout():
	if not StageInfo.play_co_op:
		shield_bar.value += 5
	else:
		shield_bar.value += 10
	
	StageInfo.shield = shield_bar.value
	shield_bar_text.text = str(shield_bar.value, "/", shield_bar.max_value)
	pass # Replace with function body.


func _on_LevelProgressBar_value_changed(value):
	StageInfo.player_exp = level_bar.value
	if value == level_bar.max_value:
		lvl_up = true
		StageInfo.player_level += 1
		$AnimationPlayer.play("LevelUp1")
		get_tree().paused = true
	pass # Replace with function body.

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "LevelUp1":
		level_bar.value = 0
		StageInfo.player_exp = level_bar.value
		$AnimationPlayer.play("LevelUp2")
	elif anim_name == "LevelUp2":
		level_bar.max_value += 20
		if StageInfo.play_co_op:
			level_bar.max_value += 30
		StageInfo.player_max_exp = level_bar.max_value
		level_bar_text.text = String(StageInfo.player_level)
		yield(get_tree().create_timer(0.5),"timeout")
		power_up_deskripsi.show()
		power_up_label.show()
		power_up_sprite.show()
		$MainContainer/StopButton.show()
		generate_pow_up()
	elif anim_name == "GetPowUp":
		get_pow_up()
		$AnimationPlayer.play("LevelUp3")
	elif anim_name == "LevelUp3":
		$AnimationPlayer.play("RESET")
		lvl_up = false
		get_tree().paused = false
		chose_pow_up = false
		stop_pressed = false
		time_pow_up = 0.1
	pass # Replace with function body.

func get_pow_up():
	if curent_pow_up == pow_up.INCREASE_MAX_HEALT:
		StageInfo.max_healt += 20
		if StageInfo.play_co_op:
			StageInfo.max_healt += 20
		set_hp()
	elif curent_pow_up == pow_up.INCREASE_MAX_SHIED:
		StageInfo.max_shield += 10
		if StageInfo.play_co_op:
			StageInfo.max_shield += 10
		set_shield()
	elif curent_pow_up == pow_up.SHOOT_ROCKET:
		StageInfo.have_rocket = true
		get_rocket()
	elif curent_pow_up == pow_up.LITTLE_CANNON:
		StageInfo.have_turret = true
		get_turret()
	heal()
	pass

func get_rocket():
	StageInfo.player1.have_rocket()
	if StageInfo.play_co_op:
		StageInfo.player2.have_rocket()
	pass

func get_turret():
	if StageInfo.play_co_op:
		StageInfo.player1.have_turet()
		StageInfo.player2.have_turet()
	else:
		StageInfo.player1.have_turet()

func heal():
	healt_bar.value += 30
	if StageInfo.play_co_op:
		healt_bar.value += 20
	healt_bar_text.text = str(healt_bar.value, "/", healt_bar.max_value)
	StageInfo.healt = healt_bar.value
	if healt_bar.value <= (healt_bar.max_value / 10) * 5:
		get_tree().call_group("Player", "emit_smoke", true)
	else:
		get_tree().call_group("Player", "emit_smoke", false)

func _on_StopButton_pressed():
	if not chose_pow_up:
		stop_pressed = true
#		chose_pow_up = true
#		yield(get_tree().create_timer(0.5),"timeout")
#		$AnimationPlayer.play("GetPowUp")
	pass # Replace with function body.


func _on_Resume_pressed():
#	self.set_pause_mode(PAUSE_MODE_INHERIT)
	is_pause = false
	get_tree().paused = false
	$Pause.hide()
	pass # Replace with function body.

func _on_BackToTittle_pressed():
	AudioLoad.stop_shoot_sound()
	StageInfo.reset_all_status()
	get_tree().paused = false
	get_tree().change_scene("res://Scene/UI or HUD/MainMenu.tscn")
	pass # Replace with function body.
