extends Node2D

func _on_area(area):
	if area.name == "head":
		area.get_parent().get_parent().snake_eat = true
		area.get_parent().get_parent().eat()
		queue_free()
