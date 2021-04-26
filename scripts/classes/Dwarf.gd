extends RigidBody2D

enum DWARF_STATE {
  IDLE,
  DRINKING,
  MINING,
  VALUABLES,
  WANDERING,
}

export var drink_rate: float
export var drink_range: float
export var drink_threshold: float
export var mine_amount: float
export var mine_stamina_cost: float
export var mine_time: float
export var starting_health: float
export var stamina_regen_rate: float
export var stamina_max: float
export var thirst_rate: float

onready var _animation_player: AnimationPlayer = $"./BodyContainer/AnimationPlayer"
onready var _body_container: Node2D = $"./BodyContainer"
onready var _cast_up: RayCast2D = $"./CastUp"
onready var _health: float = starting_health
onready var _mine_cast_down: RayCast2D = $"./MineCastDown"
onready var _mine_cast_left: RayCast2D = $"./MineCastLeft"
onready var _mine_cast_right: RayCast2D = $"./MineCastRight"
onready var _sprite_body: Sprite = $"./BodyContainer/Body"
onready var _sprite_head: Sprite = $"./BodyContainer/Head"
onready var _sprite_leg: Sprite = $"./BodyContainer/Leg"
onready var _sprite_tool: Sprite = $"./BodyContainer/Arm/Tool"
onready var _sprite_arm: Sprite = $"./BodyContainer/Arm"
onready var _state: int = DWARF_STATE.IDLE
onready var _tree: SceneTree = get_tree()

var _closest_valuable: Node2D = null
var _drinking_target: Node2D
var _mining_time_left: float = 0
var _stamina: float = 0
var _mining_target: Node2D
var _thirst: float = 0
var _wander_time: float
var _wander_direction: Vector2

func damage(amount: float):
  _health -= amount

func randomize_mine_sfx_pitch():
  $"./sfx-mine".pitch_scale = rand_range(1, 1.5)

func _idle():
  _drinking_target = null
  _mining_target = null
  _animation_player.play("idle")
  _state = DWARF_STATE.IDLE

func _set_facing(is_right):
  if is_right:
    _body_container.scale.x = -1
  else:
    _body_container.scale.x = 1

func _seek_valuables():
  _animation_player.play("valuables")
  _state = DWARF_STATE.VALUABLES

func _start_drinking():
  _animation_player.play("drink")
  _state = DWARF_STATE.DRINKING

func _start_mining():
  _mining_time_left = mine_time
  _stamina -= mine_stamina_cost
  _animation_player.play("mine")
  _state = DWARF_STATE.MINING

func _integrate_forces(state):
  if _state == DWARF_STATE.WANDERING && _mine_cast_down.is_colliding():
    linear_velocity.x = _wander_direction.x * 100

  if (_state == DWARF_STATE.DRINKING &&
    _mine_cast_down.is_colliding() &&
    is_instance_valid(_drinking_target) &&
    !_drinking_target.is_queued_for_deletion() &&
    abs(global_position.x - _drinking_target.global_position.x) > drink_range):
    linear_velocity.x = (1 if _drinking_target.global_position.x > global_position.x else -1) * 200

  if (_state == DWARF_STATE.VALUABLES &&
    _mine_cast_down.is_colliding() &&
    is_instance_valid(_closest_valuable) &&
    !_closest_valuable.is_queued_for_deletion() &&
    (!_mine_cast_right.is_colliding() || !_mine_cast_left.is_colliding())):
    linear_velocity.x = (1 if _closest_valuable.global_position.x > global_position.x else -1) * 250

  _set_facing(linear_velocity.x > 0)

func _physics_process(delta):
  if _cast_up.is_colliding() && abs(linear_velocity.y) <= 5:
    apply_central_impulse(Vector2.DOWN * 1000)

  if !_mine_cast_down.is_colliding():
    if _mine_cast_left.is_colliding():
      apply_central_impulse(Vector2.RIGHT * 100)
    elif _mine_cast_right.is_colliding():
      apply_central_impulse(Vector2.LEFT * 100)
    elif get_colliding_bodies().size() >= 1 && !_cast_up.is_colliding():
      apply_central_impulse((Vector2.UP + Vector2(rand_range(-0.45, 0.45), 0)).normalized() * 1000)

