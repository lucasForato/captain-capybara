extends TileMap

@onready var Camera = get_parent().get_parent()

enum CELL_TYPE {PLAYER, WALL, INVISIBLE_WALL, PORTAL, CRATE, EXIT, BOMB, CRACKED_WALL, FLOOR}
# the orientation tells us which side of the camera is facing up
enum CAMERA_ORIENTATION {UP, RIGHT, DOWN, LEFT}

var orientation = CAMERA_ORIENTATION.UP
#var Floor = load('res://scenes/Floor/Floor.tscn')

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
	var is_exit = self.is_exit(target_position)

	if is_exit and pawn.type == CELL_TYPE.PLAYER:
		emit_signal('exit')
		
	self.erase_cell(1, local_to_map(pawn.position))
	pawn.set_position(target_position)
	set_cell(1, local_to_map(target_position), pawn.type, Vector2i(0, 0))


func request_move(pawn, direction) -> bool:
	var target_position = self.get_target_position(pawn.position, direction)
	var type = self.get_cell_type_by_position(target_position, 1)
	
	if type == -1: 
		return true
	if type == CELL_TYPE.WALL:
		return false
	if type == CELL_TYPE.INVISIBLE_WALL:
		return true
	if type == CELL_TYPE.EXIT:
		return true
	if type == CELL_TYPE.FLOOR:
		return true
	else:
		return false

func get_cracked_walls_around(pawn) -> Array:
	var target_up = self.get_target_position(pawn.position, 'move_up')
	var target_up_left = self.get_target_position(target_up, 'move_left')
	var target_up_right = self.get_target_position(target_up, 'move_right')
	var target_down = self.get_target_position(pawn.position, 'move_down')
	var target_down_left = self.get_target_position(target_down, 'move_down')
	var target_down_right = self.get_target_position(target_down, 'move_down')
	var target_left = self.get_target_position(pawn.position, 'move_left')
	var target_right = self.get_target_position(pawn.position, 'move_right')
	var targets = [
		target_up, 
		target_up_left, 
		target_left, 
		target_down_left, 
		target_down, 
		target_down_right, 
		target_right,
		target_up_right
	]
	
	var positions: Array = []
	
	for target in targets:
		var type = self.get_cell_type_by_position(target, 1)
		
		if type == CELL_TYPE.CRACKED_WALL:
			positions.append(target)
	return positions

func get_cracked_wall_by_position(position: Vector2):
	for node in get_children():
		if node.position == position:
			return node

func explode_bomb(pawn):
	var cracked_wall_positions = get_cracked_walls_around(pawn)
	
	for position in cracked_wall_positions:
		self.erase_cell(1, local_to_map(position))
		var node = get_cracked_wall_by_position(position)
		remove_child(node)

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



