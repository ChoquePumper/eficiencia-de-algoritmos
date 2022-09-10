extends "res://Visualizacion.gd"

# N

# Sobreescribir funciones
func getNombre() -> String: return "N"
func getColor() -> Color: return Color.blue

func algoritmo(n: int):
	var i:int = 0
	while i < n:
		i += 1
		SetProgreso( float(i)/n )
		# Terminar el algoritmo si se le ordena.
		if DebeTerminarElAlgoritmo(): return

func algoritmo_alternativo(n: int):
	var i:int = 1
	while i <= n:
		i += 1
		OS.delay_msec(10)
		SetProgreso( float(i)/n )
		# Terminar el algoritmo si se le ordena.
		if DebeTerminarElAlgoritmo(): return
