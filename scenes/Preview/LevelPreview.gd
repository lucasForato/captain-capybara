extends Node2D

@onready var one = self.get_children()[0]
@onready var two = self.get_children()[1]
@onready var three = self.get_children()[2]

var timer: Timer
var cur_time = 3
var cur_level
var cur_grid
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.wait_time = 1
	add_child(timer)
	timer.connect("timeout", Callable(self, '_timeout'))
	timer.stop()

func start(level, grid):
	cur_level = level
	cur_grid = grid
	grid.stop()
	timer.start()
	
func reset():
	cur_time = 3

func is_stopped():
	return timer.is_stopped()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	one.visible = false
	two.visible = false
	three.visible = false
	if cur_time == 3:
		three.visible = true
	if cur_time == 2:
		two.visible = true
	if cur_time == 1:
		one.visible = true
	pass
	
func _timeout():
	cur_time -= 1
	if cur_time <= 0:
		timer.stop()
		cur_grid.restart()
