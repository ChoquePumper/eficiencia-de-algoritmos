extends Container

# Señales (o "eventos")
signal algoritmo_iniciado()
signal algoritmo_terminado()

# Nodos hijos
onready var labelArriba = $labelArribaIzq
onready var grafico = $"Gráfico"
onready var btnIniciar = $btnIniciar

var proximoN: int = 0
var Nactual: int = 0
var progress: float = 0
var tiempo_inicio: int = -1
var tiempo_fin: int = -1
var en_ejecucion: bool = false
var thread: Thread # Hilo
var mutex: Mutex
	# Los Mutex sirven para impedir que mas de un hilo
	# acceda a un mismo dato a la vez.
	
# Bandera para indicar que se debe terminar el hilo/algoritmo
var terminate_thread: bool = false

# Variables duplicadas para el hilo principal
var dup_en_ejecucion: bool = en_ejecucion
var dup_progress: float = progress

# Sobreescribir estas funciones para cada algoritmo
func getNombre() -> String: return "GenericVis"
func getColor() -> Color: return Color.purple

# warning-ignore:unused_argument
func algoritmo(n:int):
	# Aquí tiene que ir el código del algoritmo.
	print("Se tiene que se sobreescribir esta funcion.")
# -------------------------------------------------

func algoritmo_alternativo(n:int):
	print("Se tiene que se sobreescribir esta funcion.")

# Función llamada por el hilo y que llama al algoritmo
func _funcion_para_el_hilo(n:int):
	# Establece el tiempo inicial y marca la bandera de en_ejecucion
	mutex.lock()
	tiempo_inicio = Time.get_ticks_msec()
	tiempo_fin = -1
	marcarEnEjecucion(true)
	emit_signal("algoritmo_iniciado") # Emitir señal de inicio
	mutex.unlock()
	# Ejecuta el algoritmo
	#algoritmo(n)
	algoritmo_alternativo(n)
	# El algoritmo terminó!
	# Marcar el tiempo de fin
	mutex.lock()
	tiempo_fin = Time.get_ticks_msec()
	marcarEnEjecucion(false)
	emit_signal("algoritmo_terminado") # Emitir señal de terminado
	mutex.unlock()

# Constantes y funciones estáticas
static func GenerarTextoEnPantalla(tiempo, progreso, n) -> String:
	return "Tiempo: %s\nProgreso: %.6f\nN = %d" % ([tiempo, progreso, n])
	
static func getTiempoTexto(total_msecs: int):
	var fmt:String = "%d:%02d.%03d"
	var msecs: int = total_msecs%1000
# warning-ignore:integer_division
	var secs: int = (total_msecs / 1000) % 60
# warning-ignore:integer_division
	var mins: int = total_msecs / 60000
	return fmt % [mins, secs, msecs]
	
const color_lineas_normal: Color = Color.white/2
const color_lineas_durante_ejecucion: Color = Color.goldenrod/2
static func GetColorLineas(esta_en_ejecucion: bool):
	return color_lineas_durante_ejecucion if esta_en_ejecucion else color_lineas_normal
static func GetGrosorLineas(esta_en_ejecucion: bool) -> float:
	return 2.0 if esta_en_ejecucion else 1.0
# --------------------------------

# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/Label.text = getNombre()
	CenterGraph()
	mutex = Mutex.new()
	thread = Thread.new()
	SetProgreso(0)

