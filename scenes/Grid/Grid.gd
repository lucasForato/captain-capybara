extends TileMap

enum CELL_TYPE {PLAYER, WALL, INVISIBLE_WALL, PORTAL}

@onready var camera = get_parent()

func _ready():
	for child in get_children():
		set_cell(1, local_to_map(child.position), child.type, Vector2i(0, 0))


func get_cell_type_by_position(position: Vector2) -> int:
	var source_id = get_cell_source_id(1, local_to_map(position))
	return source_id
	
	
func move(pawn, direction):
	var target_position = get_target_position(pawn, direction)
	erase_cell(1, local_to_map(pawn.position))
	pawn.set_position(target_position)
	set_cell(1, local_to_map(target_position), pawn.type, Vector2i(0, 0))
	
	
func request_move(pawn, direction) -> bool:
	if not pawn.is_player():	
		return false
	
	var target_position = self.get_target_position(pawn, direction)
	var type = self.get_cell_type_by_position(target_position)
	
	if type == CELL_TYPE.WALL:
		return false
	if type == CELL_TYPE.INVISIBLE_WALL:
		return true
	if type == -1:
		return true
	else:
		return false

		
func get_target_position(pawn, direction) -> Vector2:
	var target = pawn.position	
	if direction == 'move_right':
		target.x += 16
	if direction == 'move_left':
		target.x -= 16
	if direction == 'move_up':
		target.y -= 16
	if direction == 'move_down':
		target.y += 16
	return target


