extends Node
class_name WFC

const MESH_LABEL = "mesh_label"
const MESH_ROTATION = "mesh_rotation"
const MESH_NEIGHBOURS = "mesh_neighbours"
const MESH_WEIGHT = "mesh_weight" 
const CONSTRAIN_TO = "constrain_to"
const CONSTRAIN_FROM = "constrain_from"
const CONSTRAINT_BOTTOM = "bot"
const CONSTRAINT_TOP = "top"

const pX = 0
const pY = 1
const nX = 2
const nY = 3
const pZ = 4
const nZ = 5

const direction_to_index = {
	Vector3.LEFT : 2,
	Vector3.RIGHT : 0,
	Vector3.FORWARD : 1,
	Vector3.BACK : 3,
	Vector3.UP : 4,
	Vector3.DOWN : 5
}

var wavefunction : Array
var size : Vector3
var stack : Array

func init(worldsize, meshes):
	size = worldsize
	for _x in range(size.x):
		var y = []
		for _y in range(size.y):
			var z = []
			for _z in range(size.z):
				z.append(meshes.duplicate())
			y.append(z)
		wavefunction.append(y)

func collapsed():
	for x in wavefunction:
		for y in x:
			for z in y:
				if len(z) > 1:
					return false
	return true

func available_chunks(coordinates):
	return wavefunction[coordinates.x][coordinates.y][coordinates.z]
	
func get_neighbours(coordinates, direction):
	var valid_neighbours = []
	var meshes = available_chunks(coordinates)
	for mesh in meshes:
		var neighbours = meshes[mesh][MESH_NEIGHBOURS][direction_to_index[direction]]
		for neighbour in neighbours:
			if not neighbour in valid_neighbours:
				valid_neighbours.append(neighbour)
	return valid_neighbours
	
func collapse_chunk(coordinates):
	var mesh_selection = wavefunction[coordinates.x][coordinates.y][coordinates.z]
	var selection = weighted_chunk(mesh_selection)
	wavefunction[coordinates.x][coordinates.y][coordinates.z] = {selection : mesh_selection[selection]}
	
func weighted_chunk(meshes):
	var mesh_weights = {}
	for mesh in meshes:
		var weight = meshes[mesh][MESH_WEIGHT]
		weight += randf_range(-1.0, 1.0)
		mesh_weights[weight] = mesh
	var weight_list = mesh_weights.keys()
	weight_list.sort()
	return mesh_weights[weight_list[-1]]
	
func constrain(coordinates, mesh):
	wavefunction[coordinates.x][coordinates.y][coordinates.z].erase(mesh)

func get_entropy(coordinates):
	return len(wavefunction[coordinates.x][coordinates.y][coordinates.z])


func get_min_entropy_coords():
	var min_entropy
	var coords
	for x in range(size.x):
		for y in range(size.y):
			for z in range(size.z):
				var entropy = get_entropy(Vector3(x, y, z))
				if entropy > 1:
					entropy += randf_range(-0.1, 0.1)
					
					if not min_entropy:
						min_entropy = entropy
						coords = Vector3(x, y, z)
					elif entropy < min_entropy:
						min_entropy = entropy
						coords = Vector3(x, y, z)
	return coords


#func entropy():
#	for x in range(size.x):
#		for y in range(size.y):
#			for z in range(size.z):
#				if len(wavefunction[x][y][z]) > 1:
#					return Vector3(x, y, z)

func iterate():
#	var coords = entropy()
	var coords = get_min_entropy_coords()
	collapse_chunk(coords)
	propagate(coords)
	
func propagate(coordinates):
	if coordinates:
		stack.append(coordinates)
	while !stack.is_empty():
		var current_coordinates = stack.pop_back()
		for direction in valid_directions(current_coordinates):
			var other_coordinates = (current_coordinates + direction)
			var neighbours_available = get_neighbours(current_coordinates, direction)
			var chunks_available = available_chunks(other_coordinates).duplicate()
			
			if len(chunks_available) == 0:
				continue
		
			for chunk in chunks_available:
				if not chunk in neighbours_available:
					constrain(other_coordinates, chunk)
#					wavefunction[other_coordinates.x][other_coordinates.y][other_coordinates.z].erase(chunk)
					if not other_coordinates in stack:
						stack.append(other_coordinates)
		
func valid_directions(coordinates):
	var dirs = []
	
	if coordinates.x > 0: dirs.append(Vector3.LEFT)
	if coordinates.x < size.x-1: dirs.append(Vector3.RIGHT)
	if coordinates.y > 0: dirs.append(Vector3.DOWN)
	if coordinates.y < size.y-1: dirs.append(Vector3.UP)
	if coordinates.z > 0: dirs.append(Vector3.FORWARD)
	if coordinates.z < size.z-1: dirs.append(Vector3.BACK)
	
	return dirs

