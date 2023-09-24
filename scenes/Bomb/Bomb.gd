extends 'res://scripts/Fallable.gd'

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
	self._onready()
	explosion_timer.wait_time = 2
	add_child(explosion_timer)
	$AnimatedSprite2D.play('default')
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


func start_explosion_timer():
	state = BOMB_STATES.TIMER
	explosion_timer.start()

func stop_explosion_timer():
	state = BOMB_STATES.EXPLODABLE
	explosion_timer.stop()

func _explode():
	state = BOMB_STATES.EXPLODED
	$AnimatedSprite2D.connect('animation_looped', Callable(self, '_finished_explosion'))
	$AnimatedSprite2D.play('explode')
	self.get_children()[1].play()
	self.Grid.explode_bomb(self)
	

func _finished_explosion():
	self.Grid.remove_bomb(self)
	
