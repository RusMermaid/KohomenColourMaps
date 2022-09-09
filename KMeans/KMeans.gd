extends Node2D
export(int) var number_of_clusters = 25

var means = []

var data = []

var step = 0


func set_data(var _data):
	for d in _data:
		if(typeof(d) != TYPE_VECTOR2):
			printerr("Please only use vector 2")
		if(d.x > 1.0 || d.x < 0.0 || d.y > 1.0 || d.y < 0.0):
			printerr("Please normalize the data (Each Vector2 component should be between 0 and 1))")
		data.append(d)

func init_kmeans_random():
	for i in range(number_of_clusters):
		means.append(Vector2(randf(),randf()))
	pass

func kmeans_step():
	
	var assigned_points = {}
	
	for entry in data:
		
		
		var nearest_mean = 0
		var dist_to_mean = entry.distance_squared_to(means[0])
		
		for i in range(1,len(means)):
			var ndist_to_mean = entry.distance_squared_to(means[i])
			if(ndist_to_mean<dist_to_mean):
				nearest_mean = i
				dist_to_mean = ndist_to_mean
		
		if(assigned_points.has(nearest_mean)):
			assigned_points[nearest_mean] += [entry]
		else:
			assigned_points[nearest_mean] = [entry]
	
	for k in assigned_points.keys():
		var kmean = Vector2.ZERO
		for point in assigned_points[k]:
			kmean += point
		kmean /= len(assigned_points[k])
		means[k] = kmean
	
	print(">>> Step " + str(step) + " done")
	print("Means : " + str(means))
	step+=1
