extends "res://Visualizacion.gd"

# N^3

# Sobreescribir funciones
func getNombre() -> String: return "N³"
func getColor() -> Color: return Color.orange

func algoritmo(n: int):
	var i:int = 0
	while i < n:
		var j:int = 0
		while j < i:
			j+=13
			var l: int = 2
			# warning-ignore:integer_division
			while l < n/4:
				l += 5
		i += 1
		SetProgreso( float(i)/n )
		# Terminar el algoritmo si se le ordena.
		if DebeTerminarElAlgoritmo(): return
