extends Node2D

onready var _placeables: Array = Castledb.get_entries("placeables");
onready var _player_shop_controller: Node = get_tree().get_root().find_node("PlayerShopController", true, false)

var _placeable_scenes: Dictionary = {}

func _input(event):
  if event is InputEventMouseButton && event.button_index == 1 && !event.pressed:
    if _player_shop_controller.buy():
      # Buy the selected thing and place it
      var _new_actor = _placeable_scenes[Store.state["selected_placeable"]].instance()

      _new_actor.global_position = get_global_mouse_position()
      get_tree().get_root().add_child(_new_actor)

func _ready():
  for _placeable in _placeables:
    match _placeable.type:
      "cask":
        _placeable_scenes["cask"] = load("res://actors/Ale.tscn")
      "dwarf":
        _placeable_scenes["dwarf"] = load("res://actors/Dwarf.tscn")
      _:
        pass
