extends Node

onready var _placeables: Array = Castledb.get_entries("placeables")

var _placeables_dictionary: Dictionary = {}

func buy() -> bool:
  var _selected_placeable = Store.state["selected_placeable"]

  if _selected_placeable == "":
    return false
  
  if _placeables_dictionary[_selected_placeable].cost <= Store.state.money:
    Store.set_state("money", Store.state.money - _placeables_dictionary[_selected_placeable].cost)
    return true

  return false

func _on_state_changed(state_key: String, substate):
  match state_key:
    "money":
      if Store.state.selected_placeable != "" && _placeables_dictionary[Store.state.selected_placeable].cost > substate:
        Store.set_state("selected_placeable", "")
    _:
      pass

func _ready():
  for _placeable in _placeables:
    _placeables_dictionary[_placeable.type] = _placeable

  Store.connect("state_changed", self, "_on_state_changed")
