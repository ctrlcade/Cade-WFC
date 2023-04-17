extends Node3D

var rotation_speed = 20

# handles camera movement, up/down have limits so world boundary can't be seen
# controlled with arrow keys
func _process(delta : float) -> void:
	
	if Input.is_action_pressed("ui_left"):
		rotation_degrees.y -= rotation_speed * delta
		
	if Input.is_action_pressed("ui_right"):
		rotation_degrees.y += rotation_speed * delta
	
	if Input.is_action_pressed("ui_up"):
		if(rotation_degrees.x <= 5): 
			rotation_degrees.x += rotation_speed * delta
			
	if Input.is_action_pressed("ui_down"):
		if(rotation_degrees.x >= -25): 
			rotation_degrees.x -= rotation_speed * delta
