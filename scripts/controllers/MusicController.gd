extends Node

onready var _track_tween: Tween = $"./track-tween"

var _current_track: int = -1
var _last_track: int = 0
var _track_transition: float = 0

func _on_store_state_changed(state_key: String, substate):
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_OVER:
          _play_track(0)
        GameConstants.GAME_STARTING:
          _play_track(1)
    "layer":
      match substate:
        8:
          _play_track(2)
        15:
          _play_track(3)

func _on_track_tween_completed(object, key):
  if _last_track != -1:
    get_node("./track-" + str(_last_track)).stop()

func _on_track_tween_step(object, key, elapsed, value):
  var _current_audio: AudioStreamPlayer = get_node("./track-" + str(_current_track))

  if _last_track != -1:
    var _last_audio: AudioStreamPlayer = get_node("./track-" + str(_last_track))
    _last_audio.volume_db = -lerp(0, 64, value)

  _current_audio.volume_db = -64 + lerp(0, 64, value)

func _play_track(index):
  _last_track = _current_track
  _current_track = index

  _track_tween.interpolate_property(self, "_track_transition", 0, 1, 5, Tween.TRANS_SINE)
  _track_tween.start()
  get_node("./track-" + str(_current_track)).play()

func _ready():
  _track_tween.connect("tween_completed", self, "_on_track_tween_completed")
  _track_tween.connect("tween_step", self, "_on_track_tween_step")
  Store.connect("state_changed", self, "_on_store_state_changed")
