extends Node3D

const worldsize = Vector3(8, 1, 8)
const init_mesh = preload("res://Scenes/Mesh.tscn")

var rules = WFCRules.new()
var wfc : WFC
var meshes : Array = []

# generate wave function collapse world at startup
func _ready():
	generate()
	
# check for input to regenerate the world during runtime, SPACEBAR to regen
func _process(_delta : float) -> void:
	if(Input.is_action_just_pressed("generate_world")):
		reset_world()
		generate()

# generate the wave function collapse world
func generate() -> void:
	wfc = WFC.new()
	wfc.init(worldsize, rules.ruleset)
	apply_custom_constraints()
	while not wfc.collapsed():
		wfc.iterate()
	display_wavefunction()
	if len(meshes) == 0:
		generate()

# reset world by clearing existing meshes
func reset_world() -> void:
	for mesh in meshes:
		mesh.queue_free()
	meshes = []

# apply custom constraints to the wave function collapse
func apply_custom_constraints() -> void:
	
	for x in range(worldsize.x):
		for y in range(worldsize.y):
			for z in range(worldsize.z):
				var coords = Vector3(x, y, z)
				var protos = wfc.available_chunks(coords)
				
				for proto in protos.duplicate():
					var neighs = protos[proto][WFC.MESH_NEIGHBOURS]
					var custom_constraint = protos[proto][WFC.CONSTRAIN_TO]
					var custom_constraint_from = protos[proto][WFC.CONSTRAIN_FROM]
				
					var	erase_proto = (
						(y == worldsize.y - 1 and not "Blank" in neighs[WFC.pZ]) or
						(y > 0 and custom_constraint == WFC.CONSTRAINT_BOTTOM) or
						(y < worldsize.y - 1 and custom_constraint == WFC.CONSTRAINT_TOP) or
						(y == 0 and ((not "Blank" in neighs[WFC.nZ]) or (custom_constraint_from == WFC.CONSTRAINT_BOTTOM))) or
						(x == worldsize.x - 1 and not "Blank" in neighs[WFC.pX]) or
						(x == 0 and not "Blank" in neighs[WFC.nX]) or
						(z == worldsize.z - 1 and not "Blank" in neighs[WFC.nY]) or
						(z == 0 and not "Blank" in neighs[WFC.pY])
					)

					if erase_proto:
						protos.erase(proto)
						if not coords in wfc.stack:
							wfc.stack.append(coords)

	wfc.propagate()

# display the final wave function collapse result
func display_wavefunction() -> void:
	for x in range(worldsize.x):
		for y in range(worldsize.y):
			for z in range(worldsize.z):
				
				var cur_wavefunction = wfc.wavefunction[x][y][z]
				
				if len(wfc.wavefunction[x][y][z]) > 1:
						continue
						
				for chunk in cur_wavefunction:
					
					if cur_wavefunction[chunk][wfc.MESH_LABEL] == 'Blank':
						continue
						
					var mesh_instance = init_mesh.instantiate()
					meshes.append(mesh_instance)
					add_child(mesh_instance)
					mesh_instance.mesh = load("res://Meshes/%s.res" % cur_wavefunction[chunk][wfc.MESH_LABEL])
					mesh_instance.rotate_y((PI/2) * cur_wavefunction[chunk][wfc.MESH_ROTATION])
					mesh_instance.position = Vector3(x, y, z)
