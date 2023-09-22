extends TileMap

@onready var Camera = get_parent().get_parent()

enum CELL_TYPE {PLAYER, WALL, INVISIBLE_WALL, PORTAL, CRATE, EXIT}
# the orientation tells us which side of the camera is facing up
enum CAMERA_ORIENTATION {UP, RIGHT, DOWN, LEFT}

var orientation = CAMERA_ORIENTATION.UP

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
		set_cell(1, local_to_map(child.position), child.type, Vector2i(0, 0))


func get_cell_type_by_position(position: Vector2) -> int:
	var source_id = get_cell_source_id(1, local_to_map(position))
	return source_id
	
	
func move(pawn, direction):
	var target_position = get_target_position(pawn, direction)
	var type = self.get_cell_type_by_position(target_position)
	if type == CELL_TYPE.EXIT:
		emit_signal("exit")	
		
	erase_cell(1, local_to_map(pawn.position))
	pawn.set_position(target_position)
	set_cell(1, local_to_map(target_position), pawn.type, Vector2i(0, 0))


func request_move(pawn, direction) -> bool:
	var target_position = self.get_target_position(pawn, direction)
	var type = self.get_cell_type_by_position(target_position)
	
	if type == -1: 
		return true
	if type == CELL_TYPE.WALL:
		return false
	if type == CELL_TYPE.INVISIBLE_WALL:
		return true
	if type == CELL_TYPE.EXIT:
		return true
	else:
		return false

func _rotate(camera_orientation: CAMERA_ORIENTATION) -> void:
	orientation = camera_orientation
	
		
func get_target_position(pawn, direction) -> Vector2:
	var target = pawn.position
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



