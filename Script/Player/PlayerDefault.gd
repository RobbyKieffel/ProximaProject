extends KinematicBody2D

#========================= refrance node =========================
onready var muzzle1 = $Muzzle1
onready var muzzle2 = $Muzzle2
onready var DRF_ability_timer = $DFRAbilityTime
onready var shield_ability_timer = $ShieldAbilityTime
onready var coldown_ability_timer = $CooldownAbilityTimer
onready var shoot_timer = $ShootTime
onready var shield_sprite = $ShieldSprite
onready var smoke_particle = $SmokeParticle
onready var smoke_particle2 = $SmokeParticle2
onready var player_marker = $PlayeerMarker
onready var player_marker_label = $PlayeerMarker/Label
onready var rocket_shoot_timer = $RocketShootTime
onready var rocket_muzzle1 = $RocketShoot/RocketMuzzle1
onready var rocket_muzzle2 = $RocketShoot/RocketMuzzle2
onready var turet_follow = $Turret_Follow
onready var rocket_shoot = $RocketShoot

#========================= scene load =========================
const rocket_bullet = preload("res://Scene/Bullet/RocketFollowDefault.tscn")
const bullet = preload("res://Scene/Bullet/BulletPlayer.tscn")

#========================= skill hud node =========================
var skill_cd_hud

#========================= ability list =========================
enum ability {
	DOBBLE_FIRE_RATE
	SHIELD
}

#========================= editable variable =========================
export(int, 100, 500) var speed = 400
export(int, 1, 20) var speed_acceleration = 5
export(float, 0.05, 3) var fire_rate = 0.3
export(int, 1, 2)var player = 1
export(ability) var player_ability

#========================= player limit pos =========================
#========== it`s use to limit player movement. it`s make player can`t go to far
const limit_max_pos = Vector2(520, 310)
const limit_min_pos = Vector2(-40, -40)

#========== it`s use to make player cant move until it`s ready to move. it`s use in the begining when level start
export var ready:bool = false

#========================= move variable =========================
var velocity:Vector2 = Vector2.ZERO

#========================= ability variable =========================
var ability_ready:bool = true
var use_shield:bool = false

#========== refrance for other_player node. it`s just use in co-op mode
var other_player

const joystick_pos = [Vector2(80, 200), Vector2(400, 200)]

func _ready():
	if StageInfo.play_co_op:
		if player == 1:
			player_marker.self_modulate = Color(0, 1 ,0 ,1)
			player_marker_label.text = "P1"
#			StageInfo.player1 = self
		elif player == 2:
			player_marker.self_modulate = Color(0, 0.2, 1, 1)
			player_marker_label.text = "P2"
#			StageInfo.player2 = self
	else:
		player_marker.hide()
	
	shoot_timer.wait_time = fire_rate
	shoot_timer.start()
	if StageInfo.have_turret:
		have_turet()
	if StageInfo.have_rocket:
		have_rocket()
	
	if player == 1:
		AudioLoad.play_shoot_sound()

func _unhandled_key_input(event):
		if Input.is_action_just_pressed("P1_ability") and player == 1:
			use_ability()
		elif Input.is_action_just_pressed("P2_ability") and player == 2:
			use_ability()

func _physics_process(delta):
#	move_to_mouse_pos()
	if OS.get_name() != "Android" or OS.get_name() != "iOS":
		manual_move()
	velocity = move_and_slide(velocity)
	global_position.x = clamp(global_position.x, limit_min_pos.x, limit_max_pos.x)
	global_position.y = clamp(global_position.y, limit_min_pos.y, limit_max_pos.y)
	pass

func manual_move():
	if get_tree().get_nodes_in_group("Player").size() == 1:
		move_single_player()
	else:
		move_co_op()

