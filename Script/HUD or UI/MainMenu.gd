extends Control

onready var setting = $Setting
onready var play_mode = $PlayMode
onready var animation_menu = $AnimationMenu
onready var single_player_animation = $SelectShipSinglePlayer/AnimationSinglePlayer
onready var single_player_sprite = $SelectShipSinglePlayer/Sprite
onready var single_player_main_engine_particle = $SelectShipSinglePlayer/Sprite/MainEngine
onready var single_player_secondary_engine1_particle = $SelectShipSinglePlayer/Sprite/SecondaryEngine
onready var single_player_secondary_engine2_particle = $SelectShipSinglePlayer/Sprite/SecondaryEngine2
onready var co_op_animation = $SelectShipCoOp/AnimationCoOp
onready var co_op_sprite1 = $SelectShipCoOp/Player1
onready var co_op_sprite2 = $SelectShipCoOp/Player2
onready var co_op_main_engine_particle_P1 = $SelectShipCoOp/Player1/MainEngine
onready var co_op_main_engine_particle_P2 = $SelectShipCoOp/Player2/MainEngine
onready var co_op_secondary_engine_particle1_P1 = $SelectShipCoOp/Player1/SecondaryEngine
onready var co_op_secondary_engine_particle2_P1 = $SelectShipCoOp/Player1/SecondaryEngine2
onready var co_op_secondary_engine_particle1_P2 = $SelectShipCoOp/Player2/SecondaryEngine
onready var co_op_secondary_engine_particle2_P2 = $SelectShipCoOp/Player2/SecondaryEngine2
onready var co_op_selected_P1 = $SelectShipCoOp/Player1/Selected
onready var co_op_selected_P2 = $SelectShipCoOp/Player2/Selected
onready var co_op_select_button_P1 = $SelectShipCoOp/Player1/Select_P1
onready var co_op_select_button_P2 = $SelectShipCoOp/Player2/Select_P2
onready var windows_option = $Setting/Panel/GridContainer/WindowSizeOption
onready var mode_option = $Setting/Panel/GridContainer/ModeOption
onready var world = $WorldEnvironment

var player1_ability = StageInfo.ability.DOBBLE_FIRE_RATE
var player2_ability = StageInfo.ability.SHIELD

var player1_selected = false
var player2_selected = false

var play_Co_Op = false

var random = RandomNumberGenerator.new()

func _ready():
	
	random.randomize()
	if OS.window_size == Vector2(480, 270):
		windows_option.selected = 0
	elif OS.window_size == Vector2(940, 560):
		windows_option.selected = 1
	elif OS.window_size == Vector2(1280, 720):
		windows_option.selected = 2
	elif OS.window_fullscreen:
		windows_option.selected = 3
	
	if world.environment.glow_enabled and world.environment.adjustment_enabled:
		mode_option.selected = 2
	elif world.environment.glow_enabled and world.environment.adjustment_enabled:
		mode_option.selected = 1
	else:
		mode_option.selected = 0
	
#	if random.randf() > 0.3:
#		$AdMob.load_interstitial()
#		$AdMob.show_interstitial()
#	$AdMob.load_banner()
#	$AdMob.show_banner()

func _on_SettingButton_pressed():
	setting.show()
	pass # Replace with function body.


func _on_PlayButton_pressed():
	play_mode.show()
	pass # Replace with function body.


func _on_CloseSetting_pressed():
	setting.hide()
	pass # Replace with function body.


func _on_ClosePlayMode_pressed():
	play_mode.hide()
	pass # Replace with function body.


func _on_PlaySinglePlayer_pressed():
	play_Co_Op = false
	play_mode.hide()
	single_player_animation.play("BeginSelect")
	animation_menu.play("DropDown")
	pass # Replace with function body.

func _on_PlayCoOp_pressed():
	play_Co_Op = true
	play_mode.hide()
	co_op_animation.play("BeginSelect")
	animation_menu.play("DropDown")
	pass # Replace with function body.

func _on_SinglePlayerButtonR_pressed():
	if single_player_sprite.frame == 0:
		player1_ability = StageInfo.ability.SHIELD
		single_player_sprite.frame = 1
		single_player_main_engine_particle.position.y = 10
		single_player_secondary_engine1_particle.emitting = true
		single_player_secondary_engine2_particle.emitting = true
	elif single_player_sprite.frame == 1:
		player1_ability = StageInfo.ability.DOBBLE_FIRE_RATE
		single_player_sprite.frame = 0
		single_player_main_engine_particle.position.y = 9
		single_player_secondary_engine1_particle.emitting = false
		single_player_secondary_engine2_particle.emitting = false
	pass # Replace with function body.


