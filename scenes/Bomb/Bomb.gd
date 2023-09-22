extends 'res://scripts/Pawn.gd'

@onready var Grid = get_parent()

var timer
var finished_move = false
var can_fall = true

var explosion_timer = Timer.new()
enum BOMB_STATES {NOT_EXPLODABLE, EXPLODABLE, TIMER, EXPLODED}
var state = BOMB_STATES.NOT_EXPLODABLE

signal exploded

func is_not_explodable() -> bool:
	return self.state == BOMB_STATES.NOT_EXPLODABLE

func is_explodable() -> bool:
	return self.state == BOMB_STATES.EXPLODABLE

func is_timer_ticking() -> bool:
	return self.state == BOMB_STATES.TIMER

func has_exploded() -> bool:
	return self.state == BOMB_STATES.EXPLODED

func _ready():
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 0.5
	explosion_timer.wait_time = 2
	add_child(timer)
	add_child(explosion_timer)		
	timer.connect("timeout", Callable(self, '_timeout'))
	explosion_timer.connect("timeout", Callable(self, '_explode'))	

func _process(delta):
	if can_fall:
		var can_move = Grid.request_move(self, 'move_down')
		if not can_move:
			if self.is_explodable():
				self.start_explosion_timer()
			return
		if self.is_timer_ticking():
			self.stop_explosion_timer()
		
		state = BOMB_STATES.EXPLODABLE
		Grid.move(self, 'move_down')
		can_fall = false
		timer.start()
		

func start_explosion_timer():
	print('TIMER STARTED')
	state = BOMB_STATES.TIMER
	explosion_timer.start()

func stop_explosion_timer():
	print('TIMER STOPPED')
	state = BOMB_STATES.EXPLODABLE
	explosion_timer.stop()

func _timeout():
	can_fall = true

func _explode():
	print('TIMER ENDED')
	state = BOMB_STATES.EXPLODED
	Grid.explode_bomb(self)
