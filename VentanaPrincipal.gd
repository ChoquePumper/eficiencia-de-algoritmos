extends Control

export var valorN:int = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var array_vis = [
	$GridContainer/VisLogN, $GridContainer/VisN, $GridContainer/VisNLogN,
	$GridContainer/VisNp2, $GridContainer/VisNp3, $GridContainer/VisExp
]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Usar el valor de N del control sobre el ya establecido arriba del script.
	valorN = int($PanelSuperior/HBoxContainer/inputValorN.value)
	SetearN(valorN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_btnIniciarTodos_pressed():
	# Preparar todos los hilos primero
	for vis in array_vis: if vis.visible:
		vis.PrepararThread()
	for vis in array_vis: if vis.visible:
		vis.EjecutarAlgoritmo(valorN)

# Se presionó el boton para mostrar/ocultar en la parte inferior de la pantalla
func _on_btnMostrar_toggled(button_pressed, i):
	var vis: Container = array_vis[i]
	vis.visible = button_pressed

# Se cambió el valor de N en el control.
func _on_inputValorN_value_changed(value):
	SetearN(int(value))

func SetearN(n: int):
	valorN = n
	for vis in array_vis:
		vis.SetProximoN(valorN)
