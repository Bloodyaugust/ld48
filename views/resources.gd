extends Control

onready var _money_label: Label = find_node("Money")

func _on_state_changed(state_key: String, substate):
  match state_key:
    "money":
      _money_label.text = "Gold: " + str(substate)
    "game":
      match substate:
        GameConstants.GAME_OVER:
          visible = false
        GameConstants.GAME_IN_PROGRESS:
          visible = true

func _ready():
  Store.connect("state_changed", self, "_on_state_changed")
