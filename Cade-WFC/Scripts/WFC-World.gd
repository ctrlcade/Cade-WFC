# Original implementation by Martin Donald: https://www.youtube.com/watch?v=2SuvO4Gi7uY
# Modified by Cade Brown

extends Node3D

# constants
const WORLDSIZE_MAX_LIMIT = 20
const WORLDSIZE_MIN_LIMIT = 8
const CAMERA_INC = 0.5
const INIT_MESH = preload("res://Scenes/WFC-Mesh.tscn")

# camera and worldinfo ui refs
@onready var camera = get_node("/root/WFC-World/Camera/Camera3D") as Camera3D
@onready var worldinfo_ui = get_node("/root/WFC-World/WorldInfo_UI/WorldInfo")

var worldsize = Vector3(10, 1, 10)
var rules = WFCRules.new()
var wfc : WFC
var meshes : Array = []
var start_time 

# generate wave function collapse world at startup, hide cursor and also get generation time
func _ready():
	start_time = Time.get_ticks_msec()
	generate()
	worldinfo_ui.gen_time = str((Time.get_ticks_msec() - start_time) * 0.001)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
# check input to regenerate the world during runtime, SPACEBAR to regen, ESC to quit
func _process(_delta : float) -> void:

	# ensure camera is in reasonable position relative to worldsize
	position_camera()
	
	if Input.is_action_just_pressed("Generate"):
		start_time = Time.get_ticks_msec()
		reset_world()
		generate()
		worldinfo_ui.gen_time = str((Time.get_ticks_msec() - start_time) * 0.001)
		
		
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

# changes camera position depending on the current worldsize
func position_camera() -> void:
	
	if Input.is_action_just_pressed("Worldsize-X-Plus") && worldsize.x < WORLDSIZE_MAX_LIMIT:
		worldsize.x += 1
		camera.position.y += CAMERA_INC
		camera.position.x += CAMERA_INC
		
	if Input.is_action_just_pressed("Worldsize-X-Sub") && worldsize.x > WORLDSIZE_MIN_LIMIT:
		worldsize.x -= 1
		camera.position.y -= CAMERA_INC
		camera.position.x -= CAMERA_INC
		
	if Input.is_action_just_pressed("Worldsize-Z-Plus") && worldsize.z < WORLDSIZE_MAX_LIMIT:
		worldsize.z += 1
		camera.position.y += CAMERA_INC
		camera.position.z += CAMERA_INC * 2
		
	if Input.is_action_just_pressed("Worldsize-Z-Sub") && worldsize.z > WORLDSIZE_MIN_LIMIT:
		worldsize.z -= 1
		camera.position.y -= CAMERA_INC
		camera.position.z -= CAMERA_INC * 2

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
						
					var mesh_instance = INIT_MESH.instantiate()
					meshes.append(mesh_instance)
					add_child(mesh_instance)
					mesh_instance.mesh = load("res://Meshes/%s.res" % cur_wavefunction[chunk][wfc.MESH_LABEL])
					mesh_instance.rotate_y((PI/2) * cur_wavefunction[chunk][wfc.MESH_ROTATION])
					mesh_instance.position = Vector3(x, y, z)
