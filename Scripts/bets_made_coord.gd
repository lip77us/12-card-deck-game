extends Node

var bets_made=[]
var bets_made_display_strings = []
var bet_gui_coordinator
var bet_type_coordinator
var bet_manager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bet_gui_coordinator = $"../BetGUICoord"
	bet_type_coordinator = $"../BetTypeCoord"
	bet_manager = $".."

func add(bet):
	bets_made.append(bet)
	bets_made_display_strings.append(bet.as_string())
	bet_gui_coordinator.new_bet(bet.as_string())
	
	
func remove(index): #deleted a bet before cards are dealt
	#bet_type_coordinator.bet_type_now_eligible(bets_made[index].type)
	var removed_bet = bets_made[index]
	bets_made.remove_at(index)
	bets_made_display_strings.remove_at(index)
	bet_manager.bet_removed(removed_bet)
	
func remove_processed_bet(index): #remove bet made because bet processed
	var removed_bet = bets_made[index]
	bets_made.remove_at(index)
	bets_made_display_strings.remove_at(index)
	bet_manager.bet_processed()
	
	
func update_bet_string_at(new_string, index):
	bets_made_display_strings[index]= new_string
	
func bet_made_at(index):
	return bets_made[index]

func has_bet (): #return a true if a bet has  been made
	return bets_made.size()>0
	
		
func clear_bets():  #round is complete.  Clear out bet list and GUI
	bets_made=[]
	bet_gui_coordinator.clear_bets_made()
	
func bets_made_types():
	var bmt = []
	for i in range(bets_made.size()):
		bmt.append(bets_made[i].type)
	return bmt
	
func bets_made_count():
	return bets_made.size()

func pop_back():
	bet_gui_coordinator.clear_bet_made_at(bets_made.size()-1)
	return bets_made.pop_back()
	
func pop_bets_completed_after_turn():
	var bets_completed_after_turn = []
	for i in range(bets_made.size()-1,-1,-1):
		var type = bets_made[i].get_type()
		if type.completed_after_turn() or (type.check_for_loss_after_turn() and 
		bet_manager.see_if_bet_lost(bets_made[i])):
			bets_completed_after_turn.append(bets_made[i])
			remove_processed_bet(i)
			bet_gui_coordinator.clear_bet_made_at(i)
	return bets_completed_after_turn
	
func pop_all_bets():
	var all_bets = []
	for i in range(bets_made.size()-1,-1,-1):
		all_bets.append(bets_made[i])
		bets_made.remove_at(i)
		bets_made_display_strings.remove_at(i)
		bet_gui_coordinator.clear_bet_made_at(i)
	return all_bets
	
	
func update_row_with_odds(index, win_odds_array):
	var string = bet_gui_coordinator.add_odds_to_bet(bets_made[index].as_string(),
		win_odds_array)
	bet_gui_coordinator.update_bet_string_at (string, index)
	update_bet_string_at (string, index)
	
	
func clear_bets_made():
	bets_made=[]
	bets_made_display_strings = []
	bet_gui_coordinator.clear_bets_made()
	
func ok_to_remove_bet(index):
	return bet_manager.ok_to_remove_bet(bets_made[index])
	
	
	
