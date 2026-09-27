extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

var tracks: Dictionary = {
	"1": preload("res://Resources/Audio/1.mp3")
}

const sounds = {
}

const dialogues = {
}

const dialogueTexts = {
}

func _ready() -> void:
	add_child(player)
	player.bus = "Music"
	player.stream = tracks["1"]
	player.play()

func swap_track(track_name: String) -> void:
	if not tracks.has(track_name):
		return
	var current_position: float = player.get_playback_position()
	player.stream = tracks[track_name]
	player.bus = "Music"
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

func play_dialogue(sound_name: String): 
	if not dialogues.has(sound_name): 
		return
	for player in get_children(): 
		if not player.playing: 
			player.stream = dialogues[sound_name]
			player.bus = "Dialogue"
			player.play()
			GlobalPersistant.updateText(dialogueTexts[sound_name])
			return
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	new_player.stream = dialogues[sound_name]
	new_player.bus = "Dialogue"
	GlobalPersistant.updateText(dialogueTexts[sound_name])
	new_player.play()

func changeAudioVolume(master: float, sfx: float, music: float, dialogue: float): 
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master)) 
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx)) 
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music)) 
	var dialogue_bus = AudioServer.get_bus_index("Dialogue")
	AudioServer.set_bus_volume_db(dialogue_bus, linear_to_db(dialogue))
