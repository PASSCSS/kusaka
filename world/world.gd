extends Node2D

var apple_scene = preload("res://entity/apple/apple.tscn")
onready var snake : Node2D = $snake

var cell_size : int = 20
var grid_size : Vector2 = Vector2(60, 30)

func _ready():
	apple_spawn()

func apple_spawn():
	var apple = apple_scene.instance()
	apple.global_position = random_grid()
	add_child(apple)

func random_grid():
	var posible_position = []
	for x in grid_size.x:
		for y in grid_size.y:
			posible_position.append(Vector2(x * cell_size, y * cell_size))
	
	for segment in snake.segments:
		posible_position.erase(segment.global_position)
	
	randomize()
	posible_position.shuffle()
	var random_position = posible_position[0]
	return random_position

func _process(_delta):
	if snake.snake_eat == true:
		apple_spawn()
		snake.snake_eat = false
		$eat.play()

	if snake.snake_lose == true:
		get_tree().reload_current_scene()
