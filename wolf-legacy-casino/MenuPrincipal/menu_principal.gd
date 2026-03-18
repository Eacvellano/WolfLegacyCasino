extends Control

func _ready() -> void:
	actualizar_ui()

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and visible:
		actualizar_ui()

func actualizar_ui() -> void:
	var hay_jugador = GameData.jugador_registrado
	
	var lbl_nombre  = get_node_or_null("PlayerInfoPanel/PlayerNameLabel")
	var lbl_saldo   = get_node_or_null("PlayerInfoPanel/PlayerBalanceLabel")
	var btn_jugar   = get_node_or_null("ButtonsContainer/BtnJugar")
	var btn_mostrar = get_node_or_null("ButtonsContainer/BtnMostrar")
	var btn_modif   = get_node_or_null("ButtonsContainer/BtnModificar")
	var btn_elim    = get_node_or_null("ButtonsContainer/BtnEliminar")
	var btn_stats   = get_node_or_null("ButtonsContainer/BtnEstadisticas")
	var btn_reg     = get_node_or_null("ButtonsContainer/BtnRegistrar")

	if lbl_nombre != null:
		if hay_jugador:
			lbl_nombre.text = "Jugador: " + GameData.jugador_nombre
			lbl_saldo.text  = "Saldo: $" + str(GameData.jugador_saldo)
		else:
			lbl_nombre.text = "Bienvenido al Casino 🎰"
			lbl_saldo.text  = "No hay jugador registrado"

	if btn_jugar != null:
		btn_jugar.disabled   = not hay_jugador
		btn_mostrar.disabled = not hay_jugador
		btn_modif.disabled   = not hay_jugador
		btn_elim.disabled    = not hay_jugador
		btn_stats.disabled   = not hay_jugador

	if btn_reg != null:
		btn_reg.visible = not hay_jugador

func _on_btn_registrar_pressed() -> void:
	get_tree().change_scene_to_file("res://RegistrarJugador.tscn")

func _on_btn_mostrar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MostrarJugador.tscn")

func _on_btn_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MenuJuegos.tscn")

func _on_btn_modificar_pressed() -> void:
	get_tree().change_scene_to_file("res://RegistrarJugador.tscn")

func _on_btn_eliminar_pressed() -> void:
	get_tree().change_scene_to_file("res://EliminarJugador.tscn")

func _on_btn_estadisticas_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Estadisticas.tscn")

func _on_btn_salir_pressed() -> void:
	print("Botón salir presionado")
	get_tree().quit()
