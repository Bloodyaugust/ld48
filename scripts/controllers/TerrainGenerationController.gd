extends Node

const weighted_table = preload("res://lib/chance/WeightedTable.gd")

onready var _layer_scene: PackedScene = preload("res://actors/Layer.tscn");
onready var _next_layer_indicator: Sprite = $"../NextLayerIndicator"
onready var _terrain_data: Array = Castledb.get_entries("terrain")
onready var _terrain_layers: Node2D = $"../TerrainLayers"

var _current_layer: int = 0

func _generate_layer():
  var _new_layer: Node2D = _layer_scene.instance()
  var _terrain_table = weighted_table.new()
  var _terrain: Array = _new_layer.find_node("Terrain", true, false).get_children()
  var _valid_terrain: Array = []

  for _tile in _terrain_data:
    if _current_layer >= _tile.depthRange[0] && _current_layer <= _tile.depthRange[1]:
      _valid_terrain.append(_tile)

  _terrain_table.initialize_table(_valid_terrain)

  for _tile in _terrain:
    _tile.initialize(_terrain_table.pick().type)
    _tile.connect("mined", self, "_on_tile_mined")

  _new_layer.translate(Vector2(0, 64 + (_current_layer * 128)))
  _terrain_layers.add_child(_new_layer)

  _next_layer_indicator.translate(Vector2(0, 128))

  _current_layer += 1

func _on_tile_mined(y_position: float):
  if y_position / 128 >= _current_layer:
    _generate_layer()

func _ready():
  _generate_layer()
