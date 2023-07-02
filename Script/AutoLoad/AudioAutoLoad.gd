extends Node

onready var shoot_stream_player = $AudioStreamPlayer

func play_shoot_sound():
	shoot_stream_player.play()

func stop_shoot_sound():
	shoot_stream_player.stop()

func dobble_shoot_sound():
	shoot_stream_player.pitch_scale = 2.2

func back_to_singgle_shoot_sound():
	shoot_stream_player.pitch_scale = 1.1
