extends Node2D

export(int) var map_height = 5
export(int) var map_width = 5

var map_nodes = []

var data = []

var step = 0

func set_data(var _data, var shuffle = true):
	for d in _data:
		if(typeof(d) != TYPE_VECTOR2):
			printerr("Please only use vector 2")
		if(d.x > 1.0 || d.x < 0.0 || d.y > 1.0 || d.y < 0.0):
			printerr("Please normalize the data (Each Vector2 component should be between 0 and 1))")
		data.append(d)
	if(shuffle):
		data.shuffle()


func init_map():
	var delta = Vector2(1.0/(map_width), 1.0/(map_height))
	for i in range(map_height):
		map_nodes.append([])
		for j in range(map_width):
			map_nodes[i].append(Vector2(delta.x*(.5+j), delta.y*(.5+i)))
			

func kohonen_step():
	if(step >= data.size()):
		printerr("The number of steps should be equal tho the number of data")
		return
	
	var current_data = data[step]
	# Nearest point
	var nearest_k_point
	var nearest_kmap_pos
	var min_d = 1000
	for i in range(map_height):
		for j in range(map_width):
			var k_pos = map_nodes[i][j]
			var d = current_data.distance_to(k_pos)
			if d < min_d:
				min_d = d
				nearest_k_point = k_pos
				nearest_kmap_pos = [i,j]
	
	for i in range(map_height):
		for j in range(map_width):
			var k_pos = $Plot.get_point_position(map_nodes[i][j])
			var next_k_pos = k_pos + theta(nearest_kmap_pos,[i,j],step)*alpha(step)*(current_data - k_pos)
			map_nodes[i][j] = next_k_pos
	step+=1
	
	
func theta(u,v,s):
	return exp(- pow(map_distance(u,v),2) / (2*(1/float(s))))
func alpha(s):
	return .1
func map_distance(u,v):
	return 0.1*abs(u[0]-v[0]) + 0.1*abs(u[1]-v[1])
