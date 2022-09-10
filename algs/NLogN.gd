extends "res://Visualizacion.gd"

# N*log(N)

# Sobreescribir funciones
func getNombre() -> String: return "N*log(N)"
func getColor() -> Color: return Color.green

func algoritmo(n: int):
	var i:int = 0
	while i < n:
		var j:int = n*3
		while j > 4:
			j /= 2
			j += 2
		i += 1
		SetProgreso( float(i)/n )
		# Terminar el algoritmo si se le ordena.
		if DebeTerminarElAlgoritmo(): return

func algoritmo_alternativo(n: int):
	var i:int = 1
	var limite: int = n*(log(n)/log(2))
	while i<=limite:
		i += 1;
		OS.delay_msec(10)
		SetProgreso( float(i)/limite )
		# Terminar el algoritmo si se le ordena.
		if DebeTerminarElAlgoritmo(): return
