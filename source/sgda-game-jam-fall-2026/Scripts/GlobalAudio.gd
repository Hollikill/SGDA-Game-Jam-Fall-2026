extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

var tracks: Dictionary = {
	"1": preload("res://Resources/Audio/1.mp3")
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