func _on_SinglePlayerButtonL_pressed():
	if single_player_sprite.frame == 0:
		player1_ability = StageInfo.ability.SHIELD
		single_player_sprite.frame = 1
		single_player_main_engine_particle.position.y = 10
		single_player_secondary_engine1_particle.emitting = true
		single_player_secondary_engine2_particle.emitting = true
	elif single_player_sprite.frame == 1:
		player1_ability = StageInfo.ability.DOBBLE_FIRE_RATE
		single_player_sprite.frame = 0
		single_player_main_engine_particle.position.y = 9
		single_player_secondary_engine1_particle.emitting = false
		single_player_secondary_engine2_particle.emitting = false
	pass # Replace with function body.


func _on_StartButton_pressed():
	if not play_Co_Op:
		single_player_animation.play("Selected")
		StageInfo.play_co_op = false
		StageInfo.player1_ability = player1_ability
		StageInfo.max_healt = 100
		StageInfo.healt = StageInfo.max_healt
		StageInfo.max_shield = 50
		StageInfo.shield = StageInfo.max_shield
	else:
		if player1_selected and player2_selected:
			co_op_animation.play("Selected")
			StageInfo.play_co_op = true
			StageInfo.player1_ability = player1_ability
			StageInfo.player2_ability = player2_ability
			StageInfo.max_healt = 200
			StageInfo.healt = StageInfo.max_healt
			StageInfo.max_shield = 100
			StageInfo.shield = StageInfo.max_shield
			StageInfo.player_max_exp = 120

func _on_CoOpButtonR_P1_pressed():
	if not player1_selected:
		if co_op_sprite1.frame == 0:
			player1_ability = StageInfo.ability.SHIELD
			co_op_sprite1.frame = 1
			co_op_main_engine_particle_P1.position.y = 10
			co_op_secondary_engine_particle1_P1.emitting = true
			co_op_secondary_engine_particle2_P1.emitting = true
		elif co_op_sprite1.frame == 1:
			player1_ability = StageInfo.ability.DOBBLE_FIRE_RATE
			co_op_sprite1.frame = 0
			co_op_main_engine_particle_P1.position.y = 9
			co_op_secondary_engine_particle1_P1.emitting = false
			co_op_secondary_engine_particle2_P1.emitting = false
	pass # Replace with function body.

func _on_CoOpButtonR_P2_pressed():
	if not player2_selected:
		if co_op_sprite2.frame == 0:
			player2_ability = StageInfo.ability.SHIELD
			co_op_sprite2.frame = 1
			co_op_main_engine_particle_P2.position.y = 10
			co_op_secondary_engine_particle1_P2.emitting = true
			co_op_secondary_engine_particle2_P2.emitting = true
		elif co_op_sprite2.frame == 1:
			player2_ability = StageInfo.ability.DOBBLE_FIRE_RATE
			co_op_sprite2.frame = 0
			co_op_main_engine_particle_P2.position.y = 9
			co_op_secondary_engine_particle1_P2.emitting = false
			co_op_secondary_engine_particle2_P2.emitting = false
	pass # Replace with function body.


func _on_CoOpButtonL_P1_pressed():
	if not player1_selected:
		if co_op_sprite1.frame == 0:
			player1_ability = StageInfo.ability.SHIELD
			co_op_sprite1.frame = 1
			co_op_main_engine_particle_P1.position.y = 10
			co_op_secondary_engine_particle1_P1.emitting = true
			co_op_secondary_engine_particle2_P1.emitting = true
		elif co_op_sprite1.frame == 1:
			player1_ability = StageInfo.ability.DOBBLE_FIRE_RATE
			co_op_sprite1.frame = 0
			co_op_main_engine_particle_P1.position.y = 9
			co_op_secondary_engine_particle1_P1.emitting = false
			co_op_secondary_engine_particle2_P1.emitting = false
	pass # Replace with function body.