func _process(delta):
  _closest_valuable = _get_closest_valuable()

  if _state != DWARF_STATE.DRINKING:
    _thirst += delta * thirst_rate

  if _state == DWARF_STATE.IDLE || _state == DWARF_STATE.WANDERING:
    _stamina = clamp(_stamina + (stamina_regen_rate * delta), 0, stamina_max)

  if (_state == DWARF_STATE.IDLE || _state == DWARF_STATE.WANDERING) && _thirst >= drink_threshold:
    _start_drinking()

  if (_state == DWARF_STATE.IDLE || _state == DWARF_STATE.WANDERING) && is_instance_valid(_closest_valuable) && !_closest_valuable.is_queued_for_deletion():
    _seek_valuables()

  if _state == DWARF_STATE.VALUABLES:
    if is_instance_valid((_closest_valuable)) && !_closest_valuable.is_queued_for_deletion():
      if _mine_cast_left.is_colliding():
        _mining_target = _mine_cast_left.get_collider().get_parent()
        _start_mining()
      elif _mine_cast_right.is_colliding():
        _mining_target = _mine_cast_right.get_collider().get_parent()
        _start_mining()
    else:
      _idle()

  if _state == DWARF_STATE.DRINKING:
    var _ales = _get_ales_sorted_distance()

    if _ales.size() > 0:
      _drinking_target = _ales[0]

    if is_instance_valid((_drinking_target)) && !_drinking_target.is_queued_for_deletion():
      if global_position.distance_to(_drinking_target.global_position) <= drink_range:
        _thirst = clamp(_thirst - _drinking_target.drink(drink_rate * delta), 0, 100)
      else:
        if _mine_cast_left.is_colliding():
          _mining_target = _mine_cast_left.get_collider().get_parent()
          _start_mining()
        elif _mine_cast_right.is_colliding():
          _mining_target = _mine_cast_right.get_collider().get_parent()
          _start_mining()

    if _thirst == 0:
      _idle()

  if _state == DWARF_STATE.WANDERING:
    _wander_time = clamp(_wander_time - delta, 0, 5)

    if _wander_time == 0:
      _idle()

  if _state == DWARF_STATE.MINING:
    _mining_time_left = clamp(_mining_time_left - delta, 0, mine_time)

    if !is_instance_valid(_mining_target) || _mining_target.is_queued_for_deletion() || !_mining_target.has_method("mine"):
      _idle()

    if _mining_time_left == 0 && _mining_target:
      _mining_target.mine(mine_amount)
      apply_central_impulse((Vector2.UP + Vector2(rand_range(-0.15, 0.15), 0)).normalized() * rand_range(600, 2100))
      _idle()

  if _state == DWARF_STATE.IDLE:
    if _stamina >= mine_stamina_cost:
      var _mining_target_block_collider = _mine_cast_down.get_collider()

      if _mining_target_block_collider:
        _mining_target = _mining_target_block_collider.get_parent()
        _start_mining()
    else:
      _wander()

  if _health <= 0:
    queue_free()

func _ready():
  _stamina = rand_range(0, stamina_max)
  _thirst = rand_range(drink_threshold / 2, drink_threshold - 1)
  _idle()

func _get_closest_valuable() -> Node2D:
  var _valuables: Array = _tree.get_nodes_in_group("Valuables")
  var _valuables_in_layer: Array = []

  for _valuable in _valuables:
    if abs(_valuable.global_position.y - global_position.y) < 32:
      _valuables_in_layer.append(_valuable)

  if _valuables_in_layer.size() > 0:
    _valuables_in_layer.sort_custom(self, "_sort_by_distance")
    return _valuables_in_layer[0]

  return null

func _wander():
  var _wander_direction_randomizer = randi() % 3
  _wander_time = rand_range(0, 2.5)

  match _wander_direction_randomizer:
    0:
      _wander_direction = Vector2.LEFT
    1:
      _wander_direction = Vector2.RIGHT
    _:
      _wander_direction = Vector2.ZERO

  _state = DWARF_STATE.WANDERING

func _get_ales_sorted_distance() -> Array:
  var _ales: Array = _tree.get_nodes_in_group("Ale")

  if _ales.size() > 0:
    _ales.sort_custom(self, "_sort_by_distance")

  return _ales

func _sort_by_distance(a: Node2D, b: Node2D) -> bool:
  return a.global_position.distance_squared_to(global_position) < b.global_position.distance_squared_to(global_position)