func _draw():
	# Usar las variables con prefijo dup_ para no usar mutex
	var color_lineas: Color = GetColorLineas(dup_en_ejecucion)
	var grosor_lineas: float = GetGrosorLineas(dup_en_ejecucion)
	draw_rect(Rect2(Vector2.ZERO, rect_size), color_lineas, false, grosor_lineas)
	# diagonales
	draw_line(Vector2.ZERO, rect_size, color_lineas, grosor_lineas)
	draw_line(Vector2(0, rect_size.y), Vector2(rect_size.x, 0), color_lineas, grosor_lineas)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# General texto para el label
	var tiempo; var progreso; var n;
	var marca_de_tiempo_actual = Time.get_ticks_msec()
	mutex.lock()	# Pedir excuisividad
	tiempo = (marca_de_tiempo_actual if tiempo_fin==-1 and en_ejecucion else tiempo_fin) - tiempo_inicio
	progreso = progress
	n = Nactual
	# Actualizar valores con prefijo dup_
	dup_progress = progreso
	dup_en_ejecucion = estaEnEjecucion()
	mutex.unlock()	# Levantar excuisividad
	# Mostrar texto en pantalla
	labelArriba.text = GenerarTextoEnPantalla(getTiempoTexto(tiempo), progreso, n)
	
	if dup_en_ejecucion: update()
	
func _exit_tree(): # Al salir
	DetenerAlgoritmo()
	if thread and thread.is_active(): thread.wait_to_finish()

func _on_Visualizacin_item_rect_changed():
	# Centrar gráfico en caso de que se cambie el tamaño de la ventana/pantalla.
	CenterGraph()
	
func estaEnEjecucion() -> bool:
	mutex.lock()
	var ret = en_ejecucion
	mutex.unlock()
	return ret
	
func marcarEnEjecucion(b: bool):
	mutex.lock()
	en_ejecucion = b
	mutex.unlock()

func GetProgreso() -> float:
	mutex.lock()
	var ret = progress
	mutex.unlock()
	return ret
	
func SetProgreso(p: float):
	mutex.lock()
	progress = p
	mutex.unlock()

func SetProximoN(n: int): proximoN = n
	
func PrepararThread() -> bool:
	print("Preparando hilo (", getNombre(), ")...")
	var crear_nuevo_hilo: bool = false
	if not thread: # El hilo no fue creado.
		crear_nuevo_hilo = true
	else: # El hilo ya esta creado
		if thread.is_active(): # El hilo fue ejecutado
			if thread.is_alive():
				# El hilo todavia esta ejecutandose.
				return false
			else: # El hilo terminó.
				# Los hilos en Godot parece que no se pueden reutilizar.
				# Liberar y crear uno nuevo.
				thread.wait_to_finish()
				crear_nuevo_hilo = true
		#else: # El hilo aún no fue ejecutado
			# usar el hilo ya creado y listo para ejecutar
	if crear_nuevo_hilo:
		thread = Thread.new()
	return true
	
func EjecutarAlgoritmo(n: int):
	if PrepararThread():
		print("Se tiene que iniciar el algoritmo ", getNombre(), ": ", n)
		terminate_thread = false
		Nactual = proximoN	# Establecer Nactual
	# warning-ignore:return_value_discarded
		thread.start(self, "_funcion_para_el_hilo", n)
	else:
		print("No se pudo preparar el hilo.")
	
func DetenerAlgoritmo():
	mutex.lock()
	terminate_thread = true
	mutex.unlock()
	
func DebeTerminarElAlgoritmo() -> bool:
	mutex.lock()
	var ret = terminate_thread
	mutex.unlock()
	return ret

func CenterGraph() -> void:
	grafico.position = rect_size/2
	grafico.update()

func _on_btnIniciar_pressed():
	#print("Presionado el botón de Iniciar. Id: ", getNombre())
	# Iniciar el algoritmo si no se esta ejecutando
	if not dup_en_ejecucion: EjecutarAlgoritmo(proximoN)
	# o detenerlo en caso contrario.
	else: DetenerAlgoritmo()

func _on_Visualizacin_algoritmo_terminado():
	btnIniciar.text = "Iniciar"
	dup_en_ejecucion = en_ejecucion
	print("Algoritmo ", getNombre(), " terminado. N=",Nactual,"; Tiempo=",getTiempoTexto(tiempo_fin-tiempo_inicio),"; Progreso:",GetProgreso())
	update()

func _on_Visualizacin_algoritmo_iniciado():
	btnIniciar.text = "Detener"
	#dup_en_ejecucion = en_ejecucion
