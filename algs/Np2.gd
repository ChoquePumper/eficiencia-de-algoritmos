extends "res://Visualizacion.gd"

# N^2

# Sobreescribir funciones
func getNombre() -> String: return "N²"
func getColor() -> Color: return Color.yellow

func algoritmo(n: int):
	var i:int = 0
	while i < n:
		var j:int = 0
		while j < i: j+=13
		i += 1
		SetProgreso( float(i)/n )
		# Terminar el algoritmo si se le ordena.
		if DebeTerminarElAlgoritmo(): return
