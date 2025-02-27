extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_v_scroll_bar().custom_minimum_size.x = 20;
	get_h_scroll_bar().custom_minimum_size.x = 20;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
