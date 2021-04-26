extends Sprite

signal mined

onready var _area2d: Area2D = $"./Area2D"

var _damage: float
var _health: float
var _value: float

func initialize(type: String) -> void:
  var _data: Dictionary = Castledb.get_entry("terrain", type)
  texture = load("res://sprites/terrain/{type}.png".format({"type": type}))

  _damage = _data.damage
  _health = _data.health
  _value = _data.value

  if _value > 0:
    add_to_group("Valuables")

func mine(damage: float) -> void:
  if _health > 0 && _health - damage <= 0:
    if _value > 0:
      Store.set_state("money", Store.state.money + _value)
    
    emit_signal("mined", global_position.y)
    queue_free()

  _health -= damage

func _process(delta):
  if _damage > 0:
    var _overlapping_dwarves = _area2d.get_overlapping_bodies()

    for _dwarf in _overlapping_dwarves:
      if _dwarf.has_method("damage"):
        _dwarf.damage(_damage * delta)
