extends RigidBody2D

export var starting_ale: float

onready var _ale: float = starting_ale

var _dragging: bool = false

func drink(amount: float) -> float:
  var _drank: float = clamp(amount, 0, _ale)
  _ale -= _drank

  if _ale == 0:
    queue_free()

  return _drank

func _input_event(viewport, event, shape_idx):
  if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && Store.state.selected_placeable == "":
    if event.pressed:
      _dragging = true
      Input.set_default_cursor_shape(Input.CURSOR_MOVE)
    else:
      _dragging = false
      Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _integrate_forces(state):
  linear_velocity = linear_velocity.clamped(500)

func _mouse_entered():
  if !_dragging && Store.state.selected_placeable == "":
    Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _mouse_exited():
  if !_dragging && Store.state.selected_placeable == "":
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _physics_process(delta):
  if _dragging:
    var _force_scalar: float = lerp(5, 50, get_global_mouse_position().distance_to(global_position) / 6)
    apply_central_impulse((get_global_mouse_position() - global_position).normalized() * _force_scalar)

func _ready():
  self.connect("mouse_entered", self, "_mouse_entered")
  self.connect("mouse_exited", self, "_mouse_exited")

func _unhandled_input(event):
  if _dragging && event is InputEventMouseButton && event.button_index == BUTTON_LEFT && !event.pressed:
    _dragging = false
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)
