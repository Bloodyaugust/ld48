extends Control

onready var _settings_button: Button = find_node("Settings")
onready var _instructions_button: Button = find_node("Instructions")
onready var _about_button: Button = find_node("About")
onready var _play_button: Button = find_node("Play")

func _on_settings_button_pressed() -> void:
  Store.set_state("client_view", ClientConstants.CLIENT_VIEW_SETTINGS)

func _on_instructions_button_pressed() -> void:
  Store.set_state("client_view", ClientConstants.CLIENT_VIEW_INSTRUCTIONS)

func _on_about_button_pressed() -> void:
  Store.set_state("client_view", ClientConstants.CLIENT_VIEW_ABOUT)

func _on_play_button_pressed() -> void:
  Store.start_game()

func _on_state_changed(state_key: String, substate):
  match state_key:
    "client_view":
      match substate:
        ClientConstants.CLIENT_VIEW_MAIN_MENU:
          rect_position.y = 0
          visible = true
        _:
          rect_position.y = get_viewport().size.y
          visible = false

func _ready():
  _settings_button.connect("pressed", self, "_on_settings_button_pressed")
  _instructions_button.connect("pressed", self, "_on_instructions_button_pressed")
  _about_button.connect("pressed", self, "_on_about_button_pressed")
  _play_button.connect("pressed", self, "_on_play_button_pressed")

  Store.connect("state_changed", self, "_on_state_changed")
