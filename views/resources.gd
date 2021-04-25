extends Control

onready var _money_label: Label = find_node("Money")

func _on_state_changed(state_key: String, substate):
  match state_key:
    "money":
      _money_label.text = "Gold: " + str(substate)

func _ready():
  Store.connect("state_changed", self, "_on_state_changed")
