extends Control

onready var _placeables: Array = Castledb.get_entries("placeables")
onready var _placeables_container: HBoxContainer = $"./PlaceablesContainer"
onready var _placeables_textures: Array = _placeables_container.get_children()

var _placeables_dictionary: Dictionary = {}

func _handle_placeable_input(event: InputEvent, placeable: String):
  if event is InputEventMouseButton && event.button_index == 1 && !event.pressed && _placeables_dictionary[placeable].cost <= Store.state.money:
    Store.set_state("selected_placeable", placeable)

func _update_placeable_textures():
  for _placeable_texture in _placeables_textures:
    if _placeables_dictionary[_placeable_texture.name].cost <= Store.state.money:
      _placeable_texture.self_modulate = Color.white
    else:
      _placeable_texture.self_modulate = Color.darkslategray

    if Store.state.selected_placeable == _placeable_texture.name:
      _placeable_texture.find_node("selected").visible = true
      print("Showing selected for: ", _placeable_texture.name)
    else:
      _placeable_texture.find_node("selected").visible = false
      print("Hiding selected for: ", _placeable_texture.name)

func _on_state_changed(state_key: String, substate):
  match state_key:
    "money":
      _update_placeable_textures()
    "selected_placeable":
      _update_placeable_textures()
    _:
      pass

func _ready():
  for _placeable in _placeables:
    _placeables_dictionary[_placeable.type] = _placeable

  for _placeable_texture in _placeables_textures:
    _placeable_texture.connect("gui_input", self, "_handle_placeable_input", [_placeable_texture.name])

  _update_placeable_textures()

  Store.connect("state_changed", self, "_on_state_changed")
