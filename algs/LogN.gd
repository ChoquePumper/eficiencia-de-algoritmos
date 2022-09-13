extends "res://Visualizacion.gd"

# log(N)

# Sobreescribir funciones
func getNombre() -> String: return "log(N)"
func getColor() -> Color: return Color.red

func algoritmo(n: int):
	var i:int = 1
	while i < n:
		i *= 2
		SetProgreso( float(i)/n )
		# Terminar el algoritmo si se le ordena.
		if DebeTerminarElAlgoritmo(): return

func algoritmo_alternativo(n: int):
	var i:int = 1
	while i <= n:
		i = i*2
		OS.delay_msec(10)
		SetProgreso( float(i)/n )
		# Terminar el algoritmo si se le ordena.
		if DebeTerminarElAlgoritmo(): return
