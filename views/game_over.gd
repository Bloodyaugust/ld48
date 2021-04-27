extends Control

onready var _win_state_label: Label = find_node("WinState")
onready var _main_menu_button: Button = find_node("MainMenu")

func _on_main_menu_button_pressed() -> void:
    Store.set_state("game", GameConstants.GAME_OVER)
    Store.set_state("client_view", ClientConstants.CLIENT_VIEW_MAIN_MENU)

func _on_state_changed(state_key: String, substate):
  match state_key:
    "client_view":
      match substate:
        ClientConstants.CLIENT_VIEW_GAME_OVER:
          _win_state_label.text = "You delved deeply, but did you win? (yes)" if Store.state.layer >= 22 else "You have failed, your Dwarven ancestors look upon you with scorn."
          rect_position.y = 0
          visible = true
        _:
          rect_position.y = get_viewport().size.y
          visible = false

func _ready():
  _main_menu_button.connect("pressed", self, "_on_main_menu_button_pressed")

  Store.connect("state_changed", self, "_on_state_changed")
