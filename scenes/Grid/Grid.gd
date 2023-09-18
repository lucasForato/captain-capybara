extends TileMap

enum CELL_TYPE {FLOOR, PLAYER, WALL, INVISIBLE_WALL, PORTAL}

func _ready():
	var tiles = get_used_cells_by_id(0)
	
	for child in get_children():
		set_cell(1, local_to_map(child.position), child.type)	
	
func request_move(pawn, direction):
	if direction == 'move_down':
		pawn.position.y += 16
		set_cell(1, local_to_map(pawn.position))			
	if direction == 'move_up':
		pawn.position.y -= 16
		set_cell(1, local_to_map(pawn.position))			
	if direction == 'move_left':
		pawn.position.x -= 16
		set_cell(1, local_to_map(pawn.position))			
	if direction == 'move_right':
		pawn.position.x += 16
		set_cell(1, local_to_map(pawn.position))			
