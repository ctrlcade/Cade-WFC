extends RichTextLabel

@onready var world = get_node("/root/WFC-World")
var gen_time = ""

# provides player with world-based information
func _process(_delta):
	var worldsize = world.worldsize
	set_text("[right]WORLDSIZE\n" 
		+ "X: %s Y: %s Z: %s\n" % [worldsize.x, worldsize.y, worldsize.z]
		+ "Min X/Z: 8, Max X/Z: 20\n" 
		+ "Updates upon regeneration\n" 
		+ "Generated in %s seconds[/right]" % gen_time)
