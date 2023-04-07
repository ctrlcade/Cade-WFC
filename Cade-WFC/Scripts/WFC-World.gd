extends Node3D

const worldsize = Vector3(8, 1, 8)
const init_mesh = preload("res://Scenes/Mesh.tscn")

var worldseed = randi()

var wfc : WFC
var meshes : Array
var coords : Vector3

func _ready():
	randomize()
	generate()
	
func _process(_delta):
	if(Input.is_action_just_pressed("ui_accept")):
		resetworld()
		generate()

func generate():
	wfc = WFC.new()
	wfc.init(worldsize, load_mesh_data())
	apply_custom_constraints()
	while not wfc.collapsed():
		wfc.iterate()
	display_wavefunction()
	if len(meshes) == 0:
		worldseed += 1
		generate()

func resetworld():
	for mesh in meshes:
		mesh.queue_free()
	meshes = []


func apply_custom_constraints():
	# This function isn't covered in the video but what we do here is basically
	# go over the wavefunction and remove certain modules from specific places
	# for example in my Blender scene I've marked all of the beach tiles with
	# an attribute called "constrain_to" with the value "bot". This is recalled
	# in this function, and all tiles with this attribute and value are removed
	# from cells that are not at the bottom i.e., if y > 0: constrain.
	var add_to_stack = []
	
	for x in range(worldsize.x):
		for y in range(worldsize.y):
			for z in range(worldsize.z):
				coords = Vector3(x, y, z)
				var protos = wfc.available_chunks(coords)
				if y == worldsize.y - 1:  # constrain top layer to not contain any uncapped prototypes
					for proto in protos.duplicate():
						var neighs = protos[proto][WFC.MESH_NEIGHBOURS][WFC.pZ]
						if not "p-1" in neighs:
							protos.erase(proto)
							if not coords in wfc.stack:
								wfc.stack.append(coords)
				if y > 0:  # everything other than the bottom
					for proto in protos.duplicate():
						var custom_constraint = protos[proto][WFC.CONSTRAIN_TO]
						if custom_constraint == WFC.CONSTRAINT_BOTTOM:
							protos.erase(proto)
							if not coords in wfc.stack:
								wfc.stack.append(coords)
				if y < worldsize.y - 1:  # everything other than the top
					for proto in protos.duplicate():
						var custom_constraint = protos[proto][WFC.CONSTRAIN_TO]
						if custom_constraint == WFC.CONSTRAINT_TOP:
							protos.erase(proto)
							if not coords in wfc.stack:
								wfc.stack.append(coords)
				if y == 0:  # constrain bottom layer so we don't start with any top-cliff parts at the bottom
					for proto in protos.duplicate():
						var neighs  = protos[proto][WFC.MESH_NEIGHBOURS][WFC.nZ]
						var custom_constraint = protos[proto][WFC.CONSTRAIN_FROM]
						if (not "p-1" in neighs) or (custom_constraint == WFC.CONSTRAINT_BOTTOM):
							protos.erase(proto)
							if not coords in wfc.stack:
								wfc.stack.append(coords)
				if x == worldsize.x - 1: # constrain +x
					for proto in protos.duplicate():
						var neighs  = protos[proto][WFC.MESH_NEIGHBOURS][WFC.pX]
						if not "p-1" in neighs:
							protos.erase(proto)
							if not coords in wfc.stack:
								wfc.stack.append(coords)
				if x == 0: # constrain -x
					for proto in protos.duplicate():
						var neighs  = protos[proto][WFC.MESH_NEIGHBOURS][WFC.nX]
						if not "p-1" in neighs:
							protos.erase(proto)
							if not coords in wfc.stack:
								wfc.stack.append(coords)
				if z == worldsize.z - 1: # constrain +z
					for proto in protos.duplicate():
						var neighs  = protos[proto][WFC.MESH_NEIGHBOURS][WFC.nY]
						if not "p-1" in neighs:
							protos.erase(proto)
							if not coords in wfc.stack:
								wfc.stack.append(coords)
				if z == 0: # constrain -z
					for proto in protos.duplicate():
						var neighs  = protos[proto][WFC.MESH_NEIGHBOURS][WFC.pY]
						if not "p-1" in neighs:
							protos.erase(proto)
							if not coords in wfc.stack:
								wfc.stack.append(coords)

	wfc.propagate(false)
	
func load_mesh_data():
	var jsonfile = FileAccess.open("res://mesh_data.json", FileAccess.READ)
	var parser = JSON.new()
	var _parse_err = parser.parse(jsonfile.get_as_text())
	return parser.get_data()
	
	
func display_wavefunction():
	for x in range(worldsize.x):
		for y in range(worldsize.y):
			for z in range(worldsize.z):
				
				if len(wfc.wavefunction[x][y][z]) > 1:
						continue
						
				for chunk in wfc.wavefunction[x][y][z]:
					if wfc.wavefunction[x][y][z][chunk][wfc.MESH_LABEL] == 'Blank':
						continue
					var mesh = init_mesh.instantiate()
					meshes.append(mesh)
					add_child(mesh)
					mesh.mesh = load("res://Meshes/%s.res" % wfc.wavefunction[x][y][z][chunk][wfc.MESH_LABEL])
					mesh.rotate_y((PI/2) * wfc.wavefunction[x][y][z][chunk][wfc.MESH_ROTATION])
					mesh.position = Vector3(x, y, z)
