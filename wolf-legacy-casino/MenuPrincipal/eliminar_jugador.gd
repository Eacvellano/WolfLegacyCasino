extends Control

func _ready() -> void:
	$MensajeLabel.visible = false
	# Mostrar el nombre del jugador actual
	$NombreJugadorLabel.text = "Jugador: " + GameData.jugador_nombre

func _on_btn_confirmar_pressed() -> void:
	# Eliminar todos los datos del jugador
	GameData.eliminar_jugador()
	
	# Mostrar mensaje de confirmación
	mostrar_mensaje("✅ Cuenta eliminada exitosamente", true)
	
	# Esperar 2 segundos y regresar al menú
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://menu_principal.tscn")

func _on_btn_cancelar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")

func mostrar_mensaje(texto: String, exito: bool) -> void:
	$MensajeLabel.text    = texto
	$MensajeLabel.visible = true
	if exito:
		$MensajeLabel.modulate = Color(0, 1, 0)
	else:
		$MensajeLabel.modulate = Color(1, 0, 0)
