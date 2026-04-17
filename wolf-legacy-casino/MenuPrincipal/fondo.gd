extends ColorRect

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass


func _on_btn_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://juegoDelCaballo/Escenas/BlackJack/jugar_black_jack.tscn")
