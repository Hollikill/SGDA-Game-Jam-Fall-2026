extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

var tracks: Dictionary = {
	"1": preload("res://Resources/Audio/Constellation.mp3"),
	"2": preload("res://Resources/Audio/Street_Lamp_Butterfly.mp3"),
	"3": preload("res://Resources/Audio/ConstellationOdd.mp3"),
	"4": preload("res://Resources/Audio/Street_Lamp_Butterfly_Odd.mp3")
}

const sounds = {
}

const dialogues = {
"1": preload("res://Resources/Audio/Constellation.mp3")
}

const dialogueTexts = {
"1": "This is some test dialogue. Press LMB to attack/disable this message"
}

var last_music_playing = "";

func _ready() -> void:
	add_child(player)
	player.bus = "Music"
	player.stream = tracks["1"]
	player.stream.loop = true
	player.play()
	last_music_playing = "1"

func swap_track(track_name: String) -> void:
	if not tracks.has(track_name):
		return
	player.bus = "Music"
	var current_position: float = player.get_playback_position()
	player.stream = tracks[track_name]
	last_music_playing = track_name
	player.play()

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
	if dialogues.has(sound_name):
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
		new_player.play()
	if dialogueTexts.has(sound_name):
		GlobalPersistant.updateText(dialogueTexts[sound_name])

func changeAudioVolume(master: float, sfx: float, music: float, dialogue: float): 
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master)) 
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx)) 
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music)) 
	var dialogue_bus = AudioServer.get_bus_index("Dialogue")
	AudioServer.set_bus_volume_db(dialogue_bus, linear_to_db(dialogue))

func _process(delta: float) -> void:
	if (!GlobalPersistant.loading_rooms):
		if (GlobalPersistant.flags.size() >= 3 && last_music_playing == "1"):
			swap_track("2")
		if (GlobalPersistant.flags.size() >= 8 && last_music_playing == "2"):
			swap_track("3")
		if (GlobalPersistant.flags.size() >= 13 && last_music_playing == "3"):
			swap_track("4")
