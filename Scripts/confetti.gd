extends Node2D

var enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func turn_on(on_flag):
	if ! enabled:
		return
	var children
	var colors
	children = get_children()
	colors = children[0].get_children()
	for i in range(colors.size()):
		colors[i].emitting = on_flag
	children[1].playing=on_flag
		
		
func set_level(level):
	var amount
	var explode
	var db
	match level:
		1: 
			amount = 5
			explode = 0.2
			db = -20
		2: 
			amount = 20
			explode = 0.4
			db = -10
		3: 
			amount = 100
			explode = 0.8
			db = 8
			
	var children = self.get_children()
	var colors = children[0].get_children()
	for i in range(colors.size()):
		colors[i].amount = amount
		colors[i].explosiveness = explode
	children[1].volume_db = db
		
func enable():
	enabled = true

func disable():
	enabled = false
