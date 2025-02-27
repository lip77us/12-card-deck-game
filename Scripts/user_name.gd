extends Node

@onready var main = $".."

var user_name = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_user_name():
	return user_name

func set_user_name(string):
	user_name = string
	
func popup():
	var popup = get_child(0)
	var name_entry = popup.get_child(1)
	name_entry.set_text(get_user_name()) #this is the text entry object
	name_entry.select_all()
	name_entry.grab_focus()
	popup.show()
	
	

func _on_cancel_button_pressed() -> void:
	get_child(0).hide()


func _on_ok_button_pressed() -> void:
	var name = get_child(0).get_child(1).get_text()
	set_user_name(name)
	get_child(0).hide()


func _on_name_entry_text_submitted(new_text: String) -> void:
	_on_ok_button_pressed()

func save():
	var save_data = [["user name", get_user_name()]]
	return save_data
	
func load_parms(parm_dict):
	set_user_name (parm_dict["user name"])
	
