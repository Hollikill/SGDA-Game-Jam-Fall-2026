extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var sfx: AudioStreamPlayer = AudioStreamPlayer.new()

var tracks: Dictionary = {
	"1": preload("res://Resources/Audio/1.mp3")
}

const sounds = {
}

func _ready() -> void:
	add_child(player)
	player.stream = tracks["1"]
	player.play()

func swap_track(track_name: String) -> void:
	if not tracks.has(track_name):
		return
	var current_position: float = player.get_playback_position()
	player.stream = tracks[track_name]
	player.play(current_position)

func play_sfx(sound_name: String):
	if not sounds.has(sound_name):
		return
	for player in get_children():
		if not player.playing:
			player.stream = sounds[sound_name]
			player.bus = "SFX"
			player.play()
			return
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	new_player.stream = sounds[sound_name]
	new_player.bus = "SFX"
	new_player.play()

func changeAudioVolume(master: float, sfx: float, music: float): 
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master)) 
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx)) 
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music)) 
