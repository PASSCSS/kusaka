extends Node2D

onready var head : Node2D = $head
onready var waiter : Timer = $waiter

var snake_eat : bool = false
var body = preload("res://entity/snake/body.tscn")
var snake_lose : bool = false

var waiter_long : float = 0.4
var diraction : Vector2 = Vector2()
var segments : Array = []

func _ready():
	global_position = Vector2(600, 300)
	segments.append(head)

	for i in 0:
		var new_part = body.instance()
		segments.append(new_part)
		add_child(new_part)

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_up") and diraction != Vector2(0, 1):
		diraction = Vector2( 0,-1)
	if Input.is_action_just_pressed("ui_down") and diraction != Vector2(0,-1):
		diraction = Vector2( 0, 1)
	if Input.is_action_just_pressed("ui_left") and diraction != Vector2(1, 0):
		diraction = Vector2(-1, 0)
	if Input.is_action_just_pressed("ui_right") and diraction != Vector2(-1, 0):
		diraction = Vector2( 1, 0)
	
func movement():
	for x in range(segments.size()-1,-1,-1):
		if x == 0:
			segments[x].global_position += diraction * 32
		else:
			segments[x].global_position = segments[x-1].global_position

func check_head():
	return segments[0].global_position

func snake():
	var head_position = check_head()
	var cell_size : int = 20
	var grid_size : Vector2 = Vector2(60, 30)

	if head_position.x >= grid_size.x*cell_size:
		segments[0].global_position.x = 0
	if head_position.x < 0:
		segments[0].global_position.x = (grid_size.x-1)*cell_size
	if head_position.y >= grid_size.y*cell_size:
		segments[0].global_position.y = 0
	if head_position.y < 0:
		segments[0].global_position.y = (grid_size.y-1)*cell_size

func lose():
	for i in range(1, segments.size(), 1):
		if diraction != Vector2.ZERO and segments[i].global_position == check_head():
			snake_lose = true

func eat():
	snake_eat = true
	waiter.wait_time = waiter_long
	var new_part = body.instance()

	segments.append(new_part)
	add_child(new_part)
	new_part.global_position = Vector2(-64, 64)

func waiter_timeout():
	movement()
	snake()
	lose()
