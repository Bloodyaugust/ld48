extends RigidBody2D

export var starting_ale: float

onready var _ale: float = starting_ale

func drink(amount: float) -> float:
  var _drank: float = clamp(_ale - amount, 0, amount)
  _ale -= _drank

  if _ale == 0:
    queue_free()

  return _drank
