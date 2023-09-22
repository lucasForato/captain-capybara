extends Node2D

enum CELL_TYPE {PLAYER, WALL, GATE, PORTAL, CRATE, EXIT, BOMB, CRACKED_WALL, FLOOR}
@export var type: CELL_TYPE

func is_player() -> bool:
	return self.type == CELL_TYPE.PLAYER

func is_exit() -> bool:
	return self.type == CELL_TYPE.EXIT

func is_bomb() -> bool:
	return self.type == CELL_TYPE.BOMB

func is_cracked_wall() -> bool:
	return self.type == CELL_TYPE.CRACKED_WALL

func is_gate() -> bool:
	return self.type == CELL_TYPE.GATE
