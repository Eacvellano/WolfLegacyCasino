extends Control

func _ready() -> void:
	# Ocultar mensaje al inicio
	$MensajeLabel.visible = false
	
	# Configurar el input del saldo para aceptar solo números
	$SaldoInput.placeholder_text = "Ej: 1000"
	$NombreInput.placeholder_text = "Tu nombre"

func _on_btn_confirmar_pressed() -> void:
	var nombre = $NombreInput.text.strip_edges()
	var saldo  = $SaldoInput.text.strip_edges()
	
	# Validar que los campos no estén vacíos
	if nombre == "":
		mostrar_mensaje("Por favor escribe tu nombre", false)
		return
	
	if saldo == "":
		mostrar_mensaje("Por favor escribe un saldo inicial", false)
		return
	
	# Validar que el saldo sea un número válido
	if not saldo.is_valid_float():
		mostrar_mensaje("⚠️ El saldo debe ser un número", false)
		return
	
	var saldo_float = float(saldo)
	
	if saldo_float <= 0:
		mostrar_mensaje("⚠️ El saldo debe ser mayor a 0", false)
		return
	
	# Registrar jugador en GameData
	GameData.registrar_jugador(nombre, 0, saldo_float)
	
	# Mostrar mensaje de éxito y regresar al menú
	mostrar_mensaje("✅ ¡Bienvenido " + nombre + "!", true)
	
	# Esperar 2 segundos y regresar al menú
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://menu_principal.tscn")

func _on_btn_cancelar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")

func mostrar_mensaje(texto: String, exito: bool) -> void:
	$MensajeLabel.text = texto
	$MensajeLabel.visible = true
	if exito:
		$MensajeLabel.modulate = Color(0, 1, 0)  # Verde
	else:
		$MensajeLabel.modulate = Color(1, 0, 0)  # Rojo