func _on_CoOpButtonL_P2_pressed():
	if not player2_selected:
		if co_op_sprite2.frame == 0:
			player2_ability = StageInfo.ability.SHIELD
			co_op_sprite2.frame = 1
			co_op_main_engine_particle_P2.position.y = 10
			co_op_secondary_engine_particle1_P2.emitting = true
			co_op_secondary_engine_particle2_P2.emitting = true
		elif co_op_sprite2.frame == 1:
			player2_ability = StageInfo.ability.DOBBLE_FIRE_RATE
			co_op_sprite2.frame = 0
			co_op_main_engine_particle_P2.position.y = 9
			co_op_secondary_engine_particle1_P2.emitting = false
			co_op_secondary_engine_particle2_P2.emitting = false
	pass # Replace with function body.


func _on_Select_P1_pressed():
	if player1_selected:
		Back_Close()
		player1_selected = false
		co_op_selected_P1.hide()
		co_op_select_button_P1.text = "Select"
	elif player2_selected:
		if player1_ability != player2_ability:
			pressed()
			player1_selected = true
			co_op_selected_P1.show()
			co_op_select_button_P1.text = "Unselect"
	else:
		if player1_selected:
			Back_Close()
			player1_selected = false
			co_op_selected_P1.hide()
			co_op_select_button_P1.text = "Select"
		else:
			pressed()
			player1_selected = true
			co_op_selected_P1.show()
			co_op_select_button_P1.text = "Unselect"
	pass # Replace with function body.


func _on_Select_P2_pressed():
	if player2_selected:
		Back_Close()
		player2_selected = false
		co_op_selected_P2.hide()
		co_op_select_button_P2.text = "Select"
	elif player1_selected:
		if player2_ability != player1_ability:
			pressed()
			player2_selected = true
			co_op_selected_P2.show()
			co_op_select_button_P2.text = "Unselect"
	else:
		if player2_selected:
			Back_Close()
			player2_selected = false
			co_op_selected_P2.hide()
			co_op_select_button_P2.text = "Select"
		else:
			pressed()
			player2_selected = true
			co_op_selected_P2.show()
			co_op_select_button_P2.text = "Unselect"


func _on_AnimationCoOp_animation_finished(anim_name):
	if anim_name == "Selected":
		get_tree().change_scene("res://Scene/Level/Stage1.tscn")
	pass # Replace with function body.


func _on_AnimationSinglePlayer_animation_finished(anim_name):
	if anim_name == "Selected":
		get_tree().change_scene("res://Scene/Level/Stage1.tscn")
	pass # Replace with function body.


func _on_WindowSizeOption_item_selected(index):
	if index == 0:
		OS.window_fullscreen = false
		OS.window_size = Vector2(480, 270)
	elif index == 1:
		OS.window_fullscreen = false
		OS.window_size = Vector2(960, 540)
	elif index == 2:
		OS.window_fullscreen = false
		OS.window_size = Vector2(1280, 720)
	elif index == 3:
		OS.window_fullscreen = true
	pass # Replace with function body.


func _on_ModeOption_item_selected(index):
	if index == 0:
		$WorldEnvironment.environment.glow_enabled = false
		$WorldEnvironment.environment.adjustment_enabled = false
	elif index == 1:
		$WorldEnvironment.environment.glow_enabled = false
		$WorldEnvironment.environment.adjustment_enabled = true
	elif index == 2:
		$WorldEnvironment.environment.glow_enabled = true
		$WorldEnvironment.environment.adjustment_enabled = true
		
	pass # Replace with function body.


func _on_ExitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_BackButton_pressed():
	animation_menu.play_backwards("DropDown")
	if play_Co_Op:
		co_op_animation.play("BackToMenu")
		player2_selected = false
		co_op_selected_P2.hide()
		co_op_select_button_P2.text = "Select"
		player1_selected = false
		co_op_selected_P1.hide()
		co_op_select_button_P1.text = "Select"
	else:
		single_player_animation.play("BackToMenu")
	pass # Replace with function body.

func mouse_entered(node_path):
	if node_path != "none":
		get_node(node_path).self_modulate = Color("ff7200")
	$UI_SFX.play()
	pass # Replace with function body.

func mouse_exited(node_path):
	get_node(node_path).self_modulate = Color("ffffff")

func pressed():
	$Select_SFX.play()
	pass # Replace with function body.


func Back_Close():
	$Unselect_SFX.play()
	pass # Replace with function body.


func _on_CheckBox_toggled(button_pressed):
	print(button_pressed)
	StageInfo.screen_shake = button_pressed
	pass # Replace with function body.
