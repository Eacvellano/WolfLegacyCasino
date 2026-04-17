extends Node2D

func _draw() -> void:
	# Bola cuadrada estilo pixel
	draw_rect(Rect2(-5, -5, 10, 10), Color(0.95, 0.95, 0.95))
	draw_rect(Rect2(-5, -5, 10, 10), Color(0.0, 0.0, 0.0), false, 1.5)
	# Brillo pixel
	draw_rect(Rect2(-4, -4, 3, 3), Color(1, 1, 1, 0.9))
