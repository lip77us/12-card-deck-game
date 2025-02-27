extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	get_popup().add_item("Bet All")
	get_popup().add_item("Export")
	#get_popup().add_item("Clear Export Screen")
	get_popup().add_item("Help")
	
