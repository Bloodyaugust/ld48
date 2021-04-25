extends Node

onready var _layer_scene: PackedScene = preload("res://actors/Layer.tscn");
onready var _terrain_layers: Node2D = $"../TerrainLayers"

var _current_layer: int = 0

func _generate_layer():
  var _new_layer: Node2D = _layer_scene.instance()
  var _terrain: Array = _new_layer.find_node("Terrain", true, false).get_children()

  for _tile in _terrain:
    _tile.initialize("dirt")

  _new_layer.translate(Vector2(0, 64 + (_current_layer * 128)))
  _terrain_layers.add_child(_new_layer)

  _current_layer += 1

func _ready():
  _generate_layer()
  _generate_layer()
  _generate_layer()
  _generate_layer()
