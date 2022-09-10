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

func algoritmo_alternativo(n: int):
	var i:int = 1
	var limite:int = int(pow(n,3))
	while i<=limite:
		i+=1
		OS.delay_msec(10)
		SetProgreso( float(i)/limite )
		# Terminar el algoritmo si se le ordena.
		if DebeTerminarElAlgoritmo(): return
