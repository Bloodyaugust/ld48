extends Sprite

var _data: Dictionary
var _health: float
var _value: float

func initialize(type: String) -> void:
  _data = Castledb.get_entry("terrain", type)
  texture = load("res://sprites/terrain/{type}.png".format({"type": type}))

  _health = _data.health
  _value = _data.value

func mine(damage: float) -> void:
  if _health > 0 && _health - damage <= 0:
    if _value > 0:
      Store.set_state("money", Store.state.money + _value)
    queue_free()

  _health -= damage
