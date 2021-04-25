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

func _ready():
  for _placeable in _placeables:
    _placeables_dictionary[_placeable.type] = _placeable
