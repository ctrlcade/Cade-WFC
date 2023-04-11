extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("ui_left"):
		rotation_degrees.y -= 20 * delta
		
	if Input.is_action_pressed("ui_right"):
		rotation_degrees.y += 20 * delta
		
	if Input.is_action_pressed("ui_up"):
		if(rotation_degrees.x <= 5): 
			rotation_degrees.x += 20 * delta
			
	if Input.is_action_pressed("ui_down"):
		if(rotation_degrees.x >= -25): 
			rotation_degrees.x -= 20 * delta
