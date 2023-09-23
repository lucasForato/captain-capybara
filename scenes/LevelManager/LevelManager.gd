extends Node2D

@onready var camera := self.get_children()[0]
@onready var levels := camera.get_children()
@onready var countdown := self.get_children()[1]

var visible_level: int = 0
var levels_started = {}
var cur_level

func _ready():
	camera.position = Vector2(8, 23)
	countdown.position = Vector2(-66, -50)
	for level in levels:
		camera.remove_child(level)

func _process(time):
	if countdown.is_stopped() == true:
		self.start_level()
	pass

func start_level():
	if visible_level in levels_started:
		return
	var level = levels[visible_level]
	var grid = level.get_children()[0]
	grid.connect('exit', Callable(self, "_exit"))
	self.add_child(level)
	level.position = Vector2.ZERO
	levels_started[visible_level] = true
	countdown.reset()
	countdown.start(level, grid)
	
func next_level():
	camera.reset()
	visible_level += 1
	var level = levels[visible_level]
	if not level:
		return

func _exit():
	var current_level = visible_level
	next_level()
	self.remove_child(levels[current_level])
	
