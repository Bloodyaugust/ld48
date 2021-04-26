extends Node

onready var _ale_scene: PackedScene = preload("res://actors/Ale.tscn")
onready var _dwarf_scene: PackedScene = preload("res://actors/Dwarf.tscn")
onready var _dwarves_container: Node2D = $"../Dwarves"
onready var _placeables_container: Node2D = $"../Placeables"

func _on_store_state_changed(state_key: String, substate):
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_STARTING:
          for _i in range(5):
            var _new_dwarf = _dwarf_scene.instance()

            _new_dwarf.global_position = Vector2(rand_range(-400, 400), rand_range(-300, -400))
            _dwarves_container.add_child(_new_dwarf)

          var _new_ale = _ale_scene.instance()

          _new_ale.global_position = Vector2(rand_range(-400, 400), rand_range(-300, -400))
          _placeables_container.add_child(_new_ale)

          Store.call_deferred("set_state", "game", GameConstants.GAME_IN_PROGRESS)
        GameConstants.GAME_OVER:
          GDUtil.queue_free_children(_dwarves_container)
          GDUtil.queue_free_children(_placeables_container)

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")
