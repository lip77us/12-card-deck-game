extends Node2D  # manages the logic of the bets.  Will dispatch to Bet_GUI_Coord to setup
				# GUI objects
				# Responsibilitied of bet_mgr are to decide what bets are OK when and to
				# update the bests made disolay and to ask the bet to evaluate itself
				# and to update the bet result when a bet is resolved.  Also, it will 
				# update the bet completed list

const BET_SCENE_PATH = "res://Scenes/bet.tscn"
# const BET_TYPE_SCENE_PATH = "res://Scenes/bet_type.tscn"

const STATE_PRE_DEAL = "state_pre_deal"
const STATE_FLOP_COMPLETE = "state_flop_complete"
const STATE_TURN_COMPLETE = "state_turn_complete"
const STATE_WAITING_TO_CLEAR = "state_waiting_to_clear"

@onready var db = $"../PersistanceMgr"

var bet_scene
var bet_type_scene

var bets_results=[]
var bets_results_archive=[] # hack to store another copy as a nested array with 
							# hand number as the 1st element and results the 2nd
var bet_type_selected=false

var bet_gui_coordinator
var bet_type_coordinator
var bets_made_coordinator
var bet_result_list_mgr
var dealer

var deal_state = STATE_PRE_DEAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bet_scene = preload(BET_SCENE_PATH)
	bet_gui_coordinator = $"BetGUICoord"
	bet_type_coordinator = $"BetTypeCoord"
	bets_made_coordinator = $"BetsMadeCoord"
	bet_result_list_mgr = $"BetResultListCoord"
	dealer = $"../Dealer"
	
func setup_turn_bet_state():
	pass

func setup_turn_menu(bet_type_strings):
	pass

func bet_type_menu_pressed_turn(id:int):
	#bet_type_button.text = BetType.postflop_bet_type_strings()[id]
	#bet_type_selected=true
	pass
	
func bet_selected():
	pass
	
func prepare_new_bet(bet_amount, bet_type):
	var new_bet = Bet.new()
	new_bet.amount = bet_amount
	new_bet.set_bet_type(bet_type)
	return new_bet
	
func place_bet():  #called from the main line if I want to make a bet from the GUI
	var amount = bet_gui_coordinator.bet_amount()
	var type = bet_type_coordinator.get_bet_type()
	var new_bet = prepare_new_bet(amount, type)
	bet_lock_in(new_bet)
	redo_bet_types()
	
func place_bet_from(amount, type): # called if you already have an amt and type object
	var new_bet = prepare_new_bet(amount, type)
	bet_lock_in(new_bet)
	
	
func bet_lock_in(new_bet):
	bets_made_coordinator.add(new_bet)
	$"../PlayerBankrollMgr".update_bankroll(-new_bet.amount)
	
func bet_removed(bet):
	$"../PlayerBankrollMgr".update_bankroll(bet.amount)
	redo_bet_types()
	
func bet_processed(): # bet is now a result
	redo_bet_types()
	
func update_bets_results(player_hand, dealer_hand, deal_number):
	var total_results_amount=0
	var processing_turn_bet = false
	var bets=[]
	if player_hand.cards.size() == 4:  #This is the turn
		bet_result_list_mgr.set_deal_number(deal_number) # put the deal number only once 
		processing_turn_bet = true
	if processing_turn_bet:
		bets=bets_made_coordinator.pop_bets_completed_after_turn()
	else:
		bets = bets_made_coordinator.pop_all_bets()
	total_results_amount = bets_to_results(bets, player_hand, dealer_hand, deal_number)
	
	return total_results_amount
	
func bets_to_results(bets, player_hand, dealer_hand, deal_number):
	var total_results_amount = 0
	for i in range(bets.size()):
		var bet_result = BetResult.new()
		var payout = 0
		var bet=bets[i]
		if (bet.get_type().is_winner(player_hand, dealer_hand,
			$"../Deck".peak_at_last_values(4))):
			payout = bet.payout_multiplier() * bet.get_amount()
			bet_result.set_dollars_won(bet.get_amount()*bet.get_payout_odds())
		else:
			bet_result.set_dollars_lost(bet.get_amount())				
		bet_result.set_original_bet (bet)
		db.update_bets_data_base(bet_result.db_format())
		total_results_amount += payout
		bets_results.append(bet_result)
		bets_results_archive.append([deal_number,bet_result])
		bet_gui_coordinator.append_bets_results_display(bet_result)	
		bet_result_list_mgr.add_result(bet_result)
	return total_results_amount
		
		
func update_after_flop(player_hand,dealer_hand):
	for i in range(bets_made_coordinator.bets_made_count()):
		#if !bets_made.type.completed_after_turn():
		var win_odds_array = $"../OddsCalculator".calculate_odds_to_win_on_flop(player_hand, 
		dealer_hand, bets_made_coordinator.bet_made_at(i).type)
		bets_made_coordinator.update_row_with_odds(i, win_odds_array)
		#bet_gui_coordinator.update_row_after_flop_or_turn (bets_made[i], win_odds_array)
	
func update_after_turn(player_hand,dealer_hand):
	#bet_gui_coordinator.clear_bets_made()
	for i in range(bets_made_coordinator.bets_made_count()):
		var win_odds_array = $"../OddsCalculator".calculate_odds_to_win_on_turn(player_hand, 
		dealer_hand, bets_made_coordinator.bet_made_at(i).type)
		bets_made_coordinator.update_row_with_odds(i, win_odds_array)
		
func redo_bet_types():
	bet_type_coordinator.update_bet_types()

func has_bet():
	return bets_made_coordinator.has_bet()
	
func clear_bets():
	bets_made_coordinator.clear_bets_made()
	
func see_if_bet_lost(bet):
	return ! bet.get_type().is_winner(dealer.player_hand,dealer.dealer_hand, 
	dealer.deck.peak_at_values(4))
	
func preflop_bets_for_hand_number(hand_number):
	var bets=[]
	if bets_results_archive.size() > 0:
		for i in range (bets_results_archive.size()-1,-1,-1):
			if bets_results_archive[i][0]==hand_number:
				if bets_results_archive[i][1].get_original_bet().is_preflop():
					bets.append(bets_results_archive[i][1].get_original_bet())
			else:
				return bets
	return bets
	
func results_total_for_hand_number(hand_number):
	var amount = 0
	for i in range (bets_results_archive.size()-1,-1,-1):
		if bets_results_archive[i][0]==hand_number:
			if bets_results_archive[i][1].get_original_bet():
				amount += bets_results_archive[i][1].get_won_or_lost()
		elif i < hand_number:
			break
	amount = round(amount * 100)/100  # nearest penny
	return amount
	
func ok_to_remove_bet(bet):
		match dealer.play_state:
			dealer.PRE_DEAL_STATE:
				return bet.is_preflop()
			dealer.FLOP_COMPLETE_STATE:
				return bet.is_flop()
			dealer.TURN_COMPLETE_STATE:
				return bet.is_turn()
		return false

func reset_bet_type():
	bet_type_coordinator.reset_bet_type_button()
			
func confirm_ready_to_deal(): # make sure there is no partial bet that 
								# the user forgot to place.  
	return bet_gui_coordinator.confirm_ready_to_deal()
	
