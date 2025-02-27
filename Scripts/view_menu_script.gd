extends PopupMenu

@onready var hs_table = $"../../HighScoreTable"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_index_pressed(index: int) -> void:
	match index:
		0: # Add Previous Preflop bets
			show_top_scores()
		
func show_top_scores():
	for row in UserProfile.get_high_scores_db():
		hs_table.set_hs_data(row)
	hs_table.show()