func move_single_player():
	velocity.y = clamp(velocity.y, -speed, speed)
	velocity.x = clamp(velocity.x, -speed, speed)
	if Input.is_action_pressed("P1_forward") or Input.is_action_pressed("P1_backward") or Input.is_action_pressed("P1_left") or Input.is_action_pressed("P1_right"):
		if global_position.x == limit_min_pos.x or global_position.x == limit_max_pos.x:
			velocity.x = 0
		if global_position.y == limit_min_pos.y or global_position.y == limit_max_pos.y:
			velocity.y = 0
		if Input.is_action_pressed("P1_forward"):
			velocity.y -= Input.get_action_strength("P1_forward") * speed_acceleration
		if Input.is_action_pressed("P1_backward"):
			velocity.y += Input.get_action_strength("P1_backward") * speed_acceleration
		if Input.is_action_pressed("P1_left"):
			velocity.x -= Input.get_action_strength("P1_left") * speed_acceleration
		if Input.is_action_pressed("P1_right"):
			velocity.x += Input.get_action_strength("P1_right") * speed_acceleration
		velocity.normalized()
	else:
		velocity.x = lerp(velocity.x, 0, 0.03)
		velocity.y = lerp(velocity.y, 0, 0.03)
	pass

func move_co_op():
	velocity.y = clamp(velocity.y, -speed, speed)
	velocity.x = clamp(velocity.x, -speed, speed)
	if player == 1:
		if Input.is_action_pressed("P1_forward") or Input.is_action_pressed("P1_backward") or Input.is_action_pressed("P1_left") or Input.is_action_pressed("P1_right"):
			if global_position.x == limit_min_pos.x or global_position.x == limit_max_pos.x:
				velocity.x = 0
			if global_position.y == limit_min_pos.y or global_position.y == limit_max_pos.y:
				velocity.y = 0
			if Input.is_action_pressed("P1_forward"):
				velocity.y -= Input.get_action_strength("P1_forward") * speed_acceleration
			if Input.is_action_pressed("P1_backward"):
				velocity.y += Input.get_action_strength("P1_backward") * speed_acceleration
			if Input.is_action_pressed("P1_left"):
				velocity.x -= Input.get_action_strength("P1_left") * speed_acceleration
			if Input.is_action_pressed("P1_right"):
				velocity.x += Input.get_action_strength("P1_right") * speed_acceleration
			velocity.normalized()
		else:
			velocity.x = lerp(velocity.x, 0, 0.03)
			velocity.y = lerp(velocity.y, 0, 0.03)
	else:
		if Input.is_action_pressed("P2_forward") or Input.is_action_pressed("P2_backward") or Input.is_action_pressed("P2_left") or Input.is_action_pressed("P2_right"):
			if global_position.x == limit_min_pos.x or global_position.x == limit_max_pos.x:
				velocity.x = 0
			if global_position.y == limit_min_pos.y or global_position.y == limit_max_pos.y:
				velocity.y = 0
			if Input.is_action_pressed("P2_forward"):
				velocity.y -= Input.get_action_strength("P2_forward") * speed_acceleration
			if Input.is_action_pressed("P2_backward"):
				velocity.y += Input.get_action_strength("P2_backward") * speed_acceleration
			if Input.is_action_pressed("P2_left"):
				velocity.x -= Input.get_action_strength("P2_left") * speed_acceleration
			if Input.is_action_pressed("P2_right"):
				velocity.x += Input.get_action_strength("P2_right") * speed_acceleration
			velocity.normalized()
		else:
			velocity.x = lerp(velocity.x, 0, 0.03)
			velocity.y = lerp(velocity.y, 0, 0.03)

func move_to_mouse_pos():
	if global_position.distance_to(get_global_mouse_position()) > 100:
		speed = 400
	else:
		speed = global_position.distance_to(get_global_mouse_position())*4
	velocity = global_position.direction_to(get_global_mouse_position())
	velocity = velocity.normalized() * speed

func hurt(demage):
	if use_shield == false:
		get_tree().get_nodes_in_group("HUD")[0].hurt(demage, self)

func emit_smoke(is_low:bool):
	smoke_particle.emitting = is_low
	smoke_particle2.emitting = is_low

