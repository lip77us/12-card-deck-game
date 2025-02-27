extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for row in UserProfile.get_high_scores_db():
		set_hs_data(row)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
var row = preload("res://Scenes/high_score_row.tscn")
@onready var hs_table = get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer")

#var hs_data =[
	#{"Place":"1", "Name":"Paul", "Score":"150", "Date": "02/02/2025" },
	#{"Place":"2", "Name":"Jim", "Score":"140", "Date": "02/03/2025" },
	#{"Place":"3", "Name":"Bill", "Score":"133", "Date": "02/08/2025" },
	#{"Place":"4", "Name":"Sam", "Score":"132", "Date": "01/09/2025" },
	#{"Place":"5", "Name":"Ryan", "Score":"110", "Date": "01/15/2025" }
#]

func set_hs_data(hs_data):
	var instance = row.instantiate()
	instance.name=hs_data["Place"]
	instance.user_name = hs_data["Name"]
	instance.place = hs_data["Place"]
	instance.score = str(hs_data["High Score"])
	instance.date = hs_data["Date"]
	hs_table.add_child(instance)
	
	var node_path = "VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"
	get_node(node_path+instance.name+"/1").text=instance.place
	get_node(node_path+instance.name+"/2").text=instance.user_name
	get_node(node_path+instance.name+"/3").text=instance.score
	get_node(node_path+instance.name+"/4").text=instance.date
	
	


func _on_button_pressed() -> void:
	var children = hs_table.get_children()
	for child in children:
		child.free()
	self.hide()
