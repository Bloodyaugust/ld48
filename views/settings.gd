extends Control

onready var _sfx_volume_slider: HSlider = find_node("SFXVolume")
onready var _music_volume_slider: HSlider = find_node("MusicVolume")
onready var _main_menu_button: Button = find_node("MainMenu")

func _on_main_menu_button_pressed() -> void:
  Store.set_state("client_view", ClientConstants.CLIENT_VIEW_MAIN_MENU)

func _on_sfx_volume_value_changed(value) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), lerp(-32, 0, value))
  AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), value == 0)

func _on_music_volume_value_changed(value) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lerp(-32, 1.5, value))
  AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), value == 0)

func _on_state_changed(state_key: String, substate):
  match state_key:
    "client_view":
      match substate:
        ClientConstants.CLIENT_VIEW_SETTINGS:
          rect_position.y = 0
          visible = true
        _:
          rect_position.y = get_viewport().size.y
          visible = false

func _ready():
  _sfx_volume_slider.connect("value_changed", self, "_on_sfx_volume_value_changed")
  _music_volume_slider.connect("value_changed", self, "_on_music_volume_value_changed")
  _main_menu_button.connect("pressed", self, "_on_main_menu_button_pressed")

  Store.connect("state_changed", self, "_on_state_changed")
