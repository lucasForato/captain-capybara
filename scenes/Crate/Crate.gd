extends 'res://scripts/Pawn.gd'

@onready var Grid = get_parent()
var timer
var finished_move = false
var can_fall = true

func _ready():
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 0.5
	add_child(timer)	
	
	var callable = Callable(self, '_timeout')
	timer.connect("timeout", callable)

func _process(delta):
	if not finished_move and can_fall:
		var can_move = Grid.request_move(self, 'move_down')
		if not can_move:
			finished_move = true
		else:
			Grid.move(self, 'move_down')
			can_fall = false
			timer.start()
		
func _timeout():
	can_fall = true
