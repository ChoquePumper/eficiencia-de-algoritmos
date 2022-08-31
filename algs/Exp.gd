extends "res://Visualizacion.gd"

# Exp

# Sobreescribir funciones
func getNombre() -> String: return "2^N"
func getColor() -> Color: return Color.webpurple
# Exponencial
# Creo que en realidad es n*2^N
func algoritmo(n: int):
	var i:int = 0
	while i < n:
		var j:int = 1
		# warning-ignore:integer_division
		while j < (1+pow(2,i/20)/999999):
			j += 1280
			# Terminar el algoritmo si se le ordena.
			if DebeTerminarElAlgoritmo(): return
		i += 1
		SetProgreso( float(i)/n )
		# Terminar el algoritmo si se le ordena.
		# Aquí itera pocas veces, por lo que para mejor respuesta del botón de
		# detener, también tiene que estar en el otro bucle while.
		if DebeTerminarElAlgoritmo(): return
