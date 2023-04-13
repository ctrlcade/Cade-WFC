# Original implementation by Martin Donald: https://www.youtube.com/watch?v=2SuvO4Gi7uY
# Modified by Cade Brown

extends Node
class_name WFC

# constants for mesh properties
const MESH_LABEL = "mesh_label"
const MESH_ROTATION = "mesh_rotation"
const MESH_NEIGHBOURS = "mesh_neighbours"
const MESH_WEIGHT = "mesh_weight" 

# constants for constraint properties
const CONSTRAIN_TO = "constrain_to"
const CONSTRAIN_FROM = "constrain_from"
const CONSTRAINT_BOTTOM = "bot"
const CONSTRAINT_TOP = "top"

# constants for directions
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

# wavefunction, world size, and propagation stack variables
var wavefunction : Array
var size : Vector3
var stack : Array

# initialise the wave function with given world size and meshes
func init(worldsize : Vector3, meshes : Dictionary) -> void:
	size = worldsize
	for _x in range(size.x):
		var y = []
		for _y in range(size.y):
			var z = []
			for _z in range(size.z):
				z.append(meshes.duplicate())
			y.append(z)
		wavefunction.append(y)


# check if the wave function has collapsed (all cells have a single possible state)
func collapsed() -> bool:
	for x in wavefunction:
		for y in x:
			for z in y:
				if len(z) > 1:
					return false
	return true

# get the available chunks at the specified coordinates
func available_chunks(coordinates : Vector3) -> Dictionary:
	return wavefunction[coordinates.x][coordinates.y][coordinates.z]
	
# get valid neighbours for the specified chunk at the corresponding coordinates and direction
func get_neighbours(coordinates : Vector3, direction : Vector3) -> Array:
	var valid_neighbours = []
	var meshes = available_chunks(coordinates)
	for mesh in meshes:
		var neighbours = meshes[mesh][MESH_NEIGHBOURS][direction_to_index[direction]]
		for neighbour in neighbours:
			if not neighbour in valid_neighbours:
				valid_neighbours.append(neighbour)
	return valid_neighbours
	
# collapse chunk at the specified coordinates
func collapse_chunk(coordinates : Vector3) -> void:
	var mesh_selection = wavefunction[coordinates.x][coordinates.y][coordinates.z]
	var selection = weighted_chunk(mesh_selection)
	wavefunction[coordinates.x][coordinates.y][coordinates.z] = {selection : mesh_selection[selection]}
	
# choose chunk based on weight
func weighted_chunk(meshes : Dictionary) -> String:
	var mesh_weights = {}
	for mesh in meshes:
		var weight = meshes[mesh][MESH_WEIGHT]
		weight += randf_range(-1.0, 1.0)
		mesh_weights[weight] = mesh
	var weight_list = mesh_weights.keys()
	weight_list.sort()
	return mesh_weights[weight_list[-1]]
	
# remove specified mesh from the wavefunction at specified coordinates
func constrain(coordinates : Vector3, mesh : String) -> void:
	wavefunction[coordinates.x][coordinates.y][coordinates.z].erase(mesh)

# get entropy (num of possible states) at the specified coordinates
func get_entropy(coordinates : Vector3) -> float:
	return len(wavefunction[coordinates.x][coordinates.y][coordinates.z])

# get the coordinates with the lowest entropy
func get_min_entropy_coords() -> Vector3:
	var min_entropy = INF
	var coords
	for x in range(size.x):
		for y in range(size.y):
			for z in range(size.z):
				var entropy = get_entropy(Vector3(x, y, z))
				if entropy > 1:
					entropy += randf_range(-0.1, 0.1)
					if entropy < min_entropy:
						min_entropy = entropy
						coords = Vector3(x, y, z)
	return coords

# iterate through the generation process
func iterate() -> void:
	var coords = get_min_entropy_coords()
	collapse_chunk(coords)
	propagate(coords)
	
# propagate constraints throughout the wavefunction
func propagate(coordinates : Vector3 = Vector3.ZERO) -> void:
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
					if not other_coordinates in stack:
						stack.append(other_coordinates)
		
# get valid directions based on the current coordinates
func valid_directions(coordinates : Vector3) -> Array:
	var dirs = []
	
	if coordinates.x > 0: dirs.append(Vector3.LEFT)
	if coordinates.x < size.x - 1: dirs.append(Vector3.RIGHT)
	if coordinates.y > 0: dirs.append(Vector3.DOWN)
	if coordinates.y < size.y - 1: dirs.append(Vector3.UP)
	if coordinates.z > 0: dirs.append(Vector3.FORWARD)
	if coordinates.z < size.z - 1: dirs.append(Vector3.BACK)
	
	return dirs

