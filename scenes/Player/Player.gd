extends 'res://scripts/Pawn.gd'

@onready var Grid = get_parent()


func _input(event: InputEvent):
	var event_name: String
	if event.is_action_pressed("move_down"):
		event_name = "move_down"
	if event.is_action_pressed("move_up"):
		event_name = "move_up"
	if event.is_action_pressed("move_left"):
		event_name = "move_left"
	if event.is_action_pressed("move_right"):
		event_name = "move_right"
	
	if event_name:
		var can_move = Grid.request_move(self, event_name)
		if not can_move:
			return
		print(can_move)
		Grid.move(self, event_name)
