extends 'res://scripts/Fallable.gd'

func _ready():
	self._onready()
	self.connect('hit_wall', Callable(self, '_hit_wall'))
	
func _hit_wall():
	$AudioStreamPlayer.play()
