extends TextureProgress

onready var container = $Container
onready var player_DFR = $Container/PlayerDFR
onready var player_shield = $Container/PlayerShield
onready var cooldown_timer = $CooldownTimer
onready var use_ability_particle = $Particles2D
onready var ability_ready_particle = $Particles2D2

enum ability {
	DOBBLE_FIRE_RATE
	SHIELD
}

var timer_on = false

var player
var player_id = 1
var curent_ability

func _ready():
	if player_id == 1:
		player = StageInfo.player1
		if StageInfo.player1_ability == StageInfo.ability.DOBBLE_FIRE_RATE:
			player_shield.queue_free()
		elif StageInfo.player1_ability == StageInfo.ability.SHIELD:
			player_DFR.queue_free()
	elif player_id == 2:
		player = StageInfo.player2
		if StageInfo.player2_ability == StageInfo.ability.DOBBLE_FIRE_RATE:
			player_shield.queue_free()
		elif StageInfo.player2_ability == StageInfo.ability.SHIELD:
			player_DFR.queue_free()
	player.skill_cd_hud = self

func _process(delta):
	if not timer_on:
		return
	
	value = -cooldown_timer.get_time_left()

func set_player(player_ability, player_node):
	if player_ability == ability.DOBBLE_FIRE_RATE:
		curent_ability = ability.DOBBLE_FIRE_RATE
		player_shield.queue_free()
	elif player_ability == ability.SHIELD:
		curent_ability = ability.SHIELD
		player_DFR.queue_free()
	player = player_node
	player.skill_cd_hud = self
	pass

func use_ability():
	use_ability_particle.emitting = true

func start_CD_timer():
	ability_ready_particle.emitting = false
	use_ability_particle.emitting = false
	container.modulate = Color(1, 1, 1, 0.5)
	cooldown_timer.start()
	timer_on = true

func _on_CooldownTimer_timeout():
	ability_ready_particle.emitting = true
	timer_on = false
	player.ability_ready = true
	container.modulate = Color(1, 1, 1, 1)

func connect_pressed_signal(player):
	if player == 1:
		$TouchScreenButton.connect("pressed", StageInfo.player1, "ability_pressed")
	else:
		$TouchScreenButton.connect("pressed", StageInfo.player2, "ability_pressed")
	pass
