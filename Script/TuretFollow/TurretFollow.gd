extends KinematicBody2D
class_name Turret_Follow

const explosion_particle = preload("res://Scene/Efx/ExplosionParticle.tscn")

export var healt:int = 2000
export var ready:bool = false setget set_ready, get_ready
export(float, 20.0) var fire_rate = 0.4# setget set_time
export(float, 0.001, 0.5) var rotate_speed = 0.05
export(Resource) var bullet_scene
export(NodePath) var muzzle_path
export var target_group:String

var destroy_demage = 50

signal death()

#var bullet = preload(bullet_scene
var players
var player
var muzzle
var shoot_timer = Timer.new()

func _ready():
#	if ready:
#		shoot_timer.start()
	if get_tree().has_group(target_group):
		players = get_tree().get_nodes_in_group(target_group)
	muzzle = get_node(muzzle_path)
	shoot_timer.wait_time = fire_rate

func _physics_process(delta):
	if target_group != "":
		if get_tree().has_group(target_group):
			players = get_tree().get_nodes_in_group(target_group)
			var cur_length = 0
			var q = false
			for i in players:
				if q == false:
					q = true
					cur_length = (global_position - i.global_position).length()
				if (global_position - i.global_position).length() <= cur_length:
					cur_length = (global_position - i.global_position).length()
					player = i
			if player != null:
				global_rotation  = lerp_angle(global_rotation, (global_position - player.global_position).angle(), rotate_speed)
			else:
				print("player is null")
#		else:
#			print('tree does not have node "', target_group, '" groub')
	else:
		print('please insert "TARGET GROUP"')

func shoot():
	if bullet_scene != null and muzzle_path != "":
		var a = bullet_scene.instance()
		a.global_position = muzzle.global_position
		a.rotation_degrees = muzzle.global_rotation_degrees
		a.z_index = 1
#		get_parent().get_parent().add_child(a)
		if get_tree().has_group("Level"):
			get_tree().get_nodes_in_group("Level")[0].add_child(a)
	else:
		print('please insert "BULLET SCENE" or "MUZZLE PATH"')

func hurt(demage):
	healt -= demage
	if healt <= 0:
		emit_signal("death")
		queue_free()

func destroy(player):
	if player.has_method("hurt"):
		player.hurt(destroy_demage)
		hurt(destroy_demage * 2)
		var a = explosion_particle.instance()
		a.global_position = global_position
		if get_tree().has_group("Level"):
			get_tree().get_nodes_in_group("Level")[0].add_child(a)
		else:
			print('tree doesn`t have "Level" group')
	else:
		print('body name ',player.name, ' doesn`t have "hurt" method')
#	emit_signal("death")
#	queue_free()

func set_ready(aku):
	if not get_children().has(shoot_timer):
		shoot_timer.connect("timeout", self, "shoot")
		shoot_timer.autostart = true
		self.add_child(shoot_timer)
	else:
		if aku:
			if get_children().has(shoot_timer):
				shoot_timer.start()
			else:
				shoot_timer.autostart = true
		else:
			if get_children().has(shoot_timer):
				shoot_timer.stop()
			else:
				shoot_timer.autostart = false
#	shoot()
#	return ready

func set_time(time):
	pass

func get_ready():
	return ready
