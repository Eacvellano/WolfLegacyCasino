extends Node


var jugador_registrado : bool = false
var jugador_nombre     : String = ""
var jugador_saldo      : float  = 0.0
var jugador_edad       : int    = 0

var partidas_jugadas  : int   = 0
var partidas_ganadas  : int   = 0
var partidas_perdidas : int   = 0
var ganancias_totales : float = 0.0
var perdidas_totales  : float = 0.0

func registrar_jugador(nombre: String, edad: int, saldo_inicial: float) -> void:
	jugador_nombre     = nombre
	jugador_edad       = edad
	jugador_saldo      = saldo_inicial
	jugador_registrado = true

func modificar_jugador(nuevo_nombre: String, nueva_edad: int) -> void:
	jugador_nombre = nuevo_nombre
	jugador_edad   = nueva_edad

func actualizar_saldo(cantidad: float) -> void:
	jugador_saldo += cantidad

func registrar_partida(gano: bool, cantidad: float) -> void:
	partidas_jugadas += 1
	if gano:
		partidas_ganadas  += 1
		ganancias_totales += cantidad
	else:
		partidas_perdidas += 1
		perdidas_totales  += cantidad

func eliminar_jugador() -> void:
	jugador_registrado = false
	jugador_nombre     = ""
	jugador_saldo      = 0.0
	jugador_edad       = 0
	
	partidas_jugadas   = 0
	partidas_ganadas   = 0
	partidas_perdidas  = 0
	ganancias_totales  = 0.0
	perdidas_totales   = 0.0
