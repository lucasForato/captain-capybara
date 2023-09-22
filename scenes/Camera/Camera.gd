extends Camera2D

enum CAMERA_ORIENTATION {UP, RIGHT, DOWN, LEFT}

func is_up():
	return camera_orientation == CAMERA_ORIENTATION.UP
	
func is_down():
	return camera_orientation == CAMERA_ORIENTATION.DOWN
	
func is_left():
	return camera_orientation == CAMERA_ORIENTATION.LEFT

func is_right():
	return camera_orientation == CAMERA_ORIENTATION.RIGHT

var camera_orientation: CAMERA_ORIENTATION

signal change_orientation(orientation)

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_orientation = 0

func _input(event: InputEvent):
	if event.is_action_pressed("turn_left"):
		rotate(1.5708)
		if camera_orientation == 0:
			camera_orientation = 3
		else:
			camera_orientation -= 1
	
		
	if event.is_action_pressed("turn_right"):
		rotate(-1.5708)		
		if camera_orientation == 3:
			camera_orientation = 0
		else:
			camera_orientation += 1
	
	emit_signal("change_orientation", camera_orientation)
	
func reset():
	camera_orientation = CAMERA_ORIENTATION.UP
	self.rotation = 0
			
