extends Node2D

#const STATE_PRE_DEAL = "state_pre_deal"
#const STATE_FLOP_COMPLETE = "state_flop_complete"
#const STATE_TURN_COMPLETE = "state_turn_complete"
#const STATE_WAITING_TO_CLEAR = "state_waiting_to_clear"

#GUI components
var place_bet_button
var bet_type_button
var bet_amount_spinner
var bets_made_list
var bets_results_list
var bet_type_strings
var action_dialog
var ok_to_deal_dialog

var dealer
var bet_type_coord
var bet_manager
var bets_made_coord
#var deal_state = STATE_PRE_DEAL
var bet_list_item_selected
var bet_type_selected
var cancel_button
var ok_to_deal_cancel_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_coordinators()
	setup_gui_variables()
	#connect_dealer_states()
	pre_deal()

func setup_gui_variables():
	bet_type_button = $"../../Table Layout/BetPanel/Bet_Type_Panel/BetTypeButton"
	place_bet_button = $"../../Table Layout/BetPanel/PlaceBetButton"
	bet_amount_spinner = $"../../Table Layout/BetPanel/BetAmtSpinBox"
	bets_made_list = $"../../Table Layout/BetsMadePanel/BetsMadeList"
	bets_results_list = $"../../Table Layout/BetsResultPanel/BetsResults/BetsResultsList"
	action_dialog = $"../../OkOrCancel"
	ok_to_deal_dialog = $"../../OkOrCancelDealOK"
	
	
func setup_coordinators():
	dealer = $"../../Dealer"
	bet_type_coord = $"../BetTypeCoord"
	bet_manager = $".."
	bets_made_coord = $"../BetsMadeCoord"
	#
#func connect_dealer_states():
	#dealer.state_pre_deal.connect(pre_deal)
	#dealer.state_flop_complete.connect(flop_complete)
	#dealer.state_turn_complete.connect(turn_complete)
	#dealer.state_waiting_to_clear.connect(waiting_to_clear)
	
func pre_deal():
	bet_type_strings = bet_type_coord.preflop_bet_types_strings()
	setup_bet_types_menu(bet_type_strings)
	bet_type_button.get_popup().id_pressed.connect(bet_type_menu_pressed)
	reset_bet_type_button_text()
	#place_bet_button.disabled = true
	#bet_type_button.set_text("Bet Type")
	
func setup_bet_types_menu(strings):
	bet_type_button.get_popup().clear()
	for i in range(strings.size()):
		bet_type_button.get_popup().add_item(strings[i])
	bet_type_strings = strings

func flop_complete():
	bet_type_button.get_popup().clear()
	
func turn_complete():
	bet_type_strings = bet_type_coord.turn_bet_types_strings()
	setup_bet_types_menu(bet_type_strings)
	bet_type_button.get_popup().id_pressed.connect(bet_type_menu_pressed)
	reset_bet_type_button_text()
	#place_bet_button.disabled = true
	#bet_type_button.set_text("Bet Type")
	
func waiting_to_clear():
	pass	

func bet_type_menu_pressed(id:int):
	bet_type_button.text = bet_type_strings[id]
	bet_type_selected = bet_type_coord.get_type_at(id)
	place_bet_button.disabled = false
	
func reset_bet_type_button_text():
	bet_type_button.set_text("Bet Type")
	place_bet_button.set_disabled(true)
	bet_type_selected = null
	
func bet_amount():
	return bet_amount_spinner.value
	
func new_bet(bet_made_string):
	bets_made_list.add_item(bet_made_string)
	reset_bet_type_button_text()
	
func clear_list (vbox_container):
	for child in vbox_container.get_children():
		vbox_container.remove_child(child) 
		
func clear_bets_made():  #round is complete.  Clear out bet list and GUI
	bets_made_list.clear()
	
func clear_bet_made_at(index):
	bets_made_list.remove_item(index)
	
func update_bet_string_at(string, index):
	bets_made_list.set_item_text(index,string)
	bets_made_list.set_item_custom_fg_color(index,Color.WHITE)
	
func selected_type():
	return bet_type_selected
	
func add_odds_to_bet(string, odds_array):
	return string + " odds: " + str(odds_array[0]) + " of " + str(odds_array[1])
	
func append_bets_results_display(bet_result):
	var red = Color(1,0,0.0,1.0)
	var black = Color( 0, 0, 0, 1)
	var white = Color( 1, 1, 1, 1)
	var color
	
	if (bet_result.get_won_or_lost() <= 0):
		color=black
	else:
		color=white
	add_string_to_result_list(bet_result.as_string(), color)
	
func add_string_to_result_list(string, color):
	
	var label = Label.new()  # Create a new Label node
	label.text = string
	label.set("theme_override_font_sizes/font_size", 28)
	label.set("theme_override_colors/font_color",color)
	bets_results_list.add_child(label)  # Add the Label to the VBoxContainer
	
func deal_complete(deal_number):
	var black = Color( 0, 0, 0, 1)
	add_string_to_result_list("---------------  Hand "+ str(deal_number)+"  ----------------", black)
	
func remove_bet(index):
	bets_made_list.remove_item(index)
				# need to remove this bet from list
				
func cancel_dialog_option(bet_string):  #return a true of user cancels bet
	action_dialog.set_text ("Do you want to remove the "+bet_string+ " bet")
	if cancel_button == null:
		cancel_button = action_dialog.add_cancel_button("Cancel")
	action_dialog.set_ok_button_text ("Remove Bet")
	action_dialog.title = "Bet Removal"
	action_dialog.show()
	
func confirm_ready_to_deal():
	if bet_type_selected == null:
		return true
	else:
		#ok_to_deal_dialog.set_text ("Do you want to remove the "+bet_string+ " bet")
		if ok_to_deal_cancel_button == null:
			ok_to_deal_cancel_button = ok_to_deal_dialog.add_cancel_button("Cancel")
		ok_to_deal_dialog.set_ok_button_text ("Remove Bet")
		ok_to_deal_dialog.title = "OK to Deal?"
		ok_to_deal_dialog.show()
		return false
		

	

func _on_ok_or_cancel_confirmed() -> void:
	#match deal_state:
		#STATE_PRE_DEAL:
		bets_made_coord.remove(bet_list_item_selected)
		bets_made_list.remove_item(bet_list_item_selected)


func _on_bets_made_list_item_activated(index: int) -> void:
	bet_list_item_selected = index
	if bets_made_coord.ok_to_remove_bet(index):
		cancel_dialog_option(bets_made_list.get_item_text(index))


func _on_ok_or_cancel_deal_ok_canceled() -> void:
	pass # Replace with function body.


func _on_ok_or_cancel_deal_ok_confirmed() -> void:
	reset_bet_type_button_text() # clear the bet so I cna deal
