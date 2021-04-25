extends Node

signal state_changed(state_key, substate)

var state: Dictionary = {
  "client_view": "",
  "game": "",
  "money": 0,
  "selected_placeable": ""
 }

func set_state(state_key: String, new_state) -> void:
  state[state_key] = new_state
  emit_signal("state_changed", state_key, state[state_key])
  print("State changed: ", state_key, " -> ", state[state_key])
  
func _initialize():
  set_state("client_view", ClientConstants.CLIENT_VIEW_MAIN_MENU)
  set_state("game", GameConstants.GAME_OVER)
  set_state("money", 10)
  set_state("selected_placeable", "cask")

func _ready():
  call_deferred("_initialize")
