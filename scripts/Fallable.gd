extends 'res://scripts/Pawn.gd'

@onready var Grid = get_parent()
@export var time_to_fall := 0.5

var timer
var finished_move = false
var can_fall = true

func _onready():
	timer = Timer.new()
	timer.wait_time = time_to_fall
	add_child(timer)
	timer.connect("timeout", Callable(self, '_timeout'))
	timer.start()

		
func _timeout():
	var can_move = Grid.request_move(self, 'move_down')
	if not can_move:
		timer.start()
		return
	Grid.move(self, "move_down")
