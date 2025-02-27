extends ConfirmationDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ConfirmationDialog_canceled():

	# Hide the ConfirmationDialog or perform other actions when the user cancels

	get_node("ErrorDialog").hide() 
