# Original implementation by Martin Donald: https://www.youtube.com/watch?v=2SuvO4Gi7uY
# Modified by Cade Brown

extends Node
class_name WFC

# constants for mesh properties
const MESH_LABEL = "mesh_label"
const MESH_ROTATION = "mesh_rotation"
const MESH_NEIGHBOURS = "mesh_neighbours"
const MESH_WEIGHT = "mesh_weight" 

# constants for directions
const pX = 0
const pY = 1
const nX = 2
const nY = 3
const pZ = 4
const nZ = 5

# converts directions to indexes, useful for accessing neighbouring chunks 
const direction_to_index = {
	Vector3.LEFT : nX,
	Vector3.RIGHT : pX,
	Vector3.FORWARD : pY,
	Vector3.BACK : nY,
	Vector3.UP : pZ,
	Vector3.DOWN : nZ
}

# wavefunction, world size, and propagation stack variables
var wavefunction : Array
var size : Vector3
var stack : Array

# initializes the wave function as a 3D grid with a given world size and possible meshes
func init(worldsize : Vector3, meshes : Dictionary) -> void:
	size = worldsize
	for _x in range(size.x):
		
		# array to store y-axis 2D grid
		var y = []
		for _y in range(size.y):
			
			# array to store z-axis 1D grid
			var z = []
			for _z in range(size.z):
				
				# duplicates the meshes dictionary and appends it to the z array, each
				# entry in the z array represents a chunk along the z-axis and contains
				# all possible meshes that could exist within that chunk
				z.append(meshes.duplicate())
				
			y.append(z)
		wavefunction.append(y)

# check if the wave function has collapsed (all chunks have a single possible state)
func collapsed() -> bool:
	for x in wavefunction:
		for y in x:
			for z in y:
				
				# check possibilities for the current chunk 
				if len(z) > 1:
					
					# wave function yet to be collapsed
					return false
	
	# every chunk has exactly one state, wave function collapsed
	return true

# get the available chunks at the specified coordinates
func available_chunks(coordinates : Vector3) -> Dictionary:
	return wavefunction[coordinates.x][coordinates.y][coordinates.z]
	
# get valid neighbours for the specified chunk at the corresponding coordinates and direction
func get_neighbours(coordinates : Vector3, direction : Vector3) -> Array:
	
	var valid_neighbours = []
	var meshes = available_chunks(coordinates)
	for mesh in meshes:
		
		# gets the neighbouring chunks for the current mesh in the given direction
		var neighbours = meshes[mesh][MESH_NEIGHBOURS][direction_to_index[direction]]
		for neighbour in neighbours:
			
			# adds chunk to valid neighbours if it doesn't already exist, otherwise skip
			if not neighbour in valid_neighbours:
				valid_neighbours.append(neighbour)
				
	return valid_neighbours
	
# collapse chunk at the specified coordinates
func collapse_chunk(coordinates : Vector3) -> void:
	var mesh_selection = wavefunction[coordinates.x][coordinates.y][coordinates.z]
	var selection = weighted_chunk(mesh_selection)
	
	# updates wavefunction chunk at given coords, done by creating a new dictionary
	# with a single key-value pair, the key is the chosen mesh and the value is the
	# relevant mesh data from the mesh_selection dictionary, by doing this the possibilities
	# for the chunk at those coords is narrowed down to one, the selected mesh
	wavefunction[coordinates.x][coordinates.y][coordinates.z] = {selection : mesh_selection[selection]}
	
# choose chunk based on weight
func weighted_chunk(meshes : Dictionary) -> String:
	
	# creates empty dictionary, stores the modified weights of each 
	# mesh as keys, the values are the corresponding mesh labels
	var mesh_weights = {}
	
	for mesh in meshes:
		
		var weight = meshes[mesh][MESH_WEIGHT]
		
		# small random factor is added to the mesh weighting, this ranges from
		# -1.0 to 1.0 and sprinkles in some variety to the selection process
		weight += randf_range(-1.0, 1.0)
		
		mesh_weights[weight] = mesh
		
	# gets the modified weights from the mesh_weights dictionary
	var weight_list = mesh_weights.keys()
	
	# sorts the list into ascending order
	weight_list.sort()
	
	# gets the mesh_label for the mesh with the highest weight in the mesh_weights dictionary,
	# since the list is in ascending order, the last element can be accessed at index -1 and has
	# the highest weight value
	return mesh_weights[weight_list[-1]]
	
# remove specified mesh from the wavefunction at specified coordinates
func constrain(coordinates : Vector3, mesh : String) -> void:
	wavefunction[coordinates.x][coordinates.y][coordinates.z].erase(mesh)

# get entropy (number of possible states) at the specified coordinates
func get_entropy(coordinates : Vector3) -> float:
	return len(wavefunction[coordinates.x][coordinates.y][coordinates.z])

# get the coordinates with the lowest entropy
func get_min_entropy_coords() -> Vector3:
	
	# initialised to infinity to ensure that any encountered entropy value is smaller 
	var min_entropy = INF
	
	# stores lowest entropy coordinate
	var coords
	
	for x in range(size.x):
		for y in range(size.y):
			for z in range(size.z):
				var entropy = get_entropy(Vector3(x, y, z))
				
				# entropy larger than 1 means there are multiple possible states for current chunk
				if entropy > 1:
					if entropy < min_entropy:
						
						# update min_entropy with current entropy and 
						# store current coordinates in coords variable
						min_entropy = entropy
						coords = Vector3(x, y, z)
	return coords

# iterates through the generation process
func iterate() -> void:
	var coords = get_min_entropy_coords()
	collapse_chunk(coords)
	propagate(coords)
	
# propagate constraints throughout the wavefunction, optional parameter 'coordinates'
func propagate(coordinates : Vector3 = Vector3.ZERO) -> void:
	
	# check if the coordinates param is not null, add to the stack if it has a value
	if coordinates != null:
		stack.append(coordinates)
		
	# loop continues until stack is empty, at which point all coordinates will have been processed
	while !stack.is_empty():
		
		# takes last element from stack and assigns it to 'current_coordinates'
		var current_coordinates = stack.pop_back()
		
		# iterates over all valid directions for current coordinates
		for direction in valid_directions(current_coordinates):
			
			# calculates neighbouring chunk coordinates by adding direction vector to current coords
			var other_coordinates = (current_coordinates + direction)

			# get the number of valid neighbours for the current chunk in the given direction
			var neighbours_available = get_neighbours(current_coordinates, direction)
			
			# get available chunks for the neighbouring chunk, duplicates
			# the dictionary to avoid modifying the orignal mesh data
			var chunks_available = available_chunks(other_coordinates).duplicate()
			
			# checks amount of chunks available in the neighbouring chunk, if there 
			# are none then the loop will continue onto the next iteration
			if len(chunks_available) == 0:
				continue
		
			# iterates over available chunks for the neighbouring chunk
			for chunk in chunks_available:
				
				# checks if chunk is not a valid chunk in the specified direction
				if not chunk in neighbours_available:

					# remove chunk from the possibilities for the neighbouring cell as it is invalid
					constrain(other_coordinates, chunk)
					
					# checks if the neighbouring chunk's coordinates haven't been added to the stack
					if not other_coordinates in stack:
						
						# appends the neighbouring chunk's coords to the stack for the next iteration
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

