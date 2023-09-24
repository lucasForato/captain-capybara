extends 'res://scripts/Pawn.gd'

@onready var Grid = get_parent()


func _input(event: InputEvent):
	var audio = self.get_children()[1]
	var event_name: String
	if event.is_action_pressed("move_down"):
		audio.play()
		event_name = "move_down"
	if event.is_action_pressed("move_up"):
		audio.play()
		event_name = "move_up"
	if event.is_action_pressed("move_left"):
		audio.play()
		event_name = "move_left"
	if event.is_action_pressed("move_right"):
		audio.play()
		event_name = "move_right"
	
	if event_name:
		var can_move = Grid.request_move(self, event_name)
		if not can_move:
			return
		Grid.move(self, event_name)
		
