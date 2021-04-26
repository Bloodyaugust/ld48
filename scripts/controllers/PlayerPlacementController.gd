extends Node2D

onready var _area_placeable_detector: Area2D = $"./Area2D"
onready var _dwarves_container: Node2D = $"../Dwarves"
onready var _placeables: Array = Castledb.get_entries("placeables")
onready var _placeables_container: Node2D = $"../Placeables"
onready var _player_shop_controller: Node = get_tree().get_root().find_node("PlayerShopController", true, false)

var _placeable_scenes: Dictionary = {}

func _unhandled_input(event):
  if event is InputEventMouseButton && event.button_index == 1 && !event.pressed && _area_placeable_detector.get_overlapping_bodies().size() == 0:
    var _buying_placeable: String = Store.state.selected_placeable

    if _player_shop_controller.buy():
      # Buy the selected thing and place it
      var _new_actor = _placeable_scenes[_buying_placeable].instance()

      _new_actor.global_position = get_global_mouse_position()
      match _buying_placeable:
        "dwarf":
          _dwarves_container.add_child(_new_actor)
        _:
          _placeables_container.add_child(_new_actor)

      Store.set_state("selected_placeable", "")

func _on_store_state_changed(state_key: String, substate):
  match state_key:
    "selected_placeable":
      match substate:
        "":
          Input.set_default_cursor_shape(Input.CURSOR_ARROW)
        _:
          Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _process(delta):
  _area_placeable_detector.global_position = get_global_mouse_position()

  if Store.state.selected_placeable != "":
    if _area_placeable_detector.get_overlapping_bodies().size() == 0:
      Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
    else:
      Input.set_default_cursor_shape(Input.CURSOR_FORBIDDEN)

func _ready():
  for _placeable in _placeables:
    match _placeable.type:
      "cask":
        _placeable_scenes["cask"] = load("res://actors/Ale.tscn")
      "dwarf":
        _placeable_scenes["dwarf"] = load("res://actors/Dwarf.tscn")
      _:
        pass
