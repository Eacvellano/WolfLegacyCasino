extends Node2D

# ============================================================
#  RULETA.GD  –  Script principal de la ruleta
# ============================================================

# ------ Referencias a nodos (se asignan en _ready) ----------
@onready var lbl_result  : Label  = $UI/"Lbl resultado"    
@onready var lbl_saldo   : Label  = $UI/LblSaldo
@onready var lbl_apuesta : Label  = $UI/LaLblApuestabel3  
@onready var btn_girar   : Button = $UI/Girar
@onready var btn_mas     : Button = $UI/mas
@onready var btn_menos   : Button = $UI/menos
@onready var btn_rojo    : Button = $UI/rojo
@onready var btn_negro   : Button = $UI/negro
@onready var btn_par     : Button = $UI/par
@onready var btn_impar   : Button = $UI/impar
@onready var rueda      : Node2D = $Rueda
@onready var bola       : Node2D = $Bola
@onready var audio_giro : AudioStreamPlayer = $"Audio giro"
@onready var audio_win  : AudioStreamPlayer = $"Audio Win"

# ------ Orden de números en la ruleta europea ---------------
const NUMEROS := [0,32,15,19,4,21,2,25,17,34,6,27,13,36,
				  11,30,8,23,10,5,24,16,33,1,20,14,31,9,
				  22,18,29,7,28,12,35,3,26]

const ROJOS := [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36]

# ------ Estado del juego ------------------------------------
var saldo   : int = 1000
var apuesta : int = 50
var tipo_apuesta : String = ""   # "rojo","negro","par","impar","numero"
var numero_apostado : int = -1

var girando : bool = false
var velocidad_rueda : float = 0.0
var angulo_rueda    : float = 0.0
var velocidad_bola  : float = 0.0
var radio_bola      : float = 200.0   # radio orbital inicial
var angulo_bola     : float = 0.0
var resultado_numero: int = -1

# Física simple
const RADIO_BORDE  : float = 185.0  
const RADIO_CENTRO : float = 65.0   
const FRICCION_RUEDA: float = 0.995
const FRICCION_BOLA : float = 0.992

# ============================================================
func _ready() -> void:
	actualizar_ui()
	btn_girar.pressed.connect(_on_girar)
	btn_mas.pressed.connect(func(): cambiar_apuesta(50))
	btn_menos.pressed.connect(func(): cambiar_apuesta(-50))
	btn_rojo.pressed.connect(func(): seleccionar_apuesta("rojo"))
	btn_negro.pressed.connect(func(): seleccionar_apuesta("negro"))
	btn_par.pressed.connect(func(): seleccionar_apuesta("par"))
	btn_impar.pressed.connect(func(): seleccionar_apuesta("impar"))
	rueda.position = Vector2(432, 300)  
	bola.position  = rueda.position + Vector2(185, 0)

# ============================================================
func _process(delta: float) -> void:
	if not girando:
		return

	velocidad_rueda *= FRICCION_RUEDA
	angulo_rueda    += velocidad_rueda * delta
	rueda.rotation   = angulo_rueda

	velocidad_bola *= FRICCION_BOLA
	angulo_bola    -= velocidad_bola * delta

	var t : float = clamp(1.0 - (abs(velocidad_bola) / 8.0), 0.0, 1.0)
	radio_bola = lerp(RADIO_BORDE, RADIO_CENTRO + 30.0, t)

	bola.position = rueda.position + Vector2(cos(angulo_bola) * radio_bola, sin(angulo_bola) * radio_bola)

	if abs(velocidad_rueda) < 0.05 and abs(velocidad_bola) < 0.05:
		girando = false
		_calcular_resultado()

# ============================================================
func _on_girar() -> void:
	if girando:
		return
	if tipo_apuesta == "":
		lbl_result.text = "⚠ Elige un tipo de apuesta"
		return
	if apuesta > saldo:
		lbl_result.text = "⚠ Saldo insuficiente"
		return

	saldo -= apuesta
	actualizar_ui()
	lbl_result.text = "🎰 Girando..."
	btn_girar.disabled = true

	# Impulso aleatorio
	velocidad_rueda = randf_range(4.0, 8.0)
	velocidad_bola  = randf_range(6.0, 10.0)
	radio_bola  = RADIO_BORDE
	angulo_bola = randf_range(0.0, TAU)
	bola.position = rueda.position + Vector2(cos(angulo_bola) * RADIO_BORDE, sin(angulo_bola) * RADIO_BORDE)
	girando         = true

	if audio_giro:
		audio_giro.play()

# ============================================================
func _calcular_resultado() -> void:
	
	var ang_rel := fmod(angulo_bola - angulo_rueda + TAU * 10, TAU)
	var slot_size := TAU / NUMEROS.size()
	var idx := int(ang_rel / slot_size) % NUMEROS.size()
	resultado_numero = NUMEROS[idx]

	var ganancia : int = 0
	var gano : bool = false

	match tipo_apuesta:
		"rojo":
			gano = resultado_numero in ROJOS
			if gano: ganancia = apuesta * 2
		"negro":
			gano = resultado_numero != 0 and resultado_numero not in ROJOS
			if gano: ganancia = apuesta * 2
		"par":
			gano = resultado_numero != 0 and resultado_numero % 2 == 0
			if gano: ganancia = apuesta * 2
		"impar":
			gano = resultado_numero % 2 == 1
			if gano: ganancia = apuesta * 2
		"numero":
			gano = resultado_numero == numero_apostado
			if gano: ganancia = apuesta * 36

	saldo += ganancia

	var color_txt := "ROJO" if resultado_numero in ROJOS else ("VERDE" if resultado_numero == 0 else "NEGRO")
	if gano:
		lbl_result.text = "🎉 ¡%d (%s)! GANASTE $%d" % [resultado_numero, color_txt, ganancia]
		if audio_win: audio_win.play()
	else:
		lbl_result.text = "😞 Salió %d (%s). Perdiste $%d" % [resultado_numero, color_txt, apuesta]

	actualizar_ui()
	btn_girar.disabled = false

	if saldo <= 0:
		lbl_result.text += "\n💸 Sin saldo. Recargando..."
		saldo = 1000
		actualizar_ui()

# ============================================================
func seleccionar_apuesta(tipo: String) -> void:
	tipo_apuesta = tipo
	numero_apostado = -1
	lbl_result.text = "Apuesta: " + tipo.to_upper()

func cambiar_apuesta(delta: int) -> void:
	apuesta = clamp(apuesta + delta, 10, 500)
	actualizar_ui()

func actualizar_ui() -> void:
	lbl_saldo.text    = "💰 Saldo: $%d"   % saldo
	lbl_apuesta.text  = "🎲 Apuesta: $%d" % apuesta
