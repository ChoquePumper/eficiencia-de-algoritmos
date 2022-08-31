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

