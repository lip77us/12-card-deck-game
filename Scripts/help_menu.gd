extends PopupMenu

const version_string = "version 0.4.1 Feb 9, 2025"

var ok_or_cancel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ok_or_cancel = $"../../OkWithNoCancel"

			
func show_version_number():
		#action_dialog.set_text ("Do you want to remove the "+bet_string+ " bet")
	#if cancel_button == null:
		#cancel_button = action_dialog.add_cancel_button("Cancel")
	ok_or_cancel.set_text(version_string)
	ok_or_cancel.title = "Version Number"
	ok_or_cancel.show()

func show_rules():
	ok_or_cancel.set_text("Coming Soon")
	ok_or_cancel.title = "Rules"
	ok_or_cancel.show()

func _on_index_pressed(index: int) -> void:
	match index:
		0: #quit
			show_version_number()
		1: 
			show_rules()
			
