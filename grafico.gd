extends Node2D

# Nodo padre
onready var parent = $".."

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func _draw():
	var parent_size = parent.rect_size
	var radius: float = min(parent_size.x, parent_size.y) / 2 -4
	var grados: float = min(parent.dup_progress,1) * 360
	#draw_arc(Vector2.ZERO, radius, 0, PI*4/3, 24, Color.blue, 8)
	draw_circle_arc_poly(Vector2.ZERO, radius, 0, grados, parent.getColor())
	draw_arc(Vector2.ZERO, radius, 0, 2*PI, 64, parent.getColor(), 2, true)

# Codigo de https://docs.godotengine.org/es/stable/tutorials/2d/custom_drawing_in_2d.html#arc-polygon-function
func draw_circle_arc_poly(center:Vector2, radius:float, angle_from:float, angle_to:float, color:Color):
	var nb_points = 64
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 0)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update()
