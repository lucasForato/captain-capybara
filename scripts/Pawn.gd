extends Node2D

enum CELL_TYPE {PLAYER, WALL, INVISIBLE_WALL, PORTAL}
@export var type: CELL_TYPE

func is_player() -> bool:
	return self.type == CELL_TYPE.PLAYER
