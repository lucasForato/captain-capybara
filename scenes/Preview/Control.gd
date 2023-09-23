extends Control

export (int) var segundos = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.wait_time = time_to_fall
	add_child(timer)
	timer.connect("timeout", Callable(self, '_timeout'))
	timer.start()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	segundos -= 1
	pass # Replace with function body.
