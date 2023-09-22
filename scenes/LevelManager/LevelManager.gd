extends Node2D

@onready var camera := self.get_children()[0]
@onready var levels := camera.get_children()

var visible_level: int = 0


func _ready():
	camera.position = Vector2(8, 23)
	for level in levels:
		camera.remove_child(level)
	self.first_level()

func first_level():
	var level = levels[visible_level]
	var grid = level.get_children()[0]
	grid.connect('exit', Callable(self, "_exit"))
	self.add_child(level)
	level.position = Vector2.ZERO


func next_level():
	camera.reset()
	visible_level += 1
	var level = levels[visible_level]
	
	if not level:
		return
	
	var grid = level.get_children()[0]
	grid.connect('exit', Callable(self, "_exit"))
	self.add_child(level)
	level.position = Vector2.ZERO


func _exit():
	print('NEXT LEVEL')
	var current_level = visible_level
	next_level()
	self.remove_child(levels[current_level])
	
