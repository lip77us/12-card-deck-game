extends PopupMenu


@export var ToolMenu: PopupMenu 

@onready var file_dialog = $"../../MenuPrimary/FileDialog"
@onready var user_name_node = $"../../UserName"
@onready var auotfill_button = $"../../AutofillButton"
@onready var bankroll_manager = $"../../PlayerBankrollMgr"

var text_edit
var bet_type_coord
var bet_gui_coord
var result_list_coord
var bet_manager
var tool_menu
var card_animator
var hand_history
var dealer
var in_browser=false
var autofill_bets = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	bet_type_coord=$"../../BetMgr/BetTypeCoord"
	bet_gui_coord = $"../../BetMgr/BetGUICoord"
	bet_manager = $"../../BetMgr"
	card_animator = $"../../CardAnimator"
	hand_history = $"../../HandHistory"
	text_edit = $"../../MenuPrimary/TextEdit"
	dealer = $"../../Dealer"
	result_list_coord = $"../../BetMgr/BetResultListCoord"
	#setup_tools_menu()
	in_browser=OS.has_feature("web_macos")
	auotfill_button.set_text("Auto Fill")
	
	#setup_submenus()
	#self.popup_menu[2].add_sub_menu("Slow")
	#self.popup_menu[2].add_sub_menu("Medium")
	#self.popup_menu[2].add_sub_menu("Fast")
	

func _on_index_pressed(index: int) -> void:
	match index:
		0: # Add Previous Preflop bets
			add_prev_preflop_bets(true)
		1: #Add All
			add_all_bets()
		2: #Export bet results
			export_results()
		3: # export hands
			export_hands()
		#4: #Deal Speed
			#deal_speed()
		4: #set the bankroll back to default start
			reset_bankroll()
		
				
			
func add_prev_preflop_bets(check_state):
	if ! dealer.preflop_state() and check_state:
		dealer.display_error("Only Allowed in Preflop State")
	else:
		var hand_number = dealer.get_hand_number()
		var bets = bet_manager.preflop_bets_for_hand_number(hand_number)
		for i in range(bets.size()):
			bet_manager.place_bet_from(bets[i].get_amount(), bets[i].get_type())
		
	
func add_all_bets():
	var bet_types = bet_type_coord.bet_types_eligible
	var amt = bet_gui_coord.bet_amount()
	for i in range(bet_types.size()):
		bet_manager.place_bet_from(amt, bet_types[i])
			
func deal_speed():
	pass

#func setup_tools_menu():
	#if ! in_browser:
		#card_animator.set_speed_index(2)
	#speed_submenu.name = "Speed"
	#tool_menu = $"."
	#tool_menu.add_child(speed_submenu)
	#tool_menu.add_submenu_item("Set Deal Speed...", "Speed")
	#speed_submenu.add_item("Slow")
	#speed_submenu.add_item("Medium")
	#speed_submenu.add_item("Fast")
	#speed_submenu.connect("index_pressed",_on_submenu_index_pressed)

func _on_submenu_index_pressed(index):
	card_animator.set_speed_index(index)
	
func export_results():
	#print ("In export Results")
	if in_browser:	
		#print ("In Export Results, In Browser")
		var results = ""
		var result_csv_lines = result_list_coord.result_csv_lines()
		for i in range(result_csv_lines.size()):
			results = results + result_csv_lines[i]+"\n"
		JavaScriptBridge.download_buffer(results.to_utf8_buffer(),"results.csv")
		
		#var console = JavaScriptBridge.get_interface("console")
		##print ("At start pf on browser if statement")
		##print ("line count = "+str(text_edit.get_line_count()))
		#for i in range(text_edit.get_line_count()):
			#console.log (text_edit.get_line(i))
			#print(text_edit.get_line(i))
		#print ("Output for Results...............")
	#else:
		##text_edit = $"../../MenuPrimary/TextEdit"
		#for i in range(text_edit.get_line_count()):
			#pass
			#print(text_edit.get_line(i))

		#text_edit = $"../../BetMgr/BetResultListCoord".text_edit
		#file_dialog.set_root_subfolder('downloads')
		#file_dialog.show()
	
func _on_file_dialog_file_selected(path: String) -> void:
	var f=FileAccess.open(path+".csv", FileAccess.WRITE)
	f.store_line(text_edit.text)
	f.close()
	file_dialog.hide()
	
func export_hands():
	var history = hand_history.hand_history_strings()
	if in_browser:	
		var results = ""
		for i in range(history.size()):
			results = results + history[i]+"\n"
		JavaScriptBridge.download_buffer(results.to_utf8_buffer(),"hand_history.csv")
	else:
		text_edit = $"../../HandHistory"
		file_dialog.set_root_subfolder('downloads')
		file_dialog.show()

func set_user_name():
	user_name_node.popup()
	

func _on_file_dialog_confirmed() -> void:
	
	pass # Replace with function body.
	
func in_browser_status():   #true if in broswer
	return in_browser

func autofill (): # see if autofill is on and if so, fill it up.
	if autofill_bets:
		add_prev_preflop_bets(false)
	
func _on_autofill_button_item_selected(index: int) -> void:
	# 0 is on, 1 is off
	autofill_bets = index==0
	
func reset_bankroll():
	bankroll_manager.set_bankroll_to(bankroll_manager.START_BANKROLL)
	bankroll_manager.update_bankroll_display()
	
