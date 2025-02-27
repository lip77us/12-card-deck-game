extends Node

var file_dialog
var results_text_edit
var bet_type_coord
var bet_gui_coord
var bet_manager
 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	file_dialog = $"../FileDialog"
	results_text_edit = TextEdit.new()
	bet_type_coord=$"../../BetMgr/BetTypeCoord"
	bet_gui_coord = $"../../BetMgr/BetGUICoord"
	bet_manager = $"../../BetMgr"
	file_dialog.hide()
	file_dialog.set_root_subfolder("Downloads")
	file_dialog.set_use_native_dialog(true)
	#$"..".get_popup().id_pressed.connect(menu_primary_pressed)
	#text_edit.hide()
	




func _on_menu_primary_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	#print("menu clicked: "+str(index))
	pass
	
func menu_primary_pressed(index: int):
	match index:
		0:
			add_all_bets()
		1:
			export_results()
		

			
func export_results():
	#print("in export results")
	#text_edit.show()
	
	
	file_dialog.set_root_subfolder('downloads')
	file_dialog.show()
	#Download_File("/", "export.csv")
	#
#func Download_File(_path,_filename):
	#var f = File.new()
	#f.open(_path,File.READ)
	#var buf = f.get_buffer(f.get_len())
	#JavaScript.download_buffer(buf,_filename+".png")
	#f.close()
	

func _on_file_dialog_file_selectedxx(path: String) -> void:
	var f=FileAccess.open(path+".csv", FileAccess.WRITE)
	#fill_text_edit_with_results()
	f.store_line(results_text_edit.text)
	f.close()
	
#func fill_text_edit_with_results():
	#text_edit.insert_line_at(0,"header 1, Header2, Header3")
	#text_edit.insert_line_at(1,"Val 1, Val2, val3")
	
func add_all_bets():
	var bet_types = bet_type_coord.bet_types_eligible
	var amt = bet_gui_coord.bet_amount()
	for i in range(bet_types.size()):
		bet_manager.place_bet_from(amt, bet_types[i])
	
