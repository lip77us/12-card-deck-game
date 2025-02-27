extends Control

@onready var user_name_entry = $NinePatchRect/VBoxContainer/UserNameLine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_login_button_pressed() -> void:
	#var error = get_tree().change_scene_to_file("res://Scenes/main.tscn")
	var user_name = user_name_entry.get_text()
	if user_name.length() > 0:
		if UserProfile.name_list_has(user_name):
			UserProfile.set_user_name(user_name)
			get_tree().change_scene_to_file ("res://Scenes/main.tscn")
		else:
			display_error("User Name not found", "New User Button??")
			
func display_error (title, error_message):
	var error_dialog = $NinePatchRect/VBoxContainer/ConfirmationDialog
	error_dialog.title = title
	error_dialog.set_cancel_button_text(error_message)
	error_dialog.popup()

func _on_new_user_button_pressed() -> void:
	var user_name = user_name_entry.get_text()
	if user_name.length() > 0:
		if UserProfile.name_list_has(user_name):
			display_error("User Name already in database", "Login Button??")
		else:
			UserProfile.set_user_name(user_name)
			get_tree().change_scene_to_file ("res://Scenes/main.tscn")
			
