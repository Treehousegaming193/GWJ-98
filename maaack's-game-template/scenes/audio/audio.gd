extends Node

const MAX_DB: float = -6.0

const TRACKS: Dictionary = {
	"level": "uid://cu20jvok0tvf7",
}

var active_music_player_index: int = 0
var current_music_player: AudioStreamPlayer

@onready var music_players : Array[AudioStreamPlayer] = [$MusicPlayer1, $MusicPlayer2]


func _ready() -> void:
	pass


func play_track(track_name: String = "", fade_time: float = 2.0) -> void:
	var stream: AudioStream
	if track_name in TRACKS.keys():
		stream = load(TRACKS[track_name])
	else:
		stream = load(TRACKS[TRACKS.keys().pick_random()])
	if music_players[active_music_player_index].playing:
		fade_out(music_players[active_music_player_index], fade_time)
	active_music_player_index = wrapi(active_music_player_index + 1, 0, music_players.size())
	current_music_player = music_players[active_music_player_index]
	current_music_player.volume_linear = 0
	current_music_player.stream = stream
	current_music_player.play()
	fade_in(current_music_player, fade_time)


func fade_out(player: AudioStreamPlayer = current_music_player, seconds: float = 2.0) -> void:
	if not is_instance_valid(player):
		return
	var fade_out_tween: Tween = create_tween()
	fade_out_tween.tween_method(
		func(x: float) -> void: player.volume_db = linear_to_db(x),
		db_to_linear(player.volume_db),
		0.0,
		seconds
	)
	fade_out_tween.finished.connect(player.stop)


func fade_in(player: AudioStreamPlayer = current_music_player, seconds: float = 2.0) -> void:
	if not is_instance_valid(player):
		return
	var fade_in_tween: Tween = create_tween()
	player.stop()
	player.volume_db = linear_to_db(0.0)
	player.play()
	fade_in_tween.tween_method(
		func(x: float) -> void: player.volume_db = linear_to_db(x),
		db_to_linear(player.volume_db),
		db_to_linear(MAX_DB),
		seconds
	)
