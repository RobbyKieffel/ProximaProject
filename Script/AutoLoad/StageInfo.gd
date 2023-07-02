extends Node

var screen_shake = true

var max_healt = 100
var healt = 100
var max_shield = 50
var shield = 50
var attack = 50

var player_level = 1
var player_max_exp = 50
var player_exp = 0

var stage = 1
var level = 1

enum ability {
	DOBBLE_FIRE_RATE
	SHIELD
}

var play_co_op = false
var player1_ability = ability.SHIELD
var player2_ability = ability.SHIELD

var player1
var player2

var have_turret = false
var have_rocket = false

func reset_all_status():
	 max_healt = 100
	 healt = 100
	 max_shield = 50
	 shield = 50
	 attack = 50

	 player_level = 1
	 player_max_exp = 50
	 player_exp = 0

	 stage = 1
	 level = 1

	 play_co_op = false
	 player1_ability = ability.DOBBLE_FIRE_RATE
	 player2_ability = ability.SHIELD

	 player1
	 player2

	 have_turret = false
	 have_rocket = false