func shoot():
	for i in 2:
		var a = bullet.instance()
		if i == 0:
			a.global_position = muzzle1.global_position
		else:
			a.global_position = muzzle2.global_position
		if player == 1:
			a.attack = StageInfo.attack
		else:
			a.attack = StageInfo.attack
		if get_tree().has_group("Level"):
			get_tree().get_nodes_in_group("Level")[0].add_child(a)
		else:
			print('tree does not have "LEVEL" group')

func shoot_rocket():
	for i in 2:
		var a = rocket_bullet.instance()
		if i == 0:
			a.global_position = rocket_muzzle1.global_position
		else:
			a.global_position = rocket_muzzle2.global_position
		get_tree().get_nodes_in_group("Level")[0].add_child(a)

func have_rocket():
	rocket_shoot.show()
	rocket_shoot_timer.wait_time = fire_rate*5
	rocket_shoot_timer.start()
	

func have_turet():
	turet_follow.show()
	turet_follow.ready = true
	turet_follow.fire_rate = fire_rate
	pass

func ability_pressed():
	use_ability()
	pass

func use_ability():
	if ready:
		if ability_ready:
			if player_ability == ability.DOBBLE_FIRE_RATE:
				ability_dobble_fire_rate()
				if other_player != null:
					other_player.ability_dobble_fire_rate()
			elif player_ability == ability.SHIELD:
				ability_shield()
				if other_player != null:
					other_player.ability_shield()
			ability_ready = false
			skill_cd_hud.use_ability()

func ability_dobble_fire_rate():
	shoot_timer.wait_time = fire_rate / 2
	DRF_ability_timer.start()
	if StageInfo.have_turret:
		turet_follow.fire_rate = fire_rate / 2
	if StageInfo.have_rocket:
		rocket_shoot_timer.wait_time = (fire_rate * 5)/2
	if player == 1:
		AudioLoad.dobble_shoot_sound()
	

func ability_shield():
	use_shield = true
	shield_sprite.show()
	shield_ability_timer.start()

func _on_ShootTime_timeout():
	shoot()


func _on_DemageArea_body_entered(body):
	if body.has_method("destroy"):
		if not body.is_in_group("Ship"):
			body.destroy(self)
	else:
		print(body.name, 'does not have "DESTROY" method')


func _on_DFRAbilityTime_timeout():
	shoot_timer.wait_time = fire_rate
	if StageInfo.have_turret:
		turet_follow.fire_rate = fire_rate
	if StageInfo.have_rocket:
		rocket_shoot_timer.wait_time = fire_rate * 5
	if player_ability == ability.DOBBLE_FIRE_RATE:
		skill_cd_hud.start_CD_timer()
	
	if player == 1:
		AudioLoad.back_to_singgle_shoot_sound()
	pass # Replace with function body.


func _on_ShieldAbilityTime_timeout():
	shield_sprite.hide()
	use_shield = false
	if player_ability == ability.SHIELD:
		skill_cd_hud.start_CD_timer()
#		coldown_ability_timer.start()
	pass # Replace with function body.



func _on_RocketShootTime_timeout():
	shoot_rocket()
	pass # Replace with function body.

func _on_VirtualJoystick_swipe_begin(direction, force):
	print("move")
	if global_position.x == limit_min_pos.x or global_position.x == limit_max_pos.x:
		velocity.x = 0
	if global_position.y == limit_min_pos.y or global_position.y == limit_max_pos.y:
		velocity.y = 0
	if direction.y < 0:
		velocity.y -= direction.y * speed_acceleration# * 2
	if direction.y > 0:
		velocity.y -= direction.y * speed_acceleration# * 2
	if direction.x < 0:
		velocity.x -= direction.x * speed_acceleration# * 2
	if direction.x > 0:
		velocity.x -= direction.x * speed_acceleration# * 2

func _on_VirtualJoystick_swipe_end():
	pass # Replace with function body.




