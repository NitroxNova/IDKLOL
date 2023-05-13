extends Shoreline_Builder
class_name Pier_Builder

var piers = []

func _init(width,height):
	super(width,height)
	build_piers()

func build_piers():
#	#add piers
	for i in randi_range(8,12):
		var y = randi_range(1,size.y)-1
		for x in range(2+randi_range(1,6),water_width[y] + 3):
			piers.append(Vector2(x,y))

func render():
	super()
	for pier in piers:
		var data = {}
		data.needs_render = true
		data.position = Vector3(pier.x,0,pier.y) + Vector3(position.x,0,position.y)
		data.renderable = Renderable.FLOOR
		data.material = Material_3D.WOOD
		emit_signal("create_entity",data)
		
