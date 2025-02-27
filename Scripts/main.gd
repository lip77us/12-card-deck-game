extends Node2D

@onready var db_manager = $PersistanceMgr
func _ready():
	pass
	#get_tree().call_deferred("change_scene_to_file", "res://Scenes/login_screen.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if UserProfile.get_user_name() == "" and UserProfile.name_list_size() > 0:
		get_tree().change_scene_to_file("res://Scenes/login_screen.tscn")
	else:
		pass
	if UserProfile.get_user_name().length() > 0:
		db_manager.update_persistant_objects()
	
func _on_quit_button_pressed():
	#get_tree().change_scene_to_file("res://Scenes/login_screen.tscn") # 
	UserProfile.test()

func _on_tools_index_pressed(index: int) -> void:
	pass # Replace with function body.
