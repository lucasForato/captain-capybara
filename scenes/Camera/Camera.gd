extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event: InputEvent):
	var event_name: String
	if event.is_action_pressed("turn_left"):
		emit_signal("rotate", "left")
		rotate(1.5708)
	if event.is_action_pressed("turn_right"):
		emit_signal("rotate", "right")
		rotate(-1.5708)
