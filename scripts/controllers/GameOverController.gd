extends Node

onready var _tree = get_tree()

func _process(delta):
  if Store.state.game == GameConstants.GAME_IN_PROGRESS:
    var _dwarves = _tree.get_nodes_in_group("Dwarves")

    if _dwarves.size() == 0:
      Store.set_state("game", GameConstants.GAME_OVER)
      Store.set_state("client_view", ClientConstants.CLIENT_VIEW_MAIN_MENU)
