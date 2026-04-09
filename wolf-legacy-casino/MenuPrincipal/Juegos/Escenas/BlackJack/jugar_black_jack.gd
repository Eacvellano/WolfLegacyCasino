extends Node2D

@onready var sprite_carta = $Sprite2D
@onready var etiqueta_puntos = $EtiquetaPuntos
@onready var sprite_crupier = $SpriteCrupier
@onready var etiqueta_crupier = $EtiquetaCrupier

@onready var boton_pedir = $BotonPedir
@onready var boton_plantarse = $BotonPlantarse
@onready var boton_nueva_partida = $BotonNuevaPartida

# Nodos de Apuesta que acabas de crear
@onready var etiqueta_saldo = $EtiquetaSaldo
@onready var caja_apuesta = $CajaApuesta
@onready var boton_apostar = $BotonApostar

var mazo = []
var cartas_instanciadas = [] 

var cartas_en_mano = 0
var puntos_jugador = 0
var ases_jugador = 0

var cartas_crupier = 0
var puntos_crupier = 0
var ases_crupier = 0

# Variables de Dinero (Tu "falso global")
var saldo_temporal = 1000 
var apuesta_actual = 0

func _ready():
	# Estado inicial: Escondemos todo el juego hasta que apuestes
	boton_pedir.hide()
	boton_plantarse.hide()
	boton_nueva_partida.hide()
	sprite_carta.hide()
	sprite_crupier.hide()
	
	actualizar_saldo()
	inicializar_mazo()
	barajar_mazo()

func actualizar_saldo():
	etiqueta_saldo.text = "Saldo: $" + str(saldo_temporal)
	caja_apuesta.max_value = saldo_temporal # Bloqueamos para que no apueste más de lo que tiene

# --- LA NUEVA LÓGICA DE APUESTAS ---
func _on_boton_apostar_pressed():
	var intento_apuesta = caja_apuesta.value
	
	if intento_apuesta > 0 and intento_apuesta <= saldo_temporal:
		apuesta_actual = intento_apuesta
		saldo_temporal -= apuesta_actual # Descontamos el dinero de inmediato
		actualizar_saldo()
		
		# Ocultamos la UI de apuestas y mostramos los botones de juego
		caja_apuesta.hide()
		boton_apostar.hide()
		boton_pedir.show()
		boton_plantarse.show()
		
		iniciar_ronda()
	else:
		print("Apuesta no válida bro.")

func iniciar_ronda():
	if mazo.size() < 15:
		print("Barajando nuevo mazo...")
		inicializar_mazo()
		barajar_mazo()
		
	repartir_carta()
	repartir_carta()
	repartir_carta_crupier()

func inicializar_mazo():
	mazo.clear() 
	for i in range(13):
		mazo.append(i)       
		mazo.append(i + 15)  
		mazo.append(i + 30)  
		mazo.append(i + 45)  

func barajar_mazo():
	randomize() 
	mazo.shuffle() 

func calcular_valor_carta(frame_carta, es_jugador):
	var posicion = frame_carta % 15 
	var valor = 0
	
	if posicion == 0:
		if es_jugador: 
			ases_jugador += 1
		else: 
			ases_crupier += 1
		valor = 11
	elif posicion >= 1 and posicion <= 9:
		valor = posicion + 1 
	else:
		valor = 10 
		
	return valor

func repartir_carta():
	if mazo.size() > 0:
		var carta_actual = mazo.pop_back() 
		
		if cartas_en_mano == 0:
			sprite_carta.frame = carta_actual
			sprite_carta.show()
		else:
			var nueva_carta = sprite_carta.duplicate()
			nueva_carta.frame = carta_actual
			nueva_carta.position.x = sprite_carta.position.x + (40 * cartas_en_mano)
			add_child(nueva_carta)
			cartas_instanciadas.append(nueva_carta) 
		
		cartas_en_mano += 1 
		puntos_jugador += calcular_valor_carta(carta_actual, true)
		
		if puntos_jugador > 21 and ases_jugador > 0:
			puntos_jugador -= 10
			ases_jugador -= 1
			
		etiqueta_puntos.text = "Puntos Jugador: " + str(puntos_jugador)

func repartir_carta_crupier():
	if mazo.size() > 0:
		var carta_actual = mazo.pop_back() 
		
		if cartas_crupier == 0:
			sprite_crupier.frame = carta_actual
			sprite_crupier.show()
		else:
			var nueva_carta = sprite_crupier.duplicate()
			nueva_carta.frame = carta_actual
			nueva_carta.position.x = sprite_crupier.position.x + (40 * cartas_crupier)
			add_child(nueva_carta)
			cartas_instanciadas.append(nueva_carta)
		
		cartas_crupier += 1 
		puntos_crupier += calcular_valor_carta(carta_actual, false)
		
		if puntos_crupier > 21 and ases_crupier > 0:
			puntos_crupier -= 10
			ases_crupier -= 1
			
		etiqueta_crupier.text = "Puntos Casa: " + str(puntos_crupier)

func _on_boton_pedir_pressed():
	if puntos_jugador < 21:
		repartir_carta()
		if puntos_jugador > 21:
			etiqueta_puntos.text = "Puntos: " + str(puntos_jugador) + " (VOLASTE)"
			evaluar_ganador(false) # False = El jugador voló y perdió en automático

func _on_boton_plantarse_pressed():
	boton_pedir.hide()
	boton_plantarse.hide()
	
	while puntos_crupier < 17:
		repartir_carta_crupier()
		
	evaluar_ganador(true) # True = Evaluar puntos y comparar

# --- EL PAGADOR DEL CASINO ---
func evaluar_ganador(comparar_puntos):
	if not comparar_puntos:
		print("Perdiste. La casa se queda con tu apuesta de $" + str(apuesta_actual))
	else:
		if puntos_crupier > 21:
			print("¡La casa vuela! Ganaste $" + str(apuesta_actual * 2))
			saldo_temporal += (apuesta_actual * 2)
		elif puntos_crupier > puntos_jugador:
			print("Gana la Casa.")
		elif puntos_crupier < puntos_jugador:
			print("¡Ganaste $" + str(apuesta_actual * 2) + "!")
			saldo_temporal += (apuesta_actual * 2)
		else:
			print("¡Empate! Se te devuelve tu dinero de $" + str(apuesta_actual))
			saldo_temporal += apuesta_actual
			
	actualizar_saldo()
	boton_nueva_partida.show()

# --- LIMPIEZA DE MEMORIA TIPO C PARA LA NUEVA RONDA ---
func _on_boton_nueva_partida_pressed():
	for carta in cartas_instanciadas:
		carta.queue_free() 
	cartas_instanciadas.clear() 
	
	cartas_en_mano = 0
	puntos_jugador = 0
	ases_jugador = 0
	cartas_crupier = 0
	puntos_crupier = 0
	ases_crupier = 0
	apuesta_actual = 0
	
	sprite_carta.hide()
	sprite_crupier.hide()
	etiqueta_puntos.text = "Puntos: 0"
	etiqueta_crupier.text = "Puntos: 0"
	
	boton_nueva_partida.hide()
	caja_apuesta.show()
	boton_apostar.show()
