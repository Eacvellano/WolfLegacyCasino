extends Node2D

const NUMEROS := [0,32,15,19,4,21,2,25,17,34,6,27,13,36,
				  11,30,8,23,10,5,24,16,33,1,20,14,31,9,
				  22,18,29,7,28,12,35,3,26]
const ROJOS := [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36]

const RADIO_EXTERNO : float = 200.0  # era 100.0
const RADIO_INTERNO : float = 55.0   # era 28.0
const RADIO_NUMERO  : float = 158.0  # era 78.0

var font : Font

func _ready() -> void:
	font = ThemeDB.fallback_font

func _draw() -> void:
	var n := NUMEROS.size()
	var angulo_slot := TAU / n

	for i in n:
		var ang_ini : float = i * angulo_slot - angulo_slot * 0.5
		var ang_fin : float = ang_ini + angulo_slot
		var num     : int   = NUMEROS[i]

		var color : Color
		if num == 0:
			color = Color(0.0, 0.8, 0.2)
		elif num in ROJOS:
			color = Color(0.9, 0.1, 0.1)
		else:
			color = Color(0.15, 0.15, 0.15)

		
		var puntos : PackedVector2Array = [Vector2.ZERO]
		var pasos := 8  
		for p in pasos + 1:
			var a : float = lerp(ang_ini, ang_fin, float(p) / pasos)
			puntos.append(Vector2(cos(a) * RADIO_EXTERNO, sin(a) * RADIO_EXTERNO))
		puntos.append(Vector2.ZERO)

		draw_colored_polygon(puntos, color)

		# Borde amarillo pixel
		var borde_pts : PackedVector2Array
		for p in pasos + 1:
			var a : float = lerp(ang_ini, ang_fin, float(p) / pasos)
			borde_pts.append(Vector2(cos(a) * RADIO_EXTERNO, sin(a) * RADIO_EXTERNO))
		draw_polyline(borde_pts, Color(1.0, 0.85, 0.0), 1.0)

		# Número pequeño
		var ang_mid := ang_ini + angulo_slot * 0.5
		var pos_num := Vector2(cos(ang_mid) * 168.0, sin(ang_mid) * 168.0)
		draw_set_transform(pos_num, ang_mid + PI * 0.5, Vector2.ONE)
		draw_string(font, Vector2(-6, 5), str(num),
		HORIZONTAL_ALIGNMENT_CENTER, -1, 11, Color.WHITE)
			
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

	# Bordes pixelados
	draw_arc(Vector2.ZERO, RADIO_EXTERNO + 2, 0, TAU, 48, Color(1.0, 0.85, 0.0), 2.0)
	draw_circle(Vector2.ZERO, RADIO_INTERNO, Color(0.1, 0.05, 0.0))
	draw_arc(Vector2.ZERO, RADIO_INTERNO, 0, TAU, 20, Color(1.0, 0.85, 0.0), 2.0)
