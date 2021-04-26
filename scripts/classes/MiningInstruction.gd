extends Sprite

export var direction: Vector2

onready var _area2d: Area2D = $"./Area2D"

var _destroy_timeout: float = 1

func _input_event(viewport, event, shape_idx):
  if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && !event.pressed && _destroy_timeout <= 0 && Store.state.selected_placeable == "":
      Input.set_default_cursor_shape(Input.CURSOR_ARROW)
      queue_free()

func _mouse_entered():
  if Store.state.selected_placeable == "":
    Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _mouse_exited():
  if Store.state.selected_placeable == "":
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _process(delta):
  _destroy_timeout -= delta

func _ready():
  _area2d.connect("mouse_entered", self, "_mouse_entered")
  _area2d.connect("mouse_exited", self, "_mouse_exited")
  _area2d.connect("input_event", self, "_input_event")
