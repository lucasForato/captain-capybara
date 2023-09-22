extends Node2D

@onready var levels = self.get_children()

var visible_level: int = 0

func _ready():
	var level = levels[visible_level]
	level.visible = true
