extends Node2D

enum CELL_TYPE {PLAYER, WALL, INVISIBLE_WALL, PORTAL, CRATE, EXIT}
@export var type: CELL_TYPE

func is_player() -> bool:
	return self.type == CELL_TYPE.PLAYER

func is_exit() -> bool:
	return self.type == CELL_TYPE.EXIT
