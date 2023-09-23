extends TileMap

@onready var Camera = get_parent().get_parent()

enum CELL_TYPE {PLAYER, WALL, GATE, PORTAL, CRATE, EXIT, BOMB, CRACKED_WALL, FLOOR}
# the orientation tells us which side of the camera is facing up
enum CAMERA_ORIENTATION {UP, RIGHT, DOWN, LEFT}

var orientation = CAMERA_ORIENTATION.UP
#var Floor = load('res://scenes/Floor/Floor.tscn')
var stop_physics = false

signal exit

func is_camera_up() -> bool:
	return orientation == CAMERA_ORIENTATION.UP

func is_camera_down() -> bool:
	return orientation == CAMERA_ORIENTATION.DOWN

func is_camera_left() -> bool:
	return orientation == CAMERA_ORIENTATION.LEFT

func is_camera_right() -> bool:
	return orientation == CAMERA_ORIENTATION.RIGHT

func _ready():
	Camera.connect('change_orientation', Callable(self, "_rotate"))
	for child in get_children():
		if child.is_exit():
			set_cell(2, local_to_map(child.position), child.type, Vector2i(0, 0))
		else:
			set_cell(1, local_to_map(child.position), child.type, Vector2i(0, 0))

func get_cell_type_by_position(position: Vector2, layer: int) -> int:
	var source_id = get_cell_source_id(layer, local_to_map(position))
	return source_id

func is_exit(target: Vector2):
	var type = get_cell_type_by_position(target, 2)
	if type == CELL_TYPE.EXIT:
		return true
	return false	

func move(pawn, direction):
	var target_position = get_target_position(pawn.position, direction)
	var type = self.get_cell_type_by_position(target_position, 1)
	
	if type == -1:
		var exit = self.get_cell_type_by_position(target_position, 2)
		if exit == CELL_TYPE.EXIT and pawn.is_player():
			emit_signal('exit')
		
	self.erase_cell(1, local_to_map(pawn.position))
	pawn.set_position(target_position)
	set_cell(1, local_to_map(target_position), pawn.type, Vector2i(0, 0))

func stop():
	stop_physics = true

func restart():
	stop_physics = false

func request_move(pawn, direction) -> bool:
	if stop_physics == true:
		return false
	var target_position = self.get_target_position(pawn.position, direction)
	var type = self.get_cell_type_by_position(target_position, 1)
	
	if type == -1: 
		return true
	if type == CELL_TYPE.WALL:
		return false
	if type == CELL_TYPE.GATE:
		return true
	if type == CELL_TYPE.EXIT:
		return true
	if type == CELL_TYPE.FLOOR:
		return true
	else:
		return false

func get_cells_around(pawn) -> Array:
	var up = pawn.position
	up.y -= 16
	var down = pawn.position
	down.y += 16
	var left = pawn.position
	left.x -= 16
	var right = pawn.position
	right.x += 16
	var up_left = up
	up_left.x -= 16
	var up_right = up
	up_right.x += 16
	var down_left = down
	down_left.x -= 16
	var down_right = down
	down_right.x -= 16
	return [up, up_right, up_left, left, right, down, down_left, down_right]
	
func get_cracked_walls_around(pawn) -> Array:	
	var positions: Array = []
	
	var cells = get_cells_around(pawn)
	
	for cell in cells:
		var type = self.get_cell_type_by_position(cell, 1)
		
		if type == CELL_TYPE.CRACKED_WALL:
			positions.append(cell)
	return positions

func get_node_by_position(position: Vector2):
	for node in get_children():
		if node.position == position:
			return node

func explode_bomb(pawn):
	var cracked_wall_positions = get_cracked_walls_around(pawn)
	self.erase_cell(1, local_to_map(pawn.position))
	remove_child(pawn)
	for position in cracked_wall_positions:
		self.erase_cell(1, local_to_map(position))
		var cracked_wall = get_node_by_position(position)
		remove_child(cracked_wall)

func _rotate(camera_orientation: CAMERA_ORIENTATION) -> void:
	orientation = camera_orientation
		
func get_target_position(position: Vector2, direction: String) -> Vector2:
	var target = position
	if direction == 'move_up':
		if is_camera_up():
			target.y -= 16
		if is_camera_down():
			target.y += 16
		if is_camera_left():
			target.x += 16
		if is_camera_right():
			target.x -= 16
	if direction == 'move_right':
		if is_camera_up():
			target.x += 16
		if is_camera_down():
			target.x -= 16
		if is_camera_left():
			target.y += 16
		if is_camera_right():
			target.y -= 16
	if direction == 'move_down':
		if is_camera_up():
			target.y += 16
		if is_camera_down():
			target.y -= 16
		if is_camera_left():
			target.x -= 16
		if is_camera_right():
			target.x += 16
	if direction == 'move_left':
		if is_camera_up():
			target.x -= 16
		if is_camera_down():
			target.x += 16
		if is_camera_left():
			target.y -= 16
		if is_camera_right():
			target.y += 16
	
	return target



