extends PopupMenu

@onready var db = $"../../PersistanceMgr"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_index_pressed(index: int) -> void:
	match index:
		0: #quit
			save_game()
			get_tree().quit()

func save_game():
	pass
	db.save_game_parms()
	
