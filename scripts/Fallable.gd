extends 'res://scripts/Pawn.gd'

@onready var Grid = get_parent()
@export var time_to_fall := 0.5

var timer
var finished_move = false
var can_fall = true

signal hit_wall

var has_hit_wall := false

func _onready():
	timer = Timer.new()
	timer.wait_time = time_to_fall
	add_child(timer)
	timer.connect("timeout", Callable(self, '_timeout'))
	timer.start()

		
func _timeout():
	if not physics:
		pass
	var can_move = Grid.request_move(self, 'move_down')
	if not can_move:		
		timer.start()
	else:
		Grid.move(self, "move_down")
		var can_perform_next_move = Grid.request_move(self, 'move_down')
		if not can_perform_next_move:
			var position = Grid.get_target_position(self.position, "move_down")
			var node = Grid.get_node_by_position(position)		
			if not node:
				return
			if node.is_bomb():
				return
			if node.is_crate():
				
				return
			emit_signal('hit_wall')

